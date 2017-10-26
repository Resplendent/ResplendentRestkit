#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSDictionary+RRKPropertyMappings.h"
#import "RKObjectManager+RRKAddDescriptorsIfNotAlreadyAdded.h"
#import "RKObjectManager+RRKCreateRequestsFromRoutes.h"
#import "RKObjectManager+RRKRequests.h"
#import "RKRoute+RRKRouting.h"
#import "RKRouteSet+RRKAddRouteIfNotAlreadyAdded.h"
#import "RRKBlocks.h"

FOUNDATION_EXPORT double ResplendentRestkitVersionNumber;
FOUNDATION_EXPORT const unsigned char ResplendentRestkitVersionString[];

