//
//  IBGxImageResponseRepresenter.h
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/5/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "IBGxHTTPResponseBuilder.h"

/**
 IBGxImageResponseRepresenter is used to validate and decode image responses. This class is heavily inspired from AFNetworking.
 */
@interface IBGxImageResponseRepresenter : IBGxHTTPResponseBuilder

/**
 The scale factor used when interpreting the image data to construct `responseImage`.
 */
@property (nonatomic, assign) CGFloat imageScale;

/**
 Whether to automatically inflate response image data for compressed formats (such as PNG or JPEG).
 */
@property (nonatomic, assign) BOOL automaticallyInflatesResponseImage;

@end
