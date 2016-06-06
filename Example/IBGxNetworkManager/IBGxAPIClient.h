//
//  IBGxAPIClient.h
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/4/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBGxNetworkManager.h"

@interface IBGxAPIClient : IBGxNetworkManager

+ (instancetype)sharedClient;

@end
