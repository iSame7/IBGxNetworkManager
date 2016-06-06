//
//  IBGxJSONRequestRepresenter.h
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/5/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "IBGxHTTPRequestBuilder.h"


@interface IBGxJSONRequestRepresenter : IBGxHTTPRequestBuilder

/**
 Options for writing the request JSON data from Foundation objects.
 */
@property (nonatomic, assign) NSJSONWritingOptions writingOptions;

/**
 Creates and returns a JSON serializer with specified reading and writing options.

 @param writingOptions The specified JSON writing options.
 */
+ (instancetype)JSONRepresenterWithWritingOptions:(NSJSONWritingOptions)writingOptions;


@end
