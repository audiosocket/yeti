//
// Created by cmorss on 1/14/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "ASObject.h"

/**
* Artist containing ASTrack and ASAlbum instances for a particular artist.
*/

@interface ASArtist : ASObject

/**
* Collection of albums on this ASArtist. The method loadAlbumsWithSuccess:failure:
* is used to create and populate this attribute.
*/

@property(nonatomic, readonly) ASPaginator *albums;


/**
* Collection of tracks on this ASArtist. The method loadTracksWithSuccess:failure:
* is used to create and populate this attribute.
*/

@property(nonatomic, readonly) ASPaginator *tracks;

/**
* Issue a request to load the paginated collection of ASAlbum instances
* belonging to this ASArtist.
*
* @param success Callback to invoke when the request to load albums has been
*                successful. 'self' instance of ASArist is passed to the block.
*
* @param failure Callback to invoke when an error has occurred.
*
* @return        this.albums. Note: when first returned this paginator is not
*                very useful. However after the success callback has been invoked
*                you may then access the objects fetched as well as page through
*                to additional results.
*/

- (ASPaginator *)loadAlbumsWithSuccess:(void (^)(ASArtist *))success
                               failure:(void (^)(NSError *))failure;

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

- (ASPaginator *)loadTracksWithSuccess:(void (^)(ASArtist *))success
                               failure:(void (^)(NSError *))failure;


@end
