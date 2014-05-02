//
//  ASPaginator.m
//
//  Wrap the RKPaginator in an Audiosocket paginator so we hide the complex bits.
//
//  Created by Charles Morss on 1/7/13.
//  Copyright (c) 2013 Audiosocket. All rights reserved.
//

#import "ASPaginator.h"
#import "ASTrack.h"

@interface ASPaginator () {
    NSMutableArray *objects;
    RKPaginator *delegate;
}

@property (nonatomic)                  BOOL loading;
@property (nonatomic, weak, readwrite) Class objectClass;

- (void) setCompletionBlocks:(void (^)(ASPaginator *paginator))success
                     failure:(void (^)(NSError *error))failure;

@end

@implementation ASPaginator

@synthesize per     = _per;
@synthesize loading = _loading;

- (ASPaginator *)initWithTargetClass:(Class)objectClass {
    self = [super init];

    if (self) {
        NSParameterAssert(objectClass);

        self.objectClass = objectClass;
        objects = [[NSMutableArray alloc] initWithCapacity:40];
    }

    return self;
}

- (BOOL)isLoaded {
    return delegate && delegate.loaded;
}

- (NSUInteger)loadedTotal {
    NSUInteger t = 0;
    for (NSUInteger j = 0; j < objects.count; j++) {
       if (objects[j]) {
           t++;
       }
    }
    return t;
}

- (NSUInteger) total {
    NSAssert(delegate, @"Cannot determine total: paginator is not loaded.");
    return delegate.objectCount;
}

- (NSUInteger) page {
    NSAssert(delegate, @"Cannot determine page: paginator is not loaded.");
    return delegate.currentPage;
}

- (NSUInteger) pages {
    NSAssert(delegate, @"Cannot determine pages: paginator is not loaded.");
    return delegate.pageCount;
}

- (NSUInteger) per {
    return delegate ? delegate.perPage : _per;
}

- (void) setPer:(NSUInteger)pp {
    if (delegate) {
        delegate.perPage = pp;
    }
    _per = pp;

}

- (BOOL)hasNextPage {
    NSAssert(delegate, @"Cannot determine if hasNextPage: paginator is not loaded.");
    return delegate.hasNextPage;
}

- (BOOL)hasPreviousPage {
    NSAssert(delegate, @"Cannot determine if hasPreviousPage: paginator is not loaded.");
    return delegate.hasPreviousPage;
}

- (void) loadNextPageWithSuccess:(void (^)(ASPaginator *))success
                         failure:(void (^)(NSError *))failure {

    NSAssert(delegate, @"Cannot loadNextPageWithSuccss: paginator is not loaded.");

    self.loading = YES;

    [self setCompletionBlocks:success failure:failure];
    [delegate loadNextPage];
}

- (void) loadPreviousPageWithSuccess:(void (^)(ASPaginator *))success
                             failure:(void (^)(NSError *))failure  {

    NSAssert(delegate, @"Cannot loadPreviousPageWithSuccss: paginator is not loaded.");

    self.loading = YES;

    [self setCompletionBlocks:success failure:failure];
    [delegate loadPreviousPage];
}

- (void)loadPage:(NSUInteger)pageNumber
         success:(void (^)(ASPaginator *))success
         failure:(void (^)(NSError *))failure  {

    self.loading = YES;

    if (delegate) {
        [self setCompletionBlocks:success
                          failure:failure];
        [delegate loadPage:pageNumber];
    } else {
        [self searchToPage:pageNumber
                    params:nil
                   success:success
                   failure:failure];
    }
}

// Need to ignore because the compiler whines about the self reference in the block
// potentially causing a circular strong reference which won't ever get garbage collected.

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"

- (void) setCompletionBlocks:(void (^)(ASPaginator *paginator))success
                     failure:(void (^)(NSError *error))failure  {

    [delegate setCompletionBlockWithSuccess:^(RKPaginator *paginator, NSArray *results, NSUInteger page) {
                                                delegate = paginator;
                                                self.loading = NO;
                                                [self addObjects:results forPage:page];
                                                if (success) {
                                                    success(self);
                                                }
                                            }
                                     failure:^(RKPaginator *paginator, NSError *error) {
                                                 delegate = paginator;
                                                 self.loading = NO;
                                                 if (failure) {
                                                     failure(error);
                                                 }
                                             }
     ];
}
#pragma clang diagnostic pop

