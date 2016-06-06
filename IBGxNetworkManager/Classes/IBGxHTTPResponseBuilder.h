//
//  IBGxURLResposeBuilder.h
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/4/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 
 IBGxURLResponseBuilder protocol is used to be conformed by other objects that decodes data into object representation.
 */
@protocol IBGxURLResponseBuilder <NSObject>

/**
 The response object decoded from the data associated with a specified response.

 @param response The response to be processed.
 @param data The response data to be decoded.
 @param error The error that occurred while attempting to decode the response data.

 @return The object decoded from the specified response data.
 */
- (nullable id)responseObjectForResponse:(nullable NSURLResponse *)response
                                    data:(nullable NSData *)data
                                   error:(NSError * _Nullable *)error ;

@end

@interface IBGxHTTPResponseBuilder : NSObject <IBGxURLResponseBuilder>

- (instancetype)init;

/**
 The string encoding used to build data received from the server. */
@property (nonatomic, assign) NSStringEncoding stringEncoding;

/**
 Creates and returns a builder with default configuration.
 */
+ (instancetype)responseBuilder;

/**
 The acceptable HTTP status codes for responses.
 */
@property (nonatomic, copy, nullable) NSIndexSet *acceptableStatusCodes;

/**
 The acceptable MIME types for responses.
 */
@property (nonatomic, copy, nullable) NSSet <NSString *> *acceptableContentTypes;

/**
 Validates the specified response and data.

 In its base implementation, this method checks for an acceptable status code and content type. Subclasses may wish to add other domain-specific checks.

 @param response The response to be validated.
 @param data The data associated with the response.
 @param error The error that occurred while attempting to validate the response.

 @return `YES` if the response is valid, otherwise `NO`.
 */
- (BOOL)validateResponse:(nullable NSHTTPURLResponse *)response
                    data:(nullable NSData *)data
                   error:(NSError * _Nullable __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
