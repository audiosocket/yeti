//
//  ASPaginator.h
//  yeti
//
//  Created by Charles Morss on 1/7/13.
//  Copyright (c) 2013 Audiosocket. All rights reserved.
//

#import <RestKit/RestKit.h>

@class ASObject;

/**
 Used for searching and paging through results of ASObject instances. Example usage:

       ASPaginator *paginator = [[ASPaginator alloc] initWithTargetClass:[ASTrack class]];

       [paginator search:@{@"q" : @"big band"}
                 success:^(ASPaginator *paginator) {
                     // ...
                 }
                 failure:^(NSError *error) {
                     // ...
                 }
        ];

 See [the Audiosocket searching API docs](http://develop.audiosocket.com/v5-api#searching)
 for what are allowable query parameters.

*/

@interface ASPaginator : NSObject

///----------------------------------------------
/// @name Setting up a paginator
///----------------------------------------------

/**
* Initialize this paginator for the class specified.
*
* @param objectClass Class of objects to search for. Must be
*                    a subclass of ASObject.
*/
- (ASPaginator *)initWithTargetClass:(Class)objectClass;


///----------------------------------------------
/// @name Accessing paginator state
///----------------------------------------------

/**
* Object per page to include in the result set. Can be specified
* before any request is performed.
*/
@property (nonatomic)           NSUInteger per;

/**
* Most recent page returned.
*/
@property (nonatomic)           NSUInteger page;

/**
* Total number of pages available.
*/
@property (nonatomic, readonly) NSUInteger pages;

/**
* Total number of objects that are available.
*/
@property (nonatomic, readonly) NSUInteger total;

/**
* YES if the paginator has been loaded.
*/
@property (nonatomic, readonly) BOOL       isLoaded;

/**
* Total number of objects that have actually been loaded.
*/
@property (nonatomic, readonly) NSUInteger loadedTotal;

/**
* Return YES if this paginator is currently issuing a request. Multiple
* simultaneous requests can not be performed.
*/
@property (nonatomic, readonly) BOOL       loading;

/**
 * Returns a Boolean value indicating if there is a next page in the collection.
 *
 * @return    `YES` if there is a next page, otherwise `NO`.
 * @exception NSInternalInconsistencyException Raised if the paginator has not loaded or
 *            know its current page number.
 */

- (BOOL)hasNextPage;

/**
 * Returns a Boolean value indicating if there is a previous page in the collection.
 *
 * @return    `YES` if there is a next page, otherwise `NO`.
 * @exception NSInternalInconsistencyException Raised if the paginator
 *            has not loaded or know its current page number.
 */

- (BOOL)hasPreviousPage;


/**
 * Return YES if all elements in the result set have been loaded.
 */
- (BOOL)hasLoadedAll;

///----------------------------------------------
/// @name Paging through results
///----------------------------------------------

/**
 * Loads the next page. At least on load must have been done prior to this call.
 * If there are no more pages this will still make the call and no more records
 * will be retrieved.
 *
 * @param success If supplied called when the next page has loaded. 'self' is passed
 *                to the supplied block.
 *
 * @param failure If supplied called when an error occurs issuing the request.
 */
- (void) loadNextPageWithSuccess:(void (^)(ASPaginator *paginator))success
                         failure:(void (^)(NSError *error))failure;

/**
 * Loads the previous page. At least on load must have been done prior to this call.
 * If the current page is page 1 this will still make the call but no more records
 * will be retrieved.
 *
 * @param success If supplied called when the previous page has loaded. 'self' is passed
 *                to the supplied block.
 *
 * @param failure If supplied called when an error occurs issuing the request.
 */
- (void) loadPreviousPageWithSuccess:(void (^)(ASPaginator *paginator))success
                             failure:(void (^)(NSError *error))failure;

/**
 * Loads the specified page. If a search has not been performed then
 * no query parameters are used. If a search has been prior to calling this
 * the page is loaded using those same parameters.
 *
 * @param pageNumber Page to load. 1 is the first page.
 * @param success    If supplied called when the page has loaded. 'self' is passed
 *                   to the supplied block.
 *
 * @param failure    If supplied called when an error occurs issuing the request.
 */
