#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static UIViewController *topVC(void) {
    UIWindow *win = nil;
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]] && scene.windows.count > 0) {
            win = scene.windows.firstObject;
            break;
        }
    }
    if (!win) return nil;

    UIViewController *top = win.rootViewController;
    while (top.presentedViewController) {
        top = top.presentedViewController;
    }
    return top;
}

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg1 {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *top = topVC();
        if (!top) return;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"成功"
                                                                         message:@"Tweak 加载好了"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alert addAction:ok];
        [top presentViewController:alert animated:YES completion:nil];
    });
}
%end