- (void)addObjects:(NSArray *)array
           forPage:(NSUInteger)page {

    if (array.count == 0) {
        return;
    }

    // Get the start and end indexes to add/replace the newly loaded objects into.

    NSUInteger start = (page - 1) * self.per;
    NSInteger end = start + array.count;

    // When pages are skipped we fill in any missing pages with nil elements.
    // Yes, this can result in up to 60,000 items in the array. But hopefully
    // most will be nil.

    for (NSInteger k = objects.count; k < start; k++) {
        [objects addObject:nil];
    }

    NSUInteger index = 0;
    for (NSInteger j = start; j < end; j++) {
        if (j >= objects.count) {
            [objects addObject:[array objectAtIndex:index]];
        } else {
            [objects replaceObjectAtIndex:j withObject:[array objectAtIndex:index]];
        }
        index++;
    }
}

/**
 Cancels an in-progress pagination request.
 */
- (void)cancel {
    [delegate cancel];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: isLoaded=%@ per=%ld page=%@ pages=%@ total=%@>",
            NSStringFromClass([self class]),
            delegate.isLoaded ? @"YES" : @"NO",
            (long) self.per,
            [delegate isLoaded] ? @(self.page) : @"???",
            [delegate hasPageCount] ? @(self.pages) : @"???",
            [delegate hasObjectCount] ? @(self.total) : @"???"];
}

- (BOOL)hasLoadedAll {
    return self.loadedTotal == self.total;
}

- (ASObject *)objectAtIndex:(NSInteger)index {
    return (ASObject *)[objects objectAtIndex:index];
}

- (ASObject *)objectForID:(NSInteger)objectID {
    for (NSUInteger j = 0; j < objects.count; j++) {
        ASObject *asObject = (ASObject*)[objects objectAtIndex:j];
        if (asObject.ID == objectID) {
            return asObject;
        }
    }
    return nil;
}

- (void)search:(NSDictionary *)params
       success:(void (^)(ASPaginator *))success
       failure:(void (^)(NSError *))failure {

    [self searchToPage:1
                params:params
               success:success
               failure:failure];

}

- (void)searchToPage:(NSUInteger)page
              params:(NSDictionary *)params
             success:(void (^)(ASPaginator *))success
             failure:(void (^)(NSError *))failure {

    [self searchWithEndpoint:[_objectClass endpointRoot]
                      params:params
                        page:page
                     success:success
                     failure:failure
    ];
}

- (void)searchWithEndpoint:(NSString *)endpointName
                    params:(NSDictionary *)params
                      page:(NSUInteger)page
                   success:(void (^)(ASPaginator *))success
                   failure:(void (^)(NSError *))failure {

    [self searchWithEndpoint:endpointName
                      params:params
                        page:page
          responseDescriptor:[_objectClass collectionResponseDescriptor]
                     success:success
                     failure:failure
    ];
}

/*
 * Similar to the above searches but provides for more control using RestKit directly
 */

- (void)searchWithEndpoint:(NSString *)endpointName
                    params:(NSDictionary *)params
                      page:(NSUInteger)page
        responseDescriptor:(RKResponseDescriptor *)responseDescriptor
                   success:(void (^)(ASPaginator *))success
                   failure:(void (^)(NSError *))failure {

    NSParameterAssert(endpointName);
    NSParameterAssert(responseDescriptor);

    NSMutableDictionary *dict;

    if (params) {
        dict = [params mutableCopy];
    }
    else {
        dict = [[NSMutableDictionary alloc] init];
    }

    RKObjectManager *objectManager = [RKObjectManager sharedManager];

    // For the first paginator request we need to build out the URL with params. Not sure why that is.
    // Create a url that looks something like: https://api.audiosocket.com/moods?pp=:perPage&p=:currentPage

    NSString *withParams = [NSString stringWithFormat:@"%@?pp=:perPage&p=:currentPage", endpointName];
    NSURL *url = [NSURL URLWithString:withParams relativeToURL:objectManager.baseURL];

    NSURLRequest *request = [objectManager.HTTPClient requestWithMethod:@"GET"
                                                                   path:url.absoluteString
                                                             parameters:dict];

    delegate = [[RKPaginator alloc] initWithRequest:request
                                       paginationMapping:objectManager.paginationMapping
                                     responseDescriptors:@[responseDescriptor]];

    if (self.per) {
        delegate.perPage = self.per;
    }

    if (!page) {
        page = 1;
    }

    self.loading = YES;
    [self loadPage:page success:success failure:failure];
}

@end
