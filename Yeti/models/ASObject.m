//
//  ASObject.m
//
//  Base class all Audiosocket model objects extend from.
//
//  Created by Charles Morss on 12/31/12.
//  Copyright (c) 2012 Audiosocket. All rights reserved.
//

#import "ASObject.h"

@interface ASObject()

- (void) updateMappedPropertiesFrom:(ASObject *)other;

@end


@implementation ASObject

+ (RKObjectManager *)objectManager {
    return [RKObjectManager sharedManager];
}

+ (NSString *) endpointRoot {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass",
                                                   NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

/*
 * Defaults to just adding the instance response descriptor. Subclasses with
 * with additional mappings should override but most likely still call super.
 */

+ (void) initializeMappings:(RKObjectManager *)objectManager {
    [self.class addInstanceResponseDescriptor];
}

+ (RKObjectMapping *) instanceObjectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];

    [mapping addAttributeMappingsFromDictionary:@{
            @"id"   : @"ID",
            @"name" : @"name"
    }];

    return mapping;
}

/*
 * Return the endpoint path, not including the baseURL portion, used to
 * fetch an instance of this class. It defaults '<endpoint-root>/:id'.
 * When actually fetching instances ':id' is replaced with the actual
 * id of the object.
 */
+ (NSString *) instanceGetEndpoint {
    return [NSString stringWithFormat:@"%@/:id", [self endpointRoot]];
}

/*
 * Return the path that is used for instance retrieval. Defaults
 * to the instanceGetEndpoint method. It should be overridden to return
 * nil if this class is not be be mapped using a path pattern.
 */
+ (NSString *)pathPatternForMapping {
    return self.instanceGetEndpoint;
}

+ (RKResponseDescriptor *) addInstanceResponseDescriptor {
    RKResponseDescriptor *descriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:self.instanceObjectMapping
                                                     method:RKRequestMethodAny
                                                pathPattern:self.pathPatternForMapping
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[self objectManager] addResponseDescriptor:descriptor];
    return descriptor;
}

+ (RKResponseDescriptor *) collectionResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:self.instanceObjectMapping
                                                        method:RKRequestMethodAny
                                                   pathPattern:nil
                                                       keyPath:@"data"
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (ASPaginator *) createPaginator {
    return [[ASPaginator alloc] initWithTargetClass:self];
}

+ (void)load:(NSInteger)ID
     success:(void (^)(id asObject))success
     failure:(void (^)(NSError *error))failure
{
    NSParameterAssert(ID);

    NSMutableString *path = [[NSMutableString alloc] initWithString:[self instanceGetEndpoint]];

    [path replaceOccurrencesOfString:@":id"
                          withString:[NSString stringWithFormat:@"%d", ID]
                             options:NSLiteralSearch
                               range:NSMakeRange(0, path.length)
    ];

    [self getObjectsAtPath:path
                   success:^(NSArray *asObjects) {
                       if (success) {
                           success([asObjects objectAtIndex:0]);
                       }
                   }
                   failure:failure
    ];
}

+ (void)getObjectsAtPath:(NSString *)path
                 success:(void (^)(NSArray *asObjects))success
                 failure:(void (^)(NSError *error))failure
{
    NSParameterAssert(path);
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                if (success) {
                                    success(mappingResult.array);
                                }
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                NSLog(@"Error on get: %@", error);
                                if (failure) {
                                    failure(error);
                                }
                            }
    ];
}

+ (void)getObjectAtPath:(NSString *)path
                success:(void (^)(ASObject *))success
                failure:(void (^)(NSError *))failure {

    [self getObjectsAtPath:path
                   success:^(NSArray *asObjects) {
                        if (success) {
                            success([asObjects objectAtIndex:0]);
                        }
                   }
                   failure:failure
    ];
}

/********************************  Instance Methods *********************************/


- (ASObject *) initWithID:(NSInteger)ID {
    self = [super init];

    if (self) {
        NSParameterAssert(ID);
        self.ID = ID;
    }

    return self;
}

- (void)loadFromPath:(NSString *)path
          parameters:(NSDictionary *)parameters
             success:(void (^)(id resultObject))success
             failure:(void (^)(NSError *error))failure {

    NSParameterAssert(path);

    RKObjectManager *objectManager = [RKObjectManager sharedManager];

    [objectManager getObject:self
                        path:path
                  parameters:parameters
                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                            NSArray* statuses = mappingResult.array;
                            if (success) {
                                success([statuses objectAtIndex:0]);
                            }
                        }
                     failure:^(RKObjectRequestOperation *operation, NSError *error) {
                            if (failure) {
                                failure(error);
                            }
                        }
    ];
}

- (NSString *)className {
    return NSStringFromClass([self class]);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: id: %i, name: %@", self.className, self.ID, self.name];
}

- (void) loadWithSuccess:(void (^)(id))success
                 failure:(void (^)(NSError *))failure {
    
    NSAssert(self.ID, @"self.ID required to load instance.");

    [[self class] load:self.ID
               success:^(ASObject *asObject) {
                   [self updateMappedPropertiesFrom:asObject];
                   if (success) {
                       success(self);
                   }
               }
               failure:failure];
}

- (void) updateMappedPropertiesFrom:(ASObject *)other {
    NSParameterAssert(other);
    
    RKObjectMapping *objectMapping = [[self class] instanceObjectMapping];
    
    for (RKPropertyMapping *propertyMapping in objectMapping.propertyMappings) {
        NSString *key = propertyMapping.destinationKeyPath;
        id newValue = [other valueForKey:key];
        [self setValue:newValue forKey:key];
    }
}

- (ASObject *)resolve:(NSNumber *)targetID {
    if ([targetID unsignedIntegerValue] == self.ID) {
        return self;
    }
    return NULL;
}
@end
