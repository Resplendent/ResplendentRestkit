//
//  RRKAddRouteIfNotAlreadyAdded.h
//  ResplendentRestkit
//
//  Created by Benjamin Maer on 10/3/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

@import RestKit;





@interface RKRouteSet (RRKAddRouteIfNotAlreadyAdded)

-(BOOL)rrk_containsRoute:(nonnull RKRoute*)route;
-(void)rrk_addRouteIfNotAlreadyAdded:(nonnull RKRoute*)route;

@end
