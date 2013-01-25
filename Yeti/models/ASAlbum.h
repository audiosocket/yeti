//
//  ASAlbum.h
//  yeti
//
//  Created by Charles Morss on 1/7/13.
//  Copyright (c) 2013 Audiosocket. All rights reserved.
//

#import "ASObject.h"
#import "ASPaginator.h"

/**
* Album containing ASTrack instances for a particular artist.
*/

@interface ASAlbum : ASObject

/**
* Collection of tracks on this ASAlbum. The method loadTracksWithSuccess:failure:
* is used to create and populate this attribute.
*/

@property(nonatomic) ASPaginator *tracks;

/**
* Issue a request to load the paginated collection of ASTrack instances
* belonging to this ASAlbum.
*
* @param success Callback to invoke when the request to load tracks has been
*                successful. 'self' instance of ASAlbum is passed to the block.
*
* @param failure Callback to invoke when an error has occurred.
*
* @return        this.tracks. Note: when first returned this paginator is not
*                very useful. However after the success callback has been invoked
*                you may then access the objects fetched as well as page through
*                to additional results.
*/

- (ASPaginator *)loadTracksWithSuccess:(void (^)(ASAlbum * album))success
                               failure:(void (^)(NSError *))failure;

@end
