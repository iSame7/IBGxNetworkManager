//
//  IBGxNetworkManager.m
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/3/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "IBGxNetworkManager.h"
#import "IBGxJSONRequestRepresenter.h"

/**
 enum that contains the HTTP Methods.
 */
enum HTTPMethod{
    GET,
    POST,
    PUT,
    PATCH,
    DELETE
};
#define KHttpMethods @"GET", @"POST", @"PUT", @"PATCH", @"DELETE", nil

@interface IBGxNetworkManager ()
@property (readwrite, nonatomic, strong) NSURL *baseURL;
@end

@implementation IBGxNetworkManager

+ (instancetype)sharedNetworkManager {

    static IBGxNetworkManager *_sharedManager = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _sharedManager = [[[self class] alloc] init];

    });

    return _sharedManager;
}

- (instancetype)init {
    return [self initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    return [self initWithBaseURL:url sessionConfiguration:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {

    self = [super initWithSessionConfiguration:configuration];
    if (self) {

        // set base url.
        self.baseURL = url;

        self.requestBuilder = [IBGxJSONRequestRepresenter requestBuilder];
    }

    return self;
}

- (void)setResponsBuilder:(id<IBGxURLResponseBuilder>)responsBuilder {

    [super setResponsBuilder:responsBuilder];
}

/**
 A method to convert an enum to string.
 */
-(NSString *) enumRawValue:(enum HTTPMethod)enumVal {

    NSArray *httpMethods = [[NSArray alloc] initWithObjects:KHttpMethods];
    return [httpMethods objectAtIndex:enumVal];
}

- (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{

    NSURLSessionDataTask *dataTask = [self prepareDataTaskWithHTTPMethod:[self enumRawValue:GET] URLString:URLString parameters:parameters success:success failure:failure];

    if (dataTask) {
        NSLog(@"dataTask not nil");
    }
    //All tasks start in a suspended state by default; calling resume starts the data task.
    [dataTask resume];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {


    NSURLSessionDataTask *dataTask = [self prepareDataTaskWithHTTPMethod:[self enumRawValue:POST] URLString:URLString parameters:parameters success:success failure:failure];

    //All tasks start in a suspended state by default; calling resume starts the data task.
    [dataTask resume];
}

-(void)PUT:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {

    NSURLSessionDataTask *dataTask = [self prepareDataTaskWithHTTPMethod:[self enumRawValue:PUT] URLString:URLString parameters:parameters success:success failure:failure];

    //All tasks start in a suspended state by default; calling resume starts the data task.
    [dataTask resume];
}

-(void)PATCH:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {

    NSURLSessionDataTask *dataTask = [self prepareDataTaskWithHTTPMethod:[self enumRawValue:PATCH] URLString:URLString parameters:parameters success:success failure:failure];

    //All tasks start in a suspended state by default; calling resume starts the data task.
    [dataTask resume];
}

-(void)DELETE:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {

    NSURLSessionDataTask *dataTask = [self prepareDataTaskWithHTTPMethod:[self enumRawValue:DELETE] URLString:URLString parameters:parameters success:success failure:failure];

    //All tasks start in a suspended state by default; calling resume starts the data task.
    [dataTask resume];
}

/*
 Generic method to prepare NSURLSessionDataTask.
 */
-(NSURLSessionDataTask *)prepareDataTaskWithHTTPMethod:(NSString*)method URLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id ))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    // Prepare the request.
    // May ask a request builder to build the request.

    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.app.net/stream/0/posts/stream/global"]];
    //    request.HTTPMethod = method;


    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestBuilder requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
        }

        return nil;
    }

    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self createDataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                success(dataTask, responseObject);
            }
        }
    }];
    return  dataTask;
}

@end
