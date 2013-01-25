//
// Created by cmorss on 1/14/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ASArtist.h"
#import "ASTrack.h"


@interface ASArtist ()
@property(nonatomic, readwrite) ASPaginator *tracks;
@property(nonatomic, readwrite) ASPaginator *albums;
@end

@implementation ASArtist
@synthesize tracks = _tracks;


+ (NSString *) endpointRoot {
    return @"artists";
}


- (ASPaginator *)loadAlbumsWithSuccess:(void (^)(ASArtist *album))success
                               failure:(void (^)(NSError *error))failure {

    NSString *path = [NSString stringWithFormat:@"%@/%i/albums", [ASArtist endpointRoot], self.ID];

    if (!self.albums) {
        self.albums = [ASAlbum createPaginator];
    }

    [self.albums searchWithEndpoint:path
                             params:nil page:1
                            success:^(ASPaginator *paginator) {
                                if (success) {
                                    success(self);
                                }
                            }
                            failure:^(NSError *error) {
                                NSLog(@"Bad things happened: %@", error);
                                if (failure) {
                                    failure(error);
                                }
                            }
    ];

    return self.albums;
}


- (ASPaginator *)loadTracksWithSuccess:(void (^)(ASArtist *album))success
                               failure:(void (^)(NSError *error))failure {

    NSString *path = [NSString stringWithFormat:@"%@/%i/tracks", [ASArtist endpointRoot], self.ID];

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
                                NSLog(@"Bad things happened: %@", error);
                                if (failure) {
                                    failure(error);
                                }
                            }
    ];

    return self.tracks;
}

@end
