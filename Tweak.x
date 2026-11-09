#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 强制延迟 10 秒，确保系统完全启动，绝对不掉帧
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"测试成功"
                                                                       message:@"你看到了这个弹窗！"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];

        // 获取所有的场景和窗口，暴力寻找能弹窗的窗口
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                for (UIWindow *window in ((UIWindowScene *)scene).windows) {
                    if (window.isKeyWindow || window.rootViewController) {
                        UIViewController *rootVC = window.rootViewController;
                        while (rootVC.presentedViewController) {
                            rootVC = rootVC.presentedViewController;
                        }
                        [rootVC presentViewController:alert animated:YES completion:nil];
                        return; // 弹出一个就退出循环，防崩溃
                    }
                }
            }
        }
    });
}
