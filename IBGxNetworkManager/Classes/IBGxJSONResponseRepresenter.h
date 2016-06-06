//
//  IBGxJSONResponseRepresenter.h
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/5/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBGxHTTPResponseBuilder.h"
/**
 IBGxJSONResponseRepresenter is used to represent a JSON response, It validate and decode a JSON response.
 */
@interface IBGxJSONResponseRepresenter : IBGxHTTPResponseBuilder

- (instancetype)init;

/**
 Options for reading the response JSON data and creating the Foundation objects.
 */
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;

/**
 Whether to remove keys with `NSNull` values from response JSON. Defaults to `NO`.
 */
@property (nonatomic, assign) BOOL removesKeysWithNullValues;

/**
 Creates and returns a JSON serializer with specified reading and writing options.

 @param readingOptions The specified JSON reading options.
 */
+ (instancetype)JSONRepresenterWithReadingOptions:(NSJSONReadingOptions)readingOptions;

@end
