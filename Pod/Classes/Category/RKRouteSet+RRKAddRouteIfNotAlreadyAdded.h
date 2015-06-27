//
//  RRKAddRouteIfNotAlreadyAdded.h
//  ResplendentRestkit
//
//  Created by Benjamin Maer on 10/3/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "RKRouteSet.h"





@interface RKRouteSet (RRKAddRouteIfNotAlreadyAdded)

-(BOOL)rrk_containsRoute:(RKRoute *)route;
-(void)rrk_addRouteIfNotAlreadyAdded:(RKRoute *)route;

@end
