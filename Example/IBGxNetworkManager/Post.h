//
//  IBGxAPIClient.h
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/4/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (nonatomic, assign) NSUInteger postID;
@property (nonatomic, strong) NSString *text;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+ (void)getPostsWithBlock:(void (^)(NSArray *posts, NSError *error))block;

@end