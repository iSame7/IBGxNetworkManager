//
//  IBGxImageDownloadManager.h
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/5/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "IBGxNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 IBGxImageDownloadManager is used to download image Async.
 */
@interface IBGxImageDownloadManager : NSObject

/**
 IBGxNetworkManager object used to download images.
 */
@property (nonatomic, strong) IBGxNetworkManager *networkManager;

/**
 Shared instance of IBGxImageDownloadManager.
 */
+ (instancetype)sharedInstance;

/**
 Default initializer

 @return An instance of IBGxImageDownloadManager initialized with default values.
 */
- (instancetype)init;

/**
 Initializes the IBGxImageDownloadManager instance with the given IBGxNetworkManager.

 @param sessionManager The session manager to use to download images.

 @return The new IBGxImageDownloadManager instance.
 */
- (instancetype)initWithIBGxNetworkManager:(IBGxNetworkManager *)networkManager;

/**
 Creates a data task using the IBGxNetworkManager instance for the specified URL request.

 @param request The URL request.
 @param success A block to be executed when the image data task finishes successfully.
 @param failure A block object to be executed when the image data task finishes unsuccessfully.
 */
- (void)downloadImageForURLRequest:(NSURLRequest *)request success:(void (^)(NSHTTPURLResponse * _Nullable, UIImage * _Nonnull))success failure:(void (^)( NSHTTPURLResponse * _Nullable, NSError * _Nonnull))failure;

@end

NS_ASSUME_NONNULL_END
