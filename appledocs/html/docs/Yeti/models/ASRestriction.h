//
//  Created by Charles Morss on 12/31/12.
//  Copyright (c) 2012 Audiosocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "ASObject.h"

/**
* Restrictions describe situations in which a track shouldn’t be used.
* For example, an artist may wish their music to never be used in a film,
* show, or game where violence is celebrated.
* See the Audiosocket API docs on
* [restrictions](http://develop.audiosocket.com/v5-api#restrictions).
*/
@interface ASRestriction : ASObject

@end
