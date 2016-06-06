//
//  IBGxNetworkManagerConstants.h
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/5/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <UIKit/UIKit.h>

// IBGxURLSessionFactory background session.
extern NSString * const kBackgroundIdentifier;

// IBGxHTTPResponseBuilder
extern NSString * const IBGxURLResponseBuilderErrorDomain;
extern NSString * const IBGxURLResponseDataErrorKey;

// IBGxHTTPResposeBuilder Error Handler
extern NSError * const  IBxErrorWithUnderlyingError(NSError *error, NSError *underlyingError);
extern BOOL const IBxErrorOrUnderlyingErrorHasCodeInDomain(NSError *error, NSInteger code, NSString *domain);
