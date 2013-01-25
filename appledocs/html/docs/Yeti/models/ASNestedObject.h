//
//  ASNestedObject.h
//  yeti
//
//  Created by Charles Morss on 1/7/13.
//  Copyright (c) 2013 Audiosocket. All rights reserved.
//

#import "ASObject.h"

/**
* Superclass for ASObjects that are hierarchical in nature, e.g. genres, moods, etc.
*/

@interface ASNestedObject : ASObject

@property (nonatomic) NSArray *children;

/**
* Return 'self' if targetID is equal self.ID, otherwise iterate over
* children looking for a match.
*
* @param targetID ID to compare to.
*/
- (ASObject *)resolve:(NSNumber *)targetID;

@end
