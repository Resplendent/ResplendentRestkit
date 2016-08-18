//
//  RKRoute+RRKRouting.h
//  Resplendent
//
//  Created by Benjamin Maer on 10/22/14.
//  Copyright (c) 2014 Resplendent All rights reserved.
//

@import RestKit;





@interface RKRoute (RRKRouting)

+(nullable instancetype)rrk_RouteWithName:(nonnull NSString*)name pathPattern:(nonnull NSString*)pathPattern requestMethod:(RKRequestMethod)requestMethod objectClass:(nullable Class)objectClass;

@end
