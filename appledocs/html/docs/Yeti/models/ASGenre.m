//
//  ASGenre.m
//  yeti
//
//  Created by Charles Morss on 12/31/12.
//  Copyright (c) 2012 Audiosocket. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "ASGenre.h"

@implementation ASGenre

+ (NSString *) endpointRoot {
    return @"genres";
}

+ (RKObjectMapping *) instanceObjectMapping {
    RKObjectMapping *mapping = [super instanceObjectMapping];
    
    [mapping addAttributeMappingsFromArray:@[@"display"]];

    return mapping;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, display: %d, children: %i",
            [super description], self.display, self.children.count];
}

@end
