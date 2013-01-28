# Yeti - Audiosocket iOS SKD

Yeti is a iOS SDK comprised of Objective-C objects that provide simplified access to the
[Audiosocket MaaS API](http://http://develop.audiosocket.com/).
MaaS provides a rich integration API that allows you to search, stream, and license
thousands of tracks from the world's best
independent musicians. Need help? Want more info or an API key?
Drop us a line at api@audiosocket.com and we'll get you squared away.

Please take time to read through the [Audiosocket MaaS API](http://http://develop.audiosocket.com/) to get
a better understanding of the underlying REST API that Yeti accesses.
The underlying data used for querying the API and paginating are very similar in Yeti.

Yeti takes full advantage of the excellent [RestKit](https://github.com/RestKit/RestKit)
framework  by [Blake Watters](http://twitter.com/blakewatters) and the rest of the RestKit team.

## Installation

Installation is done via the [CocoaPods](http://cocoapods.org/) package manager,
as it provides flexible dependency management and dead simple installation.

Install CocoaPods if you haven't already

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Create a text file called Podfile in your project directory.

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

Open your project in Xcode from the workspace file (.xcworkspace) file.

``` bash
$ open <Project>.xcworkspace
```

## Getting started

The easiest way to get started is to simply initialize the API in your
AppDelegate didFinishLaunchingWithOptions: method. This call initializes the API
so you can make subsequent network requests but it makes no network requests itself.

```
#import <Yeti/Yeti.h>
#import "AppDelegate.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // API_BASE_URL is normally https://api.audiosocket.com/v5 for the production environment.
    // A sandbox environemnt is also available upon request.
    //
    // YOUR_API_TOKEN is the account token provided to you by Audiosocket.

    [ASApi initWithBaseURL:@"API_BASE_URL" token:@"YOUR_API_TOKEN"];

    return YES;
}
```


## License

Yeti is licensed under the terms of the [Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).
Please see the [LICENSE](https://github.com/Yeti/Yeti/blob/master/LICENSE) file for full details.

RestKit is also licensed under the terms of the [Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).
Please see the [LICENSE](https://github.com/RestKit/RestKit/blob/master/LICENSE) file for full details.
