#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static UIWindow *globalWindow = nil;

%ctor {
    NSLog(@"[MyTweak] 插件已成功加载到 SpringBoard！");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @try {
            UIWindowScene *targetScene = nil;
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    targetScene = (UIWindowScene *)scene;
                    break;
                }
            }

            if (!targetScene) {
                NSLog(@"[MyTweak] 找不到 UIWindowScene，弹窗失败");
                return;
            }

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MyTweak 已生效"
                                                                           message:@"终极弹窗测试"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];

            globalWindow = [[UIWindow alloc] initWithWindowScene:targetScene];
            globalWindow.windowLevel = UIWindowLevelAlert + 1;
            
            UIViewController *rootVC = [[UIViewController alloc] init];
            rootVC.view.backgroundColor = [UIColor clearColor];
            globalWindow.rootViewController = rootVC;
            
            [globalWindow makeKeyAndVisible];
            [rootVC presentViewController:alert animated:YES completion:nil];
            NSLog(@"[MyTweak] 弹窗执行完毕");
            
        } @catch (NSException *exception) {
            NSLog(@"[MyTweak] 弹窗异常: %@", exception);
        }
    });
}
