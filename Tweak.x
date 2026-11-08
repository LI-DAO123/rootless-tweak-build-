#import <UIKit/UIKit.h>

static UIViewController *topViewController(void) {
    UIViewController *top = [UIApplication sharedApplication].connectedScenes.anyObject.delegate.window.rootViewController;
    while (top.presentedViewController) {
        top = top.presentedViewController;
    }
    return top;
}

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg1 {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"成功"
                                                                         message:@"Rootless Tweak 加载完成"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alert addAction:ok];
        UIViewController *top = topViewController();
        if (top) {
            [top presentViewController:alert animated:YES completion:nil];
        }
    });
}
%end
