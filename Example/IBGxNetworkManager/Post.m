//
//  IBGxAPIClient.h
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/4/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "Post.h"

#import "IBGxAPIClient.h"

@implementation Post

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.postID = (NSUInteger)[[attributes valueForKeyPath:@"id"] integerValue];
    self.text = [attributes valueForKeyPath:@"text"];

    return self;
}


+ (void)getPostsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
    return [[IBGxAPIClient sharedClient] GET:@"stream/0/posts/stream/global" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {

        NSArray *postsFromResponse = [JSON valueForKeyPath:@"data"];
        
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            Post *post = [[Post alloc] initWithAttributes:attributes];
            [mutablePosts addObject:post];
        }

        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }

    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}


@end
