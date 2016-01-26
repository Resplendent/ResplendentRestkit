//
//  RKRoute+RRKRouting.h
//  Resplendent
//
//  Created by Benjamin Maer on 10/22/14.
//  Copyright (c) 2014 Resplendent All rights reserved.
//

#import "RKRoute.h"
#import "RKHTTPUtilities.h"





@interface RKRoute (RRKRouting)

+(instancetype)rrk_RouteWithName:(NSString*)name pathPattern:(NSString*)pathPattern requestMethod:(RKRequestMethod)requestMethod objectClass:(Class)objectClass;

@end
