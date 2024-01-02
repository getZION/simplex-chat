//
//  RNBridgeSampleCFile.m
//  RNBridgeSample
//
//  Created by Andor Kesselman on 1/2/24.
//
#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(RNBridgeSample, NSObject)
RCT_EXTERN_METHOD(increment)
RCT_EXTERN_METHOD(getCount: (RCTResponseSenderBlock)callback)
_RCT_EXTERN_REMAP_METHOD(inc, increment, false)
@end
