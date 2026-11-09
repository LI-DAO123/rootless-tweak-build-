#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static UIWindow *globalAlertWindow = nil;

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindowScene *activeScene = nil;
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                activeScene = (UIWindowScene *)scene;
                break;
            }
        }

        if (!activeScene) return;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MyTweak 已生效"
                                                                       message:@"完美兼容 iOS 15/16 无根越狱！"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];

        globalAlertWindow = [[UIWindow alloc] initWithWindowScene:activeScene];
        globalAlertWindow.windowLevel = UIWindowLevelAlert + 1;
        
        UIViewController *rootVC = [[UIViewController alloc] init];
        rootVC.view.backgroundColor = [UIColor clearColor];
        globalAlertWindow.rootViewController = rootVC;
        
        [globalAlertWindow makeKeyAndVisible];
        [rootVC presentViewController:alert animated:YES completion:nil];
    });
}

%end
