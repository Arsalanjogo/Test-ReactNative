//
//  ReactNativeBridgeConnector.m
//  Football433
//
//  Created by Muhammad Nauman on 30/11/2021.
//

#import "React/RCTBridgeModule.h"
#import "AppDelegate.h"
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(iOSNativeApp,RCTEventEmitter)
RCT_EXPORT_METHOD(goToNative: (NSString *)payload) { //: (NSString *)controller
  NSLog(@"RN binding - Native View - Loading TensorFlowObjectDetection.swift");
  dispatch_async(dispatch_get_main_queue(), ^{
      AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate presentExerciseVC: payload]; //: controller
  });
}
@end
