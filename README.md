# Yeti - Audiosocket iOS SDK

Yeti is an iOS SDK comprised of Objective-C objects that provide simplified access to a
subset of the [Audiosocket MaaS API](http://http://develop.audiosocket.com/).
MaaS provides a rich integration API that allows you to search, stream, and license
thousands of tracks from the world's best
independent musicians. Need help? Want more info or an API key?
Drop us a line at api@audiosocket.com and we'll get you squared away.

Please take time to read through the [Audiosocket MaaS API](http://http://develop.audiosocket.com/) to get
a better understanding of the underlying REST API that Yeti accesses.
The underlying data used for querying the API and paginating are very similar in Yeti.
Class level documentation for Yeti is available at (http://develop.audiosocket.com/yeti)

Yeti takes full advantage of the excellent [RestKit](https://github.com/RestKit/RestKit)
framework  by [Blake Watters](http://twitter.com/blakewatters) and the rest of the RestKit team.

## Installation

Installation is done via the [CocoaPods](http://cocoapods.org/) package manager.

Install CocoaPods if you haven't already:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Create a text file called Podfile in your project directory:

``` bash
$ cd /path/to/ProjectDirectory
$ vi Podfile
platform :ios, '5.0'

pod 'RestKit', '~> 0.20.0pre'
pod 'Yeti', :local => "../Yeti"
```

Download all dependencies defined in `Podfile' and creates an Xcode Pods library project:

``` bash
$ pod install
```

Open your project in Xcode from the workspace file (.xcworkspace) file:

``` bash
$ open <Project>.xcworkspace
```

## Getting started

The easiest way to get started is to simply initialize the API in your
AppDelegate didFinishLaunchingWithOptions: method. This call initializes the API
so you can make subsequent network requests. It makes no network requests itself.

```
#import <Yeti/Yeti.h>
#import "AppDelegate.h"

@implementation AppDelegate

// API_BASE_URL   Normally https://api.audiosocket.com/v5 for the production environment.
//                A sandbox environemnt is also available upon request.
// YOUR_API_TOKEN Account token provided to you by Audiosocket.

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ASApi initWithBaseURL:@"API_BASE_URL" token:@"YOUR_API_TOKEN"];

    return YES;
}
```

## Searching for tracks

Tracks are the heart of the Audiosocket MaaS plaform. The ASTrack class uses the same search parameters
as the Audiosocket Rest API. See [Searching for Music](http://develop.audiosocket.com/v5-api#searching)
for the details of each search parameter.

```
NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:@{@"q" : @"sunny"}];
ASPaginator tracks = [[ASPaginator alloc] initWithTargetClass:[ASTrack class]];

[tracks search:dict
       success:^(ASPaginator *paginator) {
           // Do something with your loaded paginator, e.g. [tableView reloadData];
       }
       failure:^(NSError *error) {
           NSLog(@"Error searching for tracks %@", error);
       }
];
```

## Loading the context

The ASContext is a wrapper around all the classification information available in the Audiosocket MaaS platform.

```
    [ASContext loadWithSuccess:^(ASContext *context) {
        // Save off context for later...
    } failure:^(NSError *error) {
        NSLog(@"Error loading context");
    }];

```

### Using the context to resolve classification entities

When you use the 'with' parameter when searching for tracks classification
information can be returned. However, the information returned is most
often simply IDs of classification entities. To resolve those IDs into
the actual useful objects do the following *after* the context has been loaded.
This assumes you specified 'g' for genres when performing your search.

```
ASGenre *genres = [context resolveIDs:track.genreIDs forClass:[ASGenre class]];
```

## Streaming audio

The Yeti SDK does not provide a component to play the audio of a track. However,
getting a temporary URL to stream the audio is, of course, possible.

```
[track loadStreamingURLWithSuccess:^(ASTrack *trackWithURL) {
                                // Pass trackWithURL.streamingURL to your audio player
                           }
                           failure:^(NSError *error) {
                               NSLog(@"Error retrieving URL: %@", error);
                           }
];
```

## License

Yeti is licensed under the terms of the [Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).
Please see the [LICENSE](https://github.com/Yeti/Yeti/blob/master/LICENSE) file for full details.

RestKit is also licensed under the terms of the [Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).
Please see the [LICENSE](https://github.com/RestKit/RestKit/blob/master/LICENSE) file for full details.
