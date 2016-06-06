//
//  UIImageView+IBGxNetworkManager.m
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/5/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "UIImageView+IBGxNetworkManager.h"
#import "IBGxImageDownloadManager.h"

#import <objc/runtime.h>

@implementation UIImageView (IBGxNetworkManager)

/* 
 One really neat feature of Objective-C runtime is that it lets you extend an object with additional data using a mechanism called associated objects.
 */
+ (IBGxImageDownloadManager *)sharedImageDownloadManager {

    return objc_getAssociatedObject(self, @selector(sharedImageDownloadManager)) ?: [IBGxImageDownloadManager sharedInstance];
}

+ (void)setSharedImageDownloadManager:(IBGxImageDownloadManager *)imageDownloadManager {

    objc_setAssociatedObject(self, @selector(sharedImageDownloadManager), imageDownloadManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setImageWithURL:(NSURL *)url {
    NSLog(@"setImageWithURL");
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    // By default show spinner while image is being downloaded.

    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [activityIndicator startAnimating];
    [self addSubview:activityIndicator];

    IBGxImageDownloadManager *downloadManager = [[self class] sharedImageDownloadManager];
    __weak __typeof(self)weakSelf = self;
    [downloadManager downloadImageForURLRequest:request success:^(NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {

        NSLog(@"Image Data %@", responseObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.image = responseObject;

            // Stop and remove spinner.
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        });

    } failure:^(NSHTTPURLResponse * _Nullable responseObject, NSError * _Nonnull error) {
        NSLog(@"Error %@", error);

        // Stop and remove spinner.
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
    }];


}

@end
