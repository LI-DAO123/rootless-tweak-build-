#import <UIKit/UIKit.h>

UIViewController* GetTopVC(void)
{
    UIViewController *top = nil;
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes)
    {
        if (scene.activationState == UISceneActivationStateForegroundActive)
        {
            UIWindow *win = scene.windows.firstObject;
            if (win)
            {
                top = win.rootViewController;
                while (top.presentedViewController)
                {
                    top = top.presentedViewController;
                }
                break;
            }
        }
    }
    return top;
}

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg
{
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *top = GetTopVC();
        if (!top) return;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"成功"
            message:@"Tweak 加载完成！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [top presentViewController:alert animated:YES completion:nil];
    });
}
%end
