//
//  IBGxNetworkManager.h
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/3/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBGxNetworkManagerGateway.h"
#import "IBGxURLSessionFactory.h"
#import "IBGxHTTPRequestBuilder.h"
#import "IBGxJSONRequestRepresenter.h"
#import "IBGxHTTPResponseBuilder.h"

/**
 * Generic network interface manager for executing data requests.
 */

NS_ASSUME_NONNULL_BEGIN

@interface IBGxNetworkManager : IBGxURLSessionFactory <IBGxNetworkManagerGateway>

/**
 Request base URL.
 */
@property (readonly, nonatomic, strong, nullable) NSURL *baseURL;


@property (nonatomic, strong) IBGxJSONRequestRepresenter <IBGxHTTPRequestBuilder> * requestBuilder;
@property (nonatomic, strong) IBGxHTTPResponseBuilder <IBGxURLResponseBuilder> * responseBuilder;

/*!
 @brief Create a singlton of IBGxNetworkManager.
 @return Initialized IBGxNetworkManager object
 */
+ (instancetype)sharedNetworkManager;

/**
 Initializes an `IBGxNetworkManager` object with the specified base URL.

 @param url The base URL for the HTTP client.

 @return Initialized IBGxNetworkManager object
 */
- (instancetype)initWithBaseURL:(nullable NSURL *)url;


/**
 Initializes an `IBGxNetworkManager` object with the specified base URL.

 This is the designated initializer.

 @param url The base URL.
 @param configuration The configuration used to create the session.

 @return Initialized IBGxNetworkManager object
 */
- (instancetype)initWithBaseURL:(nullable NSURL *)url
           sessionConfiguration:(nullable NSURLSessionConfiguration *)configuration;

@end

NS_ASSUME_NONNULL_END
