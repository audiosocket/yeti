//
//  ASNestedObject.m
//  yeti
//
//  Created by Charles Morss on 1/7/13.
//  Copyright (c) 2013 Audiosocket. All rights reserved.
//

#import "ASNestedObject.h"

@implementation ASNestedObject

+ (RKObjectMapping *) instanceObjectMapping {
    RKObjectMapping *mapping = [super instanceObjectMapping];

    [self addChildrenMapping:mapping];

    return mapping;
}

+ (void) addChildrenMapping:(RKObjectMapping *)mapping {
    [mapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"children"
                                                 toKeyPath:@"children"
                                               withMapping:mapping]
     ];
}

- (ASObject *)resolve:(NSNumber *)targetID {
    ASObject *resolved = [super resolve:targetID];

    if (!resolved) {
        if (self.children) {
            for (NSUInteger childIndex = 0; childIndex < self.children.count && !resolved; childIndex++) {
                resolved = [[self.children objectAtIndex:childIndex] resolve:targetID];
            }
        }
    }

    return resolved;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, children: %i", [super description], self.children.count];
}

@end
