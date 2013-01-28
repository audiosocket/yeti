//
//  Created by Charles Morss on 12/31/12.
//  Copyright (c) 2012 Audiosocket. All rights reserved.
//

#import "ASObject.h"
#import "ASAlbum.h"
#import "ASArtist.h"

/**
 Tracks are the heart of the platform, and represent a playable piece of music.
 Methods for Searching and streaming tracks are documented in detail above.
 For speedy results, many track attributes are omitted when searching via
 an ASPaginator. However by using the 'with' parameter when performing a
 search additional attributes or their ids can be retrieved. See
 [the Audiosocket searching API docs](http://develop.audiosocket.com/v5-api#searching)
 for more details on the 'with' parameter. All attributes can be retrieved from the
 track’s /tracks/:id singular resource.

 Many of the track properties are a list of ids. These IDs can be 'resolved' by
 using the ASContext. Typically you'll want to load the context once then resolve
 ids using:

       NSArray *genres = [context resolveIDs:track.genreIDs forClass:[ASGenre class]];

*/

@interface ASTrack : ASObject

/// ----------------------------------
/// @name Track attributes
/// ----------------------------------

/**
* The track duration in seconds as a floating-point number.
*/
@property (strong, readonly) NSNumber *length;

/**
* An object representing the track's album.
*/
@property (strong, readonly) ASAlbum  *album;

/**
* An object representing this track's artist.
*/
@property (strong, readonly) ASArtist *artist;

/**
* ID of the track's ending.
*/
@property (readonly) NSUInteger endingID;

/**
* ID of the track's intro.
*/
@property (readonly) NSUInteger introID;

/**
* Does this track contain adult language? A boolean.
*/
@property (readonly) BOOL       explicit;

/**
* Array of genre ids. Only populated if the 'with' parameter was 
* specified when a search was performed or if the track was retrieved
* via a load call.
*/
@property (strong, readonly) NSArray *genreIDs;

/**
* Array of instrument ids. Only populated if the 'with' parameter was
* specified when a search was performed or if the track was retrieved
* via a load call.
*/
@property (strong, readonly) NSArray *instrumentsIDs;

/**
* Array of language ids. Only populated if the 'with' parameter was
* specified when a search was performed or if the track was retrieved
* via a load call.
*/
@property (strong, readonly) NSArray *languagesIDs;

/**
* Array of mood ids. Only populated if the 'with' parameter was
* specified when a search was performed or if the track was retrieved
* via a load call.
*/
@property (strong, readonly) NSArray *moodsIDs;

/**
* Array of restriction ids. Only populated if the 'with' parameter was
* specified when a search was performed or if the track was retrieved
* via a load call.
*/
@property (strong, readonly) NSArray *restrictionsIDs;

/**
* Array of tempo ids. Only populated if the 'with' parameter was
* specified when a search was performed or if the track was retrieved
* via a load call.
*/
@property (strong, readonly) NSArray *temposIDs;

/**
* Array of theme ids. Only populated if the 'with' parameter was
* specified when a search was performed or if the track was retrieved
* via a load call.
*/
@property (strong, readonly) NSArray *themesIDs;

/**
* Array of vocal ids. Only populated if the 'with' parameter was
* specified when a search was performed or if the track was retrieved
* via a load call.
*/
@property (strong, readonly) NSArray *vocalsIDs;

/// ----------------------------------
/// @name Streaming content
/// ----------------------------------

/**
* URL to stream this track from. Streaming URL not available
* until loaded via loadStreamingURLWithSuccess:success:failure.
* This URL provides a 128k stereo MP3 with a lifetime of about 11 hours.
*/
@property (strong, readonly) NSURL    *streamingURL;

/**
* Initiates a request to get the a temporary URL that can be then
* used to stream this track's audio. This URL provides a 128k stereo MP3
* with a lifetime of about 11 hours.
*
* @param success Invoked, if provided, when the request returns. This track
*                is passed to the supplied block. You can then access the URL
*                to stream from using track.streamingURL.
*
* @param failure Invoked, if provided, when the request encounters an error.
*/
- (void)loadStreamingURLWithSuccess:(void (^)(ASTrack *track))success
                            failure:(void (^)(NSError *error))failure;

@end
