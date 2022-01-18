#import <React/RCTBridgeDelegate.h>
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, RCTBridgeDelegate>

@property (nonatomic, strong) UIWindow *window;


- (void) dismissToReactNative;

- (void) presentExerciseVC : (NSString *)payload; //: (NSString *)controllerId

@end
