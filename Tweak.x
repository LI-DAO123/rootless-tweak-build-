#import <UIKit/UIKit.h>

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg
{
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"成功"
            message:@"Tweak 加载完成！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
        [top presentViewController:alert animated:YES completion:nil];
    });
}
%end
