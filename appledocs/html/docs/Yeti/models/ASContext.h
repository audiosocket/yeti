//
//  ASContext.h
//  yeti
//
//  Created by Charles Morss on 1/4/13.
//  Copyright (c) 2013 Audiosocket. All rights reserved.
//

#import "ASObject.h"

/**
* The context contains all musical classification entities available.
* It is much easier and faster to issue a single loadWithSuccess:failure
* call then it is to separately load each entity collection separately.
*/
@interface ASContext : ASObject

@property (nonatomic) NSArray *languages;
@property (nonatomic) NSArray *categories;
@property (nonatomic) NSArray *endings;
@property (nonatomic) NSArray *genres;
@property (nonatomic) NSArray *instruments;
@property (nonatomic) NSArray *intros;
@property (nonatomic) NSArray *moods;
@property (nonatomic) NSArray *restrictions;
@property (nonatomic) NSArray *tempos;
@property (nonatomic) NSArray *themes;
@property (nonatomic) NSArray *vocals;

/**
* Initiates a request to retrieve the context.
*
* @param success If supplied called with the newly retrieved context instance
*
* @param failure If supplied called when an error occurs issuing the request.
*/
+ (void)loadWithSuccess:(void (^)(ASContext *))success
                failure:(void (^)(NSError *))failure;

/**
* Resolves object ids to actual ASObject instances. This context must have been
* loaded first.
*
* @param ids    Array of ids to resolve
* @param klass  Expected ASObject subclass to resolve ids to.
*
* @returns      Resolved objects. NULL if this context has not been loaded.
*
* @exceptions   If a class passed in that this context doesn't understand.
*/
- (NSArray *)resolveIDs:(NSArray *)ids
               forClass:(Class)klass;
@end
