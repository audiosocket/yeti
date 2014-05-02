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
    return [NSString stringWithFormat:@"%@, display: %d, children: %lu",
            [super description], self.display, (unsigned long)self.children.count];
}

@end
