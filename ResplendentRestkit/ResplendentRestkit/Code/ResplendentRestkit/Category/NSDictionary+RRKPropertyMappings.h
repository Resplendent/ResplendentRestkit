//
//  NSDictionary+RRKPropertyMappings.h
//  Camerama
//
//  Created by Benjamin Maer on 11/23/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import <Foundation/Foundation.h>





@class RKPropertyMapping;





@interface NSDictionary (RRKPropertyMappings)

-(RKPropertyMapping*)rrk_RKPropertyMappingForDestinationKeyPath:(NSString*)destinationKeyPath;
-(NSString*)rrk_RKPropertyMappingSourceKeyPathForDestinationKeyPath:(NSString*)destinationKeyPath;

@end
