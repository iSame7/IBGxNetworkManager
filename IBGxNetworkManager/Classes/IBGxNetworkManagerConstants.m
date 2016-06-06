//
//  IBGxNetworkManagerConstants.m
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/5/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "IBGxNetworkManagerConstants.h"

NSString * const kBackgroundIdentifier = @"com.smapps.IBGxNetworkManager.background";

// IBGxHTTPResposeBuilder
NSString * const IBGxURLResponseBuilderErrorDomain = @"com.smapps.IBGxNetworkManager.builder.response";
NSString * const IBGxURLResponseDataErrorKey = @"com.smapps.IBGxNetworkManager.builder.response.error.data";

// IBGxHTTPResposeBuilder Error Handler
NSError * const IBxErrorWithUnderlyingError(NSError *error, NSError *underlyingError) {
    if (!error) {
        return underlyingError;
    }

    if (!underlyingError || error.userInfo[NSUnderlyingErrorKey]) {
        return error;
    }

    NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
    mutableUserInfo[NSUnderlyingErrorKey] = underlyingError;

    return [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:mutableUserInfo];
}

extern BOOL const IBxErrorOrUnderlyingErrorHasCodeInDomain(NSError *error, NSInteger code, NSString *domain) {

    if ([error.domain isEqualToString:domain] && error.code == code) {
        return YES;
    } else if (error.userInfo[NSUnderlyingErrorKey]) {
        return IBxErrorOrUnderlyingErrorHasCodeInDomain(error.userInfo[NSUnderlyingErrorKey], code, domain);
    }

    return NO;
}