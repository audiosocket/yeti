//
//  ASAlbum.m
//
//  Created by Charles Morss on 1/7/13.
//  Copyright (c) 2013 Audiosocket. All rights reserved.
//

#import "ASAlbum.h"
#import "ASTrack.h"

@implementation ASAlbum

+ (NSString *) endpointRoot {
    return @"albums";
}

- (ASPaginator *)loadTracksWithSuccess:(void (^)(ASAlbum *))success
                               failure:(void (^)(NSError *))failure {

    NSString *path = [NSString stringWithFormat:@"%@/%i/tracks", [ASAlbum endpointRoot], self.ID];

    if (!self.tracks) {
        self.tracks = [ASTrack createPaginator];
    }

    [self.tracks searchWithEndpoint:path
                             params:nil page:1
                            success:^(ASPaginator *paginator) {
                                if (success) {
                                    success(self);
                                }
                            }
                            failure:^(NSError *error) {
                                NSLog(@"Error loading tracks for album: %@", error);
                                if (failure) {
                                    failure(error);
                                }
                            }
    ];

    return self.tracks;
}



@end
