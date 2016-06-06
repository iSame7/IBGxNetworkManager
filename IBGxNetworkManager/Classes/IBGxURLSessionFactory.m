//
//  IBGxURLSessionFactory.m
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/3/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "IBGxURLSessionFactory.h"

#import "IBGxNetworkManagerConstants.h"

#import "IBGxRechabilityManager.h"

#import "IBGxJSONResponseRepresenter.h"

/*
#import <SystemConfiguration/SystemConfiguration.h>

#import <netinet/in.h>
#import <netinet6/in6.h>
*/
/*
 // simple mehod that check network reachability without using third party library.
 - (BOOL)isInternetReachable
 {
 struct sockaddr_in zeroAddress;
 bzero(&zeroAddress, sizeof(zeroAddress));
 zeroAddress.sin_len = sizeof(zeroAddress);
 zeroAddress.sin_family = AF_INET;

 SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
 SCNetworkReachabilityFlags flags;

 if(reachability == NULL)
 return false;

 if (!(SCNetworkReachabilityGetFlags(reachability, &flags)))
 return false;

 if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
 // if target host is not reachable
 return false;


 BOOL isReachable = false;


 if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
 {
 // if target host is reachable and no connection is required
 //  then we'll assume (for now) that your on Wi-Fi
 isReachable = true;
 }


 if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
 {
 // ... and the connection is on-demand (or on-traffic) if the
 //     calling application is using the CFSocketStream or higher APIs

 if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
 {
 // ... and no [user] intervention is needed
 isReachable = true;
 }
 }

 if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlag)
 {
 // ... but WWAN connections are OK if the calling application
 //     is using the CFNetwork (CFSocketStream?) APIs.
 isReachable = true;
 }

 return isReachable;

 }
*/


// concurrent queue for handling session task delegates.
static dispatch_queue_t url_session_factory_concurrent_queue() {
    static dispatch_queue_t concurrentDelegateQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        concurrentDelegateQueue = dispatch_queue_create("com.smapps.IBGxNetworkManager.delegatesQueue", DISPATCH_QUEUE_CONCURRENT);
    });

    return concurrentDelegateQueue;
}

// concurrent queue for handling result of request.
static dispatch_queue_t url_session_factory_result_queue() {
    static dispatch_queue_t ibgx_url_session_factory_result_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ibgx_url_session_factory_result_queue = dispatch_queue_create("com.smapps.IBGxNetworkManager.result", DISPATCH_QUEUE_CONCURRENT);
    });

    return ibgx_url_session_factory_result_queue;
}

static dispatch_group_t url_session_factory_callback_group() {
    static dispatch_group_t ibgx_url_session_factory_callback_group;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ibgx_url_session_factory_callback_group = dispatch_group_create();
    });

    return ibgx_url_session_factory_callback_group;
}

typedef void (^IBGxURLSessionFactoryTaskCallback)(NSURLResponse *response, id responseObject, NSError *error);

@interface IBGxURLSessionFactoryTaskDelegate : NSObject <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
@property (nonatomic, weak) IBGxURLSessionFactory *sessionfactory;
@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, copy) IBGxURLSessionFactoryTaskCallback callback;
@end

@implementation IBGxURLSessionFactoryTaskDelegate

-(instancetype)init {
    self = [super init];
    if (self) {
        self.mutableData = [NSMutableData data];
    }

    return self;
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"didCompleteWithError-Delegate");

    __strong IBGxURLSessionFactory *sessionFactory = self.sessionfactory;
    __block id responseObject = nil;

    NSData *data = nil;
    if (self.mutableData) {
        data = [self.mutableData copy];
        //We no longer need the reference, so nil it out to gain back some memory.
        self.mutableData = nil;
    }

    if (error) {

        dispatch_group_async(sessionFactory.completionGroup ?: url_session_factory_callback_group(), sessionFactory.completionQueue ?: dispatch_get_main_queue(), ^{
            if (self.callback) {
                self.callback(task.response, responseObject, error);
            }

        });
    }
    else {
        dispatch_async(url_session_factory_result_queue(), ^{
            NSError *serializationError = nil;
            responseObject = [sessionFactory.responsBuilder responseObjectForResponse:task.response data:data error:&serializationError];


            dispatch_group_async(sessionFactory.completionGroup ?: url_session_factory_callback_group(), sessionFactory.completionQueue ?: dispatch_get_main_queue(), ^{
                if (self.callback) {
                    self.callback(task.response, responseObject, error);
                }

            });
        });
    }


/*
    dispatch_async(dispatch_get_main_queue(), ^{
        self.callback(task.response, data, nil);
    });
 */
}

#pragma mark - NSURLSessionDataTaskDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"didReceiveData-Delegate");
    [self.mutableData appendData:data];
}

@end

@interface IBGxURLSessionFactory ()
@property (readwrite, nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (readwrite, nonatomic, strong) NSOperationQueue *operationQueue;
@property (readwrite, nonatomic, strong) NSURLSession *session;
@property (readwrite, nonatomic, strong) NSMutableDictionary *taskDelegatesDict;
@end

@implementation IBGxURLSessionFactory

- (instancetype)init {
    return [self initWithSessionConfiguration:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {

    self = [super init];
    if (self) {

        if (!configuration) {
            configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:kBackgroundIdentifier];
        }

        self.sessionConfiguration = configuration;

        self.operationQueue = [[NSOperationQueue alloc] init];

        //TODO: check here if network is WIFI so maxConcurrentOperationCount = 6, else if network is Cellular so maxConcurrentOperationCount = 2
        IBGxRechabilityManager *internetReach = [IBGxRechabilityManager reachabilityForInternetConnection];
        [internetReach startNotifier];

        NetworkStatus netStatus = [internetReach currentReachabilityStatus];

        switch (netStatus)
        {
            case ReachableViaWWAN:
            {
                NSLog(@"ReachableViaWWAN");
                self.operationQueue.maxConcurrentOperationCount = 2;
                break;
            }
            case ReachableViaWiFi:
            {   NSLog(@"ReachableViaWiFi");

                self.operationQueue.maxConcurrentOperationCount = 6;
                break;
            }
            default:

                self.operationQueue.maxConcurrentOperationCount = 1;
        }

        self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:self.operationQueue];

        self.responsBuilder = [IBGxJSONResponseRepresenter responseBuilder];
        
        self.taskDelegatesDict = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (IBGxURLSessionFactoryTaskDelegate *)getDelegateForTask:(NSURLSessionTask *)task {

    __block IBGxURLSessionFactoryTaskDelegate *delegate = nil;
    dispatch_sync(url_session_factory_concurrent_queue(), ^{
        delegate = self.taskDelegatesDict[@(task.taskIdentifier)];
    });
    return delegate;
}

- (void)setDelegate:(IBGxURLSessionFactoryTaskDelegate *)delegate
            forTask:(NSURLSessionTask *)task {

    // make this code thread safe.
    dispatch_barrier_async(url_session_factory_concurrent_queue(), ^{
        self.taskDelegatesDict[@(task.taskIdentifier)] = delegate;
    });
}

-(void)addDelegateForDataTask:(NSURLSessionDataTask *)dataTask completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{

    IBGxURLSessionFactoryTaskDelegate *delegate = [[IBGxURLSessionFactoryTaskDelegate alloc] init];
    delegate.sessionfactory = self;
    delegate.callback = completionHandler;

    [self setDelegate:delegate forTask:dataTask];
}

- (void)removeDelegateForTask:(NSURLSessionTask *)task {
    // make this code thread safe.
    dispatch_barrier_async(url_session_factory_concurrent_queue(), ^{
        [self.taskDelegatesDict removeObjectForKey:@(task.taskIdentifier)];
    });
}

- (NSURLSessionDataTask *)createDataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse * _Nonnull, id _Nullable, NSError * _Nullable))completionHandler {

    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    // assign delegate to datatask.
    [self addDelegateForDataTask:dataTask completionHandler:completionHandler];
    return dataTask;
}

/** 
 Setter for responsBuilder instance, becuase it's value can be changed from sub class like IBGxNetworkManager.
 */
-(void)setResponsBuilder:(id<IBGxURLResponseBuilder>)responsBuilder {
        _responsBuilder = responsBuilder;
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session
didBecomeInvalidWithError:(NSError *)error
{
    NSLog(@"didBecomeInvalidWithError");
}
- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    // Requests credentials from the delegate in response to a session-level authentication request from the remote server.

    NSLog(@"didBecomeInvalidWithError");
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];

    completionHandler(disposition, credential);
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest *))completionHandler
{

}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{

}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    NSLog(@"didCompleteWithError");

    IBGxURLSessionFactoryTaskDelegate *delegate = [self getDelegateForTask:task];

    // delegate may be nil when completing a task in the background
    if (delegate) {
        [delegate URLSession:session task:task didCompleteWithError:error];

        [self removeDelegateForTask:task];
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{

    NSLog(@"DataTasK: didReceiveData");
    
    IBGxURLSessionFactoryTaskDelegate *delegate = [self getDelegateForTask:dataTask];
    [delegate URLSession:session dataTask:dataTask didReceiveData:data];
    
}

@end
