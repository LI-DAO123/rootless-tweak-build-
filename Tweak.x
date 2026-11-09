#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static UIWindow *globalWindow = nil;

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    
    // 延迟 8 秒，给 iOS 16 充足的时间初始化界面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @try {
            UIWindowScene *targetScene = nil;
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == UISceneActivationStateForegroundActive) {
                    targetScene = (UIWindowScene *)scene;
                    break;
                }
            }
            
            // 如果没找到活跃的，找任意一个 WindowScene
            if (!targetScene) {
                for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                    if ([scene isKindOfClass:[UIWindowScene class]]) {
                        targetScene = (UIWindowScene *)scene;
                        break;
                    }
                }
            }

            if (!targetScene) return;

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MyTweak 已生效"
                                                                           message:@"兼容 iOS 15/16"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];

            globalWindow = [[UIWindow alloc] initWithWindowScene:targetScene];
            globalWindow.windowLevel = UIWindowLevelAlert + 1;
            
            UIViewController *rootVC = [[UIViewController alloc] init];
            rootVC.view.backgroundColor = [UIColor clearColor];
            globalWindow.rootViewController = rootVC;
            
            [globalWindow makeKeyAndVisible];
            [rootVC presentViewController:alert animated:YES completion:nil];

        } @catch (NSException *exception) {
            NSLog(@"[MyTweak] 弹窗异常: %@", exception);
        }
    });
}

%end
