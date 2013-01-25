//
//  ASTrack.m
//
//  Created by Charles Morss on 12/31/12.
//  Copyright (c) 2012 Audiosocket. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "ASTrack.h"

@interface ASTransientURL : ASObject

@property(nonatomic, copy) NSString   *url;
@property(nonatomic)       NSUInteger until;

@end

@implementation ASTransientURL {
}

+ (NSString *)endpointRoot {
    return @"tracks";
}

+ (NSString *)pathPatternForMapping {
    return nil;
}

+ (NSString *)instanceGetEndpoint {
    return [NSString stringWithFormat:@"%@/:id.mp3/url?lifetime=40000", [self endpointRoot]];
}

+ (RKObjectMapping *)instanceObjectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ASTransientURL class]];

    [mapping addAttributeMappingsFromDictionary:@{
            @"url"             : @"url",
            @"until"           : @"until"
        }
    ];

    return mapping;
}

- (NSString *)instanceGetEndpoint {
    return [NSString stringWithFormat:@"%@/%i.mp3/url?lifetime=40000", [ASTransientURL endpointRoot], self.ID];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: until: %i, url: %@", self.className, self.until, self.url];
}

@end

@interface ASTrack ()
@property(nonatomic, strong) ASTransientURL *transientURL;
@end

@implementation ASTrack

@synthesize artist       = _artist;
@synthesize album        = _album;

@synthesize endingID;
@synthesize introID;
@synthesize explicit;
@synthesize genreIDs;
@synthesize instrumentsIDs;
@synthesize languagesIDs;
@synthesize moodsIDs;
@synthesize restrictionsIDs;
@synthesize temposIDs;
@synthesize themesIDs;
@synthesize vocalsIDs;

@synthesize transientURL = _transientURL;


+ (NSString *)endpointRoot {
    return @"tracks";
}

+ (void)initializeMappings:(RKObjectManager *)objectManager {
    [ASTrack addInstanceResponseDescriptor];
    [ASTransientURL addInstanceResponseDescriptor];
}

+ (RKObjectMapping *)instanceObjectMapping {
//    RKDynamicMapping *mapping = [RKDynamicMapping new];

    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];

    [mapping addAttributeMappingsFromDictionary:@{
            @"id"              : @"ID",
            @"name"            : @"name",
            @"ending"          : @"endingID",
            @"intro"           : @"introID",
            @"explicit"        : @"explicit",
            @"genres"          : @"genreIDs",
            @"instruments"     : @"instrumentsIDs",
            @"languages"       : @"languagesIDs",
            @"moods"           : @"moodsIDs",
            @"restrictions"    : @"restrictionsIDs",
            @"tempos"          : @"temposIDs",
            @"themes"          : @"themesIDs",
            @"vocals"          : @"vocalsIDs"
         }
    ];

//    [mapping addAttributeMappingsFromArray:@[@"length"]];

//    [mapping addPropertyMapping:
//            [RKRelationshipMapping relationshipMappingFromKeyPath:@"album"
//                                                        toKeyPath:@"album"
//                                                      withMapping:[ASAlbum instanceObjectMapping]]];
//
//    [mapping addPropertyMapping:
//            [RKRelationshipMapping relationshipMappingFromKeyPath:@"artist"
//                                                        toKeyPath:@"artist"
//                                                      withMapping:[ASArtist instanceObjectMapping]]];

//    RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];

//    RKObjectMapping *numberMapping =  [RKObjectMapping mappingForClass:[NSObject class]];

//    [mapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"genres" expectedValue:@"genres" objectMapping:numberMapping]];
//    [mapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"ending" expectedValue:@"ending" objectMapping:numberMapping]];

    // Connect a response descriptor for our dynamic mapping
//    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dynamicMapping
//                                                                                       pathPattern:nil keyPath:@"people"
//                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];

// Option 1: Configure the dynamic mapping via matchers
//    [dynamicMapping setObjectMapping:boyMapping whenValueOfKeyPath:@"type" isEqualTo:@"Boy"];
//    [dynamicMapping setObjectMapping:girlMapping whenValueOfKeyPath:@"type" isEqualTo:@"Girl"];

// Option 2: Configure the dynamic mapping via a block
//    [dynamicMapping setObjectMappingForRepresentationBlock:RKObjectMapping *^(id representation) {
//        if ([[representation valueForKey:@"type"] isEqualToString:@"Boy"]) {
//            return boyMapping;
//        } else if ([[representation valueForKey:@"type"] isEqualToString:@"Girl"]) {
//            return girlMapping;
//        }
//
//        return nil;
//    };
    return mapping;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ASTrack: id: %i, name: %@", self.ID, self.name];
}


- (void)loadStreamingURLWithSuccess:(void (^)(ASTrack *))success
                            failure:(void (^)(NSError *))failure {

    ASTransientURL *url = (ASTransientURL *) [[ASTransientURL alloc] initWithID:self.ID];

    [url loadFromPath:[url instanceGetEndpoint]
           parameters:nil
              success:^(id asURL) {
                    self.transientURL = asURL;
                    if (success) {
                        success(self);
                    }
                }
              failure:failure
    ];
}

- (NSURL *)streamingURL {
    NSAssert(self.transientURL, @"Streaming URL not avaible until loaded via loadStreamingURLWithSuccess:success:failure");

    return [NSURL URLWithString:self.transientURL.url];
}

@end

