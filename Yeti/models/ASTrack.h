//
//  ASMood.h
//  yeti
//
//  Created by Charles Morss on 12/31/12.
//  Copyright (c) 2012 Audiosocket. All rights reserved.
//

#import "ASObject.h"
#import "ASAlbum.h"
#import "ASArtist.h"

@interface ASTrack : ASObject

@property (strong, readonly) NSNumber *length;
@property (strong, readonly) ASAlbum  *album;
@property (strong, readonly) ASArtist *artist;
@property (strong, readonly) NSURL    *streamingURL;

@property (readonly) NSUInteger endingID;
@property (readonly) NSUInteger introID;
@property (readonly) BOOL       explicit;

@property (strong, readonly) NSArray *genreIDs;
@property (strong, readonly) NSArray *instrumentsIDs;
@property (strong, readonly) NSArray *languagesIDs;
@property (strong, readonly) NSArray *moodsIDs;
@property (strong, readonly) NSArray *restrictionsIDs;
@property (strong, readonly) NSArray *temposIDs;
@property (strong, readonly) NSArray *themesIDs;
@property (strong, readonly) NSArray *vocalsIDs;

- (void)loadStreamingURLWithSuccess:(void (^)(ASTrack *))success
                            failure:(void (^)(NSError *))failure;

@end
