//
//  ASApi.h
//  yeti
//
//  Created by Charles Morss on 1/3/13.
//  Copyright (c) 2013 Audiosocket. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef _AUDIOSOCKET_
#define _AUDIOSOCKET_

#import "ASAlbum.h"
#import "ASArtist.h"
#import "ASCategory.h"
#import "ASContext.h"
#import "ASEnding.h"
#import "ASGenre.h"
#import "ASInstrument.h"
#import "ASIntro.h"
#import "ASLanguage.h"
#import "ASMood.h"
#import "ASNestedObject.h"
#import "ASObject.h"
#import "ASRestriction.h"
#import "ASTempo.h"
#import "ASTheme.h"
#import "ASTrack.h"
#import "ASVocal.h"

#endif /* _AUDIOSOCKET_ */

extern NSString * const AudiosocketAPIToken;
extern NSString * const AudiosocketBaseURL;

/**
* Allows for initialization of the Audiosocket Yeti SDK.
*/

/*
* Copyright 2013 Audiosocket
*
*   Licensed under the Apache License, Version 2.0 (the "License");
*   you may not use this file except in compliance with the License.
*   You may obtain a copy of the License at
*
*       http://www.apache.org/licenses/LICENSE-2.0
*
*   Unless required by applicable law or agreed to in writing, software
*   distributed under the License is distributed on an "AS IS" BASIS,
*   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*   See the License for the specific language governing permissions and
*   limitations under the License.
*/

@interface ASApi : NSObject

/**
* Turn trace logging on or off. If you're having troubles sometimes seeing the full
* RestKit trace logs can be very helpful.
*
* @param trace YES to turn trace logging on, NO to turn it off.
*/
+ (void)traceLog:(BOOL)trace;

/**
* Initialize SDK by setting up the base url and providing a token. This method must
* be called prior to any other calls to the SDK.
*
* @param baseURL For production V5 access use "https://api.audiosocket.com/v5"
* @param token   Token provided to you by Audiosocket. If you need a token please
*                contact Audiosocket at api@audiosocket.com
*/

+ (void) initWithBaseURL:(NSString *)baseURL
                   token:(NSString *)token;

@end
