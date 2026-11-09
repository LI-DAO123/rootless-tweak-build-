#import <UIKit/UIKit.h>

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    
    // 延迟 5 秒，确保桌面完全就绪
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // ✅ 使用 UIScene 获取当前前台激活的主窗口（适配 iOS 15/16）
        UIWindow *targetWindow = nil;
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        targetWindow = window;
                        break;
                    }
                }
            }
        }
        
        // 获取顶层控制器并弹出提示框
        UIViewController *rootVC = targetWindow.rootViewController;
        if (rootVC) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hello"
                                                                           message:@"你的第一个插件生效了！"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"太棒了" style:UIAlertActionStyleDefault handler:nil]];
            [rootVC presentViewController:alert animated:YES completion:nil];
        }
    });
}

%end
