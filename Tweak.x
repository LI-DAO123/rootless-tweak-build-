#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    // 延迟 3 秒弹出提示，确保 SpringBoard 加载完毕
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MyTweak 已生效"
                                                                       message:@"完美兼容 iOS 15/16！"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];

        // 获取当前最顶层的 ViewController 来弹窗
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

%end
