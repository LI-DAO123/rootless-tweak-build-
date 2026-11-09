#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 定义一个静态变量，防止多次触发导致重复弹窗
static BOOL hasShownAlert = NO;

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    // 延迟 5 秒，确保 iOS 16 桌面和窗口全部加载完毕，保证绝对安全
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (hasShownAlert) return;
        hasShownAlert = YES;

        // 使用 @try-@catch 包裹，即使发生异常也不会让 SpringBoard 崩溃（不进安全模式）
        @try {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MyTweak 已生效"
                                                                           message:@"完美兼容 iOS 15/16 无根越狱！(安全防崩溃版)"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];

            // 核心安全逻辑：创建一个全新的透明 UIWindow 来承载弹窗，避免干扰系统现有窗口
            UIWindow *alertWindow = [[UIWindow alloc] init];
            // 设置极高的窗口层级，保证能显示在最前面
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            
            // 寻找一个安全的 UIWindowScene 绑定（iOS 15/16 必须绑定 Scene）
            UIWindowScene *activeScene = nil;
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    activeScene = (UIWindowScene *)scene;
                    break;
                }
            }
            
            if (activeScene) {
                alertWindow.windowScene = activeScene;
            }

            // 创建一个空的视图控制器作为根控制器
            UIViewController *rootVC = [[UIViewController alloc] init];
            rootVC.view.backgroundColor = [UIColor clearColor];
            alertWindow.rootViewController = rootVC;
            
            // 必须让窗口可见才能弹窗
            alertWindow.hidden = NO;
            [alertWindow makeKeyAndVisible];

            // 在新建的安全窗口上弹窗
            [rootVC presentViewController:alert animated:YES completion:nil];
            
        } @catch (NSException *exception) {
            NSLog(@"[MyTweak] 弹窗发生异常，已拦截防止崩溃: %@", exception.reason);
        }
    });
}

%end
