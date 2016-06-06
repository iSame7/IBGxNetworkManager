//
//  IBGxURLSessionFactory.h
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/3/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBGxRechabilityManager.h"
#import "IBGxHTTPResponseBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBGxURLSessionFactory : NSObject <NSURLSessionDelegate>

/**
 The managed session.
 */
@property (readonly, nonatomic, strong) NSURLSession *session;

/**
 The operation queue which run delegate callbacks.
 */
@property (readonly, nonatomic, strong) NSOperationQueue *operationQueue;

/**
 Responses sent from the server in data task.
 */
@property (nonatomic, strong) id <IBGxURLResponseBuilder> responsBuilder;


/**
 The network reachability manager.
 */
@property (readwrite, nonatomic, strong) IBGxRechabilityManager *reachabilityManager;


// The data, upload, and download tasks currently run by the managed session.
@property (readonly, nonatomic, strong) NSArray <NSURLSessionTask *> *tasks;


//The data tasks currently run by the managed session.
@property (readonly, nonatomic, strong) NSArray <NSURLSessionDataTask *> *dataTasks;


// The dispatch queue for `completionBlock`. If `NULL` (default), the main queue is used.
@property (nonatomic, strong, nullable) dispatch_queue_t completionQueue;


// The dispatch group for `completionBlock`. If `NULL` (default), a private dispatch group is used.
@property (nonatomic, strong, nullable) dispatch_group_t completionGroup;


/**
 Creates and returns a manager for a session created with the specified configuration. This is the designated initializer.

 @param configuration The configuration used to create the session.

 @return Initialized IBGxURLSessionFactory object.
 */
- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration;

/**
 Creates an `NSURLSessionDataTask` with the specified request.

 @param request The HTTP request for the request.
 @param completionHandler A block object to be executed when the task finishes.
 */
- (NSURLSessionDataTask *)createDataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler;
@end

NS_ASSUME_NONNULL_END
