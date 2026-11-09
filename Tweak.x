#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    // 延迟 3 秒弹出提示，确保 SpringBoard 完全加载完毕
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 1. 创建弹窗
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MyTweak 已生效"
                                                                       message:@"完美兼容 iOS 15/16 无根越狱！"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];

        // 2. 适配 iOS 15/16 获取最顶层的 Window
        UIWindow *keyWindow = nil;
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in ((UIWindowScene *)scene).windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
            }
            if (keyWindow) break;
        }

        // 3. 弹窗展示（包含安全判断，防止崩溃）
        if (keyWindow && keyWindow.rootViewController) {
            [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        } else {
            NSLog(@"[MyTweak] 警告: 无法找到当前活跃的 keyWindow，弹窗取消。");
        }
    });
}

%end
