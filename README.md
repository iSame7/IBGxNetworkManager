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




## Author

isame7, mabrouksameh@gmail.com

## License

IBGxNetworkManager is available under the MIT license. See the LICENSE file for more info.
