//
//  ASContext.m
//  yeti
//
//  Created by Charles Morss on 1/4/13.
//  Copyright (c) 2013 Audiosocket. All rights reserved.
//

#import "ASApi.h"

@implementation ASContext

+ (NSString *) instanceGetEndpoint {
    return @"context";
}

+ (RKObjectMapping *) instanceObjectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ASContext class]];
    
    // Define the relationships mapping

    [mapping addPropertyMapping:
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"moods"
                                                    toKeyPath:@"moods"
                                                  withMapping:[ASMood instanceObjectMapping]]];

    [mapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"languages"
                                                 toKeyPath:@"languages"
                                               withMapping:[ASLanguage instanceObjectMapping]]];
    [mapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"endings"
                                                 toKeyPath:@"endings"
                                               withMapping:[ASEnding instanceObjectMapping]]];

    [mapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"categories"
                                                 toKeyPath:@"categories"
                                               withMapping:[ASCategory instanceObjectMapping]]];

    [mapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"genres"
                                                 toKeyPath:@"genres"
                                               withMapping:[ASGenre instanceObjectMapping]]];

    [mapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"instruments"
                                                 toKeyPath:@"instruments"
                                               withMapping:[ASInstrument instanceObjectMapping]]];

    [mapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"intros"
                                                 toKeyPath:@"intros"
                                               withMapping:[ASIntro instanceObjectMapping]]];

    [mapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"restrictions"
                                                 toKeyPath:@"restrictions"
                                               withMapping:[ASRestriction instanceObjectMapping]]];
    [mapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"tempos"
                                                 toKeyPath:@"tempos"
                                               withMapping:[ASTempo instanceObjectMapping]]];


    [mapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"themes"
                                                 toKeyPath:@"themes"
                                               withMapping:[ASTheme instanceObjectMapping]]];

    [mapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"vocals"
                                                 toKeyPath:@"vocals"
                                               withMapping:[ASLanguage instanceObjectMapping]]];

    return mapping;
}

+ (void) loadWithSuccess:(void (^)(ASContext *context))success
                 failure:(void (^)(NSError *error))failure {

    [self getObjectAtPath:self.instanceGetEndpoint
                  success:^(ASObject *asObject) {
                      success((ASContext *) asObject);
                  }
                  failure:failure
    ];
}

- (NSString *)classToCollectionName:(Class)klass {
    if (klass == [ASCategory class]) {
        return @"categories";
    }
    else {
        return [NSString stringWithFormat:@"%@s", [[NSStringFromClass(klass) lowercaseString] substringFromIndex:2]];
    }
}

- (NSArray *)resolveIDs:(NSArray *)ids forClass:(Class)klass {
    NSArray *entities = [self entitiesForClass:klass];

    if (!entities) {
        return NULL;
    }

    NSMutableArray *resolvedEntities = [[NSMutableArray alloc] init];
    NSNumber *targetID;

    for (NSUInteger idIndex = 0; idIndex < ids.count; idIndex++) {
         targetID = [ids objectAtIndex:idIndex];
        for (NSUInteger entitiesIndex = 0; entitiesIndex < entities.count; entitiesIndex++) {
            ASObject *resolved = [(ASObject *)[entities objectAtIndex:entitiesIndex] resolve:targetID];
            if (resolved) {
                [resolvedEntities addObject:resolved];
            }
        }
    }

    return resolvedEntities;
}

- (NSArray* )entitiesForClass:(Class)klass {
    return [self valueForKey:[self classToCollectionName:klass]];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Context: moods: %@, themes: %@, genres: %@, instruments: %@",
            self.moods, self.themes, self.genres, self.instruments];
}

@end