- (void)loadPage:(NSUInteger)pageNumber
         success:(void (^)(ASPaginator *ASPaginator))success
         failure:(void (^)(NSError *error))failure;

/**
 * Cancels an in-progress pagination request.
 */
- (void)cancel;

///----------------------------------------------
/// @name Accessing returned results
///----------------------------------------------

/**
 * Return the object at the index specified. Must be less then
 * the 'loadedTotal'.
 *
 * @param index position of the object to return.
 */
- (ASObject *)objectAtIndex:(NSInteger)index;

/**
 * Return the object that matches the objectID passed in from within
 * the loaded objects. If no object has been loaded with that ID
 * then nil is returned.
 *
 * @param objectID ID of the object to return.
 */
- (ASObject *)objectForID:(NSInteger)objectID;

///----------------------------------------------
/// @name Searching
///----------------------------------------------

/**
 * Search for instances using params specified.
 *
 * @param params  Optional query parameters to search for. See the
 *                http://develop.audiosocket.com/v5-api docs for
 *                info on what valid parameters are for the given
 *                target class this ASPaginator is setup for.
 *
 * @param success If supplied invoked when the search successfully returns.
 *                The block is passed 'self'.
 *
 * @param failure If supplied invoked when the search request encounters an
 *                error.
 *
 */
- (void)search:(NSDictionary *)params
       success:(void (^)(ASPaginator *))success
       failure:(void (^)(NSError *))failure;


/**
 * Search for instances using params specified returning the page specified.
 *
 * @param page    Page of the result set to return.
 *
 * @param params  Optional query parameters to search for. See the
 *                http://develop.audiosocket.com/v5-api docs for
 *                info on what valid parameters are for the given
 *                target class this ASPaginator is setup for.
 *
 * @param success If supplied invoked when the search successfully returns.
 *                The block is passed 'self'.
 *
 * @param failure If supplied invoked when the search request encounters an
 *                error.
 *
 */
- (void)searchToPage:(NSUInteger)page
              params:(NSDictionary *)params
             success:(void (^)(ASPaginator *))success
             failure:(void (^)(NSError *))failure;

/**
 * Search for instances by issuing a request to the endpoint specified.
 * This method is useful when retrieving nested collections such as
 * [ASAlbum loadTracksWithSuccess:failure:].
 *
 * @param endpointName Endpoint to issue request to. It should include the
 *                     baseURL portion supplied to the [ASApi initWithBaseURL:token:]
 *                     method.
 *
 * @param page         Page of the result set to return.
 *
 * @param params       Optional query parameters to search for. See the
 *                     http://develop.audiosocket.com/v5-api docs for
 *                     info on what valid parameters are for the given
 *                     target class this ASPaginator is setup for.
 *
 * @param success      If supplied invoked when the search successfully returns.
 *                     The block is passed 'self'.
 *
 * @param failure      If supplied invoked when the search request encounters an
 *                     error.
 *
 */
- (void)searchWithEndpoint:(NSString *)endpointName
                    params:(NSDictionary *)params
                      page:(NSUInteger)page
                   success:(void (^)(ASPaginator *))success
                   failure:(void (^)(NSError *))failure;

/*
 * Search for instances by issuing a request to the endpoint specified.
 * This method is useful when retrieving nested collections such as
 * [ASAlbum loadTracksWithSuccess:failure].
 *
 * @param endpointName Endpoint to issue request to. It should include the
 *                     baseURL portion supplied to the [ASApi initWithBaseURL:token]
 *                     method.
 *
 * @param page         Page of the result set to return.
 *
 * @param params       Optional query parameters to search for. See the
 *                     http://develop.audiosocket.com/v5-api docs for
 *                     info on what valid parameters are for the given
 *                     target class this ASPaginator is setup for.
 *
 * @param success      If supplied invoked when the search successfully returns.
 *                     The block is passed 'self'.
 *
 * @param failure      If supplied invoked when the search request encounters an
 *                     error.
 *
 */
//- (void)searchWithEndpoint:(NSString *)endpointName
//                    params:(NSDictionary *)params
//                      page:(NSUInteger)page
//        responseDescriptor:(RKResponseDescriptor *)responseDescriptor
//                   success:(void (^)(ASPaginator *))success
//                   failure:(void (^)(NSError *))failure;

@end
