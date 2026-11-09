#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    
    // 延迟 3 秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"iOS 16 测试"
                                                                       message:@"如果你看到我，说明插件加载成功！"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];

        // 暴力抓取当前活跃的 WindowScene
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
        }
        
        // 如果没找到，用废弃 API 兜底
        if (!keyWindow) {
            keyWindow = [[UIApplication sharedApplication] keyWindow];
        }

        if (keyWindow && keyWindow.rootViewController) {
            [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

%end
