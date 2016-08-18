//
//  RRKBlocks.h
//  Resplendent
//
//  Created by Benjamin Maer on 1/15/15.
//  Copyright (c) 2015 Resplendent All rights reserved.
//

#import <Foundation/Foundation.h>

@import RestKit;





typedef void(^rrk_rkOperationAndMappingResultBlock) (RKObjectRequestOperation* _Nonnull operation, RKMappingResult* _Nonnull mappingResult);
typedef void(^rrk_rkOperationAndErrorBlock) (RKObjectRequestOperation* _Nonnull operation, NSError* _Nonnull error);
typedef void(^rrk_uploadProgressBlock) (NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

typedef void(^rrk_AFRKMultipartFormData_block) (id <AFRKMultipartFormData> _Nullable formData);
