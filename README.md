# IBGxNetworkManager

[![CI Status](http://img.shields.io/travis/isame7/IBGxNetworkManager.svg?style=flat)](https://travis-ci.org/isame7/IBGxNetworkManager)
[![Version](https://img.shields.io/cocoapods/v/IBGxNetworkManager.svg?style=flat)](http://cocoapods.org/pods/IBGxNetworkManager)
[![License](https://img.shields.io/cocoapods/l/IBGxNetworkManager.svg?style=flat)](http://cocoapods.org/pods/IBGxNetworkManager)
[![Platform](https://img.shields.io/cocoapods/p/IBGxNetworkManager.svg?style=flat)](http://cocoapods.org/pods/IBGxNetworkManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

IBGxNetworkManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "IBGxNetworkManager"
```
## IBGxNetworkManager Architecture
```bash
.objc
+-- IBGxNetworkManager
|   +-- IBGxNetworkManager.h
|   +-- IBGxNetworkManager.m
|   +-- IBGxURLSessionFactory.h
|   +-- IBGxURLSessionFactory.m
+-- Protocols
|   +-- IBGxNetworkManagerGateway.h
+-- Serializer
|   +-- IBGxHTTPRequestBuilder.h
|   +-- IBGxHTTPRequestBuilder.m
|   +-- IBGxJSONRequestRepresenter.h
|   +-- IBGxJSONRequestRepresenter.m
|   +-- IBGxHTTPResponseBuilder.h
|   +-- IBGxHTTPResponseBuilder.m
|   +-- IBGxJSONResponseRepresenter.h
|   +-- IBGxJSONResponseRepresenter.m
|   +-- IBGxImageResponseRepresenter.h
|   +-- IBGxImageResponseRepresenter.m
+-- Reachability
|   +-- IBGxRechabilityManager.h
|   +-- IBGxRechabilityManager.m
+-- Constants
|   +-- IBGxNetworkManagerConstants.h
|   +-- IBGxNetworkManagerConstants.m
+-- UIKit+IBGxNetworkManager
|   +-- IBGxImageDownloadManager.h
|   +-- IBGxImageDownloadManager.m
|   +-- UIImageView+IBGxNetworkManager.h
|   +-- UIImageView+IBGxNetworkManager.m
```
## IBGxNetworkManager Core classes:

## IBGxNetworkManager:
Is a generic class that manages executing data requests. It inherites from IBGxURLSessionFactory since this class task is to create and manage url session tasks. IBGxNetworkManager adds methods to act as a generic interface for the end user(developer) like calling GET,POST PUT requests.

##IBGxURLSessionFactory:
Creates and manage NSURLSession object based on the passed NSURLSessionConfiguration. IT contains all delegates of NSURLSession after finishing it calls a callback block to update the caller.

##IBGxNetworkManagerGateway:
Is a generic protocol adopted by IBGxNetworkManager that contain API/methods to be called by end user of this Framework. The benefit of this protocol is that it acheive the Dpendency inversion priciple (DIP) as at any time i can replace IBGxNetworkManager with another object at any time. 

##IBGxHTTPRequestBuilder:
This class offer a base implementation of query string / URL form-encoded parameter serialization. 

##IBGxJSONResponseRepresenter:
IBGxJSONResponseRepresenter encodes parameters as JSON using `NSJSONSerialization`, by setting the `Content-Type` of the encoded request to `application/json`.

##IBGxHTTPResponseBuilder:
This class offer a base implementation for serializing a response.

##IBGxJSONResponseRepresenter:
 IBGxJSONResponseRepresenter is used to represent a JSON response, It validate and decode a JSON response.

##IBGxImageResponseRepresenter:
IBGxImageResponseRepresenter is used to validate and decode image responses. This class is heavily inspired from AFNetworking.

##IBGxImageResponseRepresenter:
IBGxImageDownloadManager is used to download image Async.

##UIImageView+IBGxNetworkManager:
UIImageView+IBGxNetworkManager is a Category to extend UIImageView by adding a method to load image Async `setImageWithURL`


Usage
-----
An example of creating a Data Task:

- Initialize IBGxNetworkManager instance


    IBGxNetworkManager *networkManager = [[IBGxNetworkManager alloc] initWithSessionConfiguration:defaultConfiguration];
    NSURLSessionDataTask *dataTask;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
     dataTask = [self.networkManager createDataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        if (error) {
            if (failure) {
                failure((NSHTTPURLResponse*)response, error);
            }
        } else {
            if (success) {
                success((NSHTTPURLResponse*)response, responseObject);
            }
        }

    }];
    [dataTask resume];



- Or simply call the API/Methods of IBGxNetworkManager to create a GET, Post, PUT, DELETE, PATCH.

```swift

      IBGxNetworkManager *networkManager = [[IBGxNetworkManager alloc] initWithSessionConfiguration:defaultConfiguration];
     [networkManager GET:@"stream/0/posts/stream/global" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
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
```

- For loading an image of UIImageView Async:

- import this category:


         #import "UIImageView+IBGxNetworkManager.h"
        

 - Then call setImageWithURL as follows:
 - note: this methode shall display a spinner while loading image.



                  [self.imageView setImageWithURL:[NSURL URLWithString:@"http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg"]];


## Author

isame7, mabrouksameh@gmail.com

## License

IBGxNetworkManager is available under the MIT license. See the LICENSE file for more info.
