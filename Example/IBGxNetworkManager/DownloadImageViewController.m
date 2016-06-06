//
//  DownloadImageViewController.m
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/5/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "DownloadImageViewController.h"
#import "UIImageView+IBGxNetworkManager.h"
#import "Post.h"

@interface DownloadImageViewController ()

@end

@implementation DownloadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.imageView setImageWithURL:[NSURL URLWithString:@"http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg"]];

    /*
    [Post globalTimelinePostsWithBlock:^(NSArray *posts, NSError *error) {
        if (!error) {
            //            NSLog(@"Posts %@", posts);
        }
    }];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
