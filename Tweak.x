#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%ctor {
    // 延迟 15 秒，确保系统解锁后界面完全稳定
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @try {
            // 创建一个极其基础的弹窗
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MyTweak"
                                                                           message:@"防崩溃终极版生效！"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];

            // 寻找可以展示弹窗的控制器
            UIViewController *presenter = nil;
            
            // 遍历所有 Scene
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    // 遍历该 Scene 下的所有 Window
                    for (UIWindow *window in ((UIWindowScene *)scene).windows) {
                        if (window.rootViewController) {
                            presenter = window.rootViewController;
                            // 如果根控制器上还有弹出的其他界面，一直往上找
                            while (presenter.presentedViewController) {
                                presenter = presenter.presentedViewController;
                            }
                            break;
                        }
                    }
                }
                if (presenter) break;
            }

            // 如果找到了，就在主线程弹出来
            if (presenter) {
                [presenter presentViewController:alert animated:YES completion:nil];
            }

        } @catch (NSException *exception) {
            // 即使报错，也绝不崩溃
        }
    });
}
