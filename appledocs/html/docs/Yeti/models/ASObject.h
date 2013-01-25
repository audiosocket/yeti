//
//  ASObject.h
//  yeti
//
//  Created by Charles Morss on 12/31/12.
//  Copyright (c) 2012 Audiosocket. All rights reserved.
//

#import "ASPaginator.h"

/**
* Base class all Audiosocket data models subclass. Since most models have
* both a 'name' and an ID attribute they are defined here.
*
* This class interfaces with the underlying [RestKit](http://restkit.org) library
* which handles the object mapping and underlying transport. This class is the only
* class which exposes any RestKit classes. By doing so it more advanced scenarios
* can be implemented.
*/
@interface ASObject : NSObject

///-----------------------------------------------
/// @name Accessing ASObject data model Properties
///-----------------------------------------------

/**
* Primary ID of this ASObject instance.
*/
@property (nonatomic) NSInteger ID;

/**
* Name of this ASObject instance, e.g. "Don't Stop Believing"
*/
@property (nonatomic, readonly) NSString *name;

///-----------------------------------------------
/// @name Mapping response data to object proproperties
///-----------------------------------------------

/**
 Return the RestKit object manager singleton.
 */
+ (RKObjectManager *) objectManager;

/**
* Initializes the RestKit mapping for this class. Defaults to calling only
* [ASObject addInstanceResponseDescriptor]. It is overridden by classes
* that contain associated entities.
*
* @param objectManager RestKit RKObjectManager to add the mapping to.
*/
+ (void) initializeMappings:(RKObjectManager *)objectManager;

/**
* Adds an RKResponseDescriptor descriptor as an instance descriptor. You
* should not have to make changes to this class, but it is exposed should
* you decide to override. See (RestKit object mapping)[https://github.com/RestKit/RestKit/wiki/Object-mapping]
* for details should you need them.
*/
+ (RKResponseDescriptor *) addInstanceResponseDescriptor;


/**
* Adds an RKResponseDescriptor descriptor as an collection descriptor. You
* should not have to make changes to this class, but it is exposed should
* you decide to override. See (RestKit object mapping)[https://github.com/RestKit/RestKit/wiki/Object-mapping]
* for details should you need them.
*/
+ (RKResponseDescriptor *) collectionResponseDescriptor;

/**
* Returns an RKObjectMapping instance to map the properties of this object.
* Defaults to ID and name mapping. Override to map attributes.
*/
+ (RKObjectMapping *) instanceObjectMapping;

///-----------------------------------------------
/// @name Defining destination endpoints.
///-----------------------------------------------

/**
* For and endpoint like "https://api.audiosocket.com/v5/moods/345"
* this method should return "moods".
*
* Note: must be overridden by subclass.
*/

+ (NSString *) endpointRoot;

/**
* Return the endpoint path, not including the baseURL portion, used to
* fetch an instance of this class. It defaults '<endpoint-root>/:id'.
* When actually fetching instances ':id' is replaced with the actual
* id of the object.
*/
+ (NSString *)instanceGetEndpoint;

/*
 * Return the path will be matched against for instance retrieval. Defaults
 * to the instanceGetEndpoint method. It should be overridden to return
 * nil if this class is not be be mapped using a path pattern.
 *
 * Normally you should not have to override this method at all.
 *
 * See (RestKit object mapping)[https://github.com/RestKit/RestKit/wiki/Object-mapping]
 * for details on path vs key mapping.
 */
+ (NSString *)pathPatternForMapping;

///-----------------------------------------------
/// @name Loading data models
///-----------------------------------------------

/*
 * Create a new paginator for searching and loading collections of instances of class.
 *
 * @return Newly initialized paginator with this class set as it's target.
 */
+ (ASPaginator *)createPaginator;

/*
 * Load an ASObject from the remote endpoint for the id specified.
 *
 * @param ID       Id of the object to load from the server.
 * @param success  Called when the request returns successfully. The retrieved
 *                 instance is passed to this block.
 * @param failure  If supplied called when an error occurs during the request.
 */
+ (void)load:(NSInteger)ID
     success:(void (^)(id))success
     failure:(void (^)(NSError *error))failure;

/*
 * Load an collection of non-paginated data models from the remote endpoint
 * specified by path.
 *
 * @param path     Path specifying endpoint that will return objects of this class. It
 *                 does not include the baseURL portion of the path.
 * @param success  Called when the request returns successfully. The retrieved
 *                 instances are passed to this block.
 * @param failure  If supplied called when an error occurs during the request.
 */
+ (void)getObjectsAtPath:(NSString *)path
                 success:(void (^)(NSArray *))success
                 failure:(void (^)(NSError *error))failure;

/*
 * Load an single data models from the remote endpoint specified by path.
 *
 * @param path     Path specifying endpoint that will an instance of this class. It
 *                 does not include the baseURL portion of the path.
 * @param success  Called when the request returns successfully. The retrieved
 *                 instance is passed to this block.
 * @param failure  If supplied called when an error occurs during the request.
 */
+ (void)getObjectAtPath:(NSString *)path
                success:(void (^)(ASObject *))success
                failure:(void (^)(NSError *))failure;


///-----------------------------------------------
/// @name Creating a new instance
///-----------------------------------------------

/**
* Initialize an instance of this class with the ID provided.
*
* @param ID Primary ID of this instance.
*/
- (ASObject *)initWithID:(NSInteger)ID;

/**
 Loads an instance from the server. If you only have an
 ID for a instance you can do something like the following:

       ASTrack *track = [[ASTrack alloc] initWithID:20];
       [track loadWithSuccess:^(ASTrack *loadTrack) {
                        // Do something with the newly loaded track...
                      }
                      failure:^(NSError *error) {
                        // Handle error condition...
                      }
       ];

 @param success Invoked when the request has completed successfully. 'self' is
                passed to the block.
 @param failure Invoked, if supplied, when an error occurs during the request or
                subsequent data mapping.
*/
- (void)loadWithSuccess:(void (^)(id asObject))success
                failure:(void (^)(NSError *error))failure;


/**
 * Loads an instance from the server using the endpoint supplied. This is useful
 * for classes that don't have an ID, e.g. ASContext
 *
 * @param path     Path specifying endpoint that will an instance of this class. It
 *                 does not include the baseURL portion of the path.
 * @param params   Optional query parameters that added to the request path.
 * @param success  Called when the request returns successfully. The retrieved
 *                 instance is passed to this block.
 * @param failure  If supplied called when an error occurs during the request.
 */
- (void)loadFromPath:(NSString *)path
          parameters:(NSDictionary *)params
             success:(void (^)(id))success
             failure:(void (^)(NSError *))failure;


- (NSString *)className;

/**
* Return 'self' if targetID is equal self.ID. Overriden in subclasses that
* contain children.
*
* @param targetID ID to compare to.
*/
- (ASObject *)resolve:(NSNumber *)targetID;

@end
