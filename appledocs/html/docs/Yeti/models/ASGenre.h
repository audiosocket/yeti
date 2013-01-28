//
//  Created by Charles Morss on 12/31/12.
//  Copyright (c) 2012 Audiosocket. All rights reserved.
//

#import "ASNestedObject.h"

/**
* A genre is a category of music, grouping similar tracks together.
* Genres are organized in a tree.
* See the Audiosocket API docs on [genres](http://develop.audiosocket.com/v5-api#genres).
*/
@interface ASGenre : ASNestedObject

@property (nonatomic) Boolean display;

@end
