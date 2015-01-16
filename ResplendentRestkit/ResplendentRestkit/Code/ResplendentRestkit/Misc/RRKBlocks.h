//
//  RRKBlocks.h
//  Shimmur
//
//  Created by Benjamin Maer on 1/15/15.
//  Copyright (c) 2015 ShimmurInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKObjectManager.h"





typedef void(^rrk_rkOperationAndMappingResultBlock) (RKObjectRequestOperation *operation, RKMappingResult *mappingResult);
typedef void(^rrk_rkOperationAndErrorBlock) (RKObjectRequestOperation *operation, NSError *error);
typedef void(^rrk_afOperationAndResponseObjectBlock) (AFHTTPRequestOperation *operation, id responseObject);
typedef void(^rrk_afOperationAndErrorBlock) (AFHTTPRequestOperation *operation, NSError *error);
typedef void(^rrk_uploadProgressBlock) (NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);
