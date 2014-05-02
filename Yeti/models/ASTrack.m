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
    return [NSString stringWithFormat:@"%@/%li.mp3/url?lifetime=40000", [ASTransientURL endpointRoot], (long)self.ID];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: until: %lu, url: %@", self.className, (unsigned long)self.until, self.url];
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

    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];

    [mapping addAttributeMappingsFromDictionary:@{
            @"id"              : @"ID",
            @"name"            : @"name",
            @"length"          : @"length",
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

    [mapping addPropertyMapping:
            [RKRelationshipMapping relationshipMappingFromKeyPath:@"album"
                                                        toKeyPath:@"album"
                                                      withMapping:[ASAlbum instanceObjectMapping]]];

    [mapping addPropertyMapping:
            [RKRelationshipMapping relationshipMappingFromKeyPath:@"artist"
                                                        toKeyPath:@"artist"
                                                      withMapping:[ASArtist instanceObjectMapping]]];
    return mapping;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ASTrack: id: %li, name: %@", (long)self.ID, self.name];
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

