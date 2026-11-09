#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static UIWindow *debugWindow = nil;

%ctor {
    NSLog(@"[MyTweak-Debug] 插件成功加载！当前进程: %@", [[NSProcessInfo processInfo] processName]);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @try {
            UIWindowScene *activeScene = nil;
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    activeScene = (UIWindowScene *)scene;
                    break;
                }
            }
            if (!activeScene) return;

            debugWindow = [[UIWindow alloc] initWithWindowScene:activeScene];
            debugWindow.windowLevel = UIWindowLevelAlert + 1.0;
            debugWindow.backgroundColor = [UIColor clearColor];

            UIViewController *rootVC = [[UIViewController alloc] init];
            rootVC.view.backgroundColor = [UIColor clearColor];
            debugWindow.rootViewController = rootVC;
            [debugWindow makeKeyAndVisible];

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 60)];
            label.backgroundColor = [UIColor redColor];
            label.textColor = [UIColor whiteColor];
            label.text = @"插件注入成功！";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:24];
            [rootVC.view addSubview:label];
            
        } @catch (NSException *exception) {
            NSLog(@"[MyTweak-Debug] 异常: %@", exception);
        }
    });
}
