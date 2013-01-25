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
@interface ASApi : NSObject

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
