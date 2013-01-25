//
//  ASApi.m
//
//  Responsible for initialization of underlying RestKit.
//
//  Created by Charles Morss on 1/3/13.
//  Copyright (c) 2013 Audiosocket. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "ASApi.h"

@implementation ASApi

// baseURL for production V5 access is https://api.audiosocket.com/v5
// token is the token for the api account

+ (void) initWithBaseURL:(NSString *)baseURL
                   token:(NSString *)token {
    
    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    // Let AFNetworking manage the activity indicator
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize HTTPClient that RestKit will use for all requests.
    
    NSURL *url = [NSURL URLWithString:baseURL];
    
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    client.parameterEncoding = AFJSONParameterEncoding;
    
    // We want to work with JSON-Data and we need to set the token header.
    
    [client setDefaultHeader:@"Accept"              value:RKMIMETypeJSON];
    [client setDefaultHeader:@"X-Audiosocket-Token" value:token];
    
    // Initialize RestKit
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // Map the paginator. Note: this is mapping from the response body to
    // the paginator values. URL mapping for requests is done in ASObject#search.
    
    RKObjectMapping *paginationMapping = [RKObjectMapping mappingForClass:[RKPaginator class]];
    
    [paginationMapping addAttributeMappingsFromDictionary:@{
        @"page":  @"currentPage",
        @"per":   @"perPage",
        @"total": @"objectCount"
     }];
    
    objectManager.paginationMapping = paginationMapping;
    
    // Map each of the individual domain objects

    [ASTrack       initializeMappings:objectManager];
    [ASAlbum       initializeMappings:objectManager];
    [ASCategory    initializeMappings:objectManager];
    [ASContext     initializeMappings:objectManager];
    [ASEnding      initializeMappings:objectManager];
    [ASGenre       initializeMappings:objectManager];
    [ASInstrument  initializeMappings:objectManager];
    [ASIntro       initializeMappings:objectManager];
    [ASLanguage    initializeMappings:objectManager];
    [ASMood        initializeMappings:objectManager];
    [ASRestriction initializeMappings:objectManager];
    [ASTempo       initializeMappings:objectManager];
    [ASTheme       initializeMappings:objectManager];
    [ASVocal       initializeMappings:objectManager];
}

@end
