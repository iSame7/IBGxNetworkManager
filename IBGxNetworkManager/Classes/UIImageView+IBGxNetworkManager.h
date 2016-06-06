//
//  UIImageView+IBGxNetworkManager.h
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/5/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBGxImageDownloadManager.h"

@interface UIImageView (IBGxNetworkManager)

/**
 Set the shared image download manager used to download images.

 @param imageDownloader The shared image download manager used to download images.
 */
+ (void)setSharedImageDownloadManager:(IBGxImageDownloadManager *)imageDownloadManager;

/**
 The shared image download manager used to download images.
 */
+ (IBGxImageDownloadManager *)sharedImageDownloadManager;

/** 
 Allow images to be downloaded Async using IBGxImageDownloadManager.

 @param url The image request url.
 */
- (void)setImageWithURL:(NSURL *)url;
@end
