#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%hook SpringBoard

- (void)_lockScreenViewController {
    %orig;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 在锁屏加载后，获取当前激活的Scene
        UIWindowScene *activeScene = nil;
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == UISceneActivationStateForegroundActive) {
                activeScene = (UIWindowScene *)scene;
                break;
            }
        }
        
        if (!activeScene) return;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MyTweak 已生效"
                                                                       message:@"iOS 16 锁屏测试成功"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];

        UIWindow *alertWindow = [[UIWindow alloc] initWithWindowScene:activeScene];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        
        UIViewController *rootVC = [[UIViewController alloc] init];
        rootVC.view.backgroundColor = [UIColor clearColor];
        alertWindow.rootViewController = rootVC;
        
        [alertWindow makeKeyAndVisible];
        [rootVC presentViewController:alert animated:YES completion:nil];
    });
}

%end
