#import <UIKit/UIKit.h>

%hook SBIconView

// 拦截长按图标事件
- (void)_handleLongPressGesture:(id)gesture {
    %orig; 
    
    // 延迟0.5秒执行，避免和系统长按动画冲突导致崩溃
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 获取图标的名字 (兼容性更好的写法)
        NSString *appName = nil;
        if ([self respondsToSelector:NSSelectorFromString(@"displayName")]) {
            appName = [self valueForKey:@"displayName"];
        }
        
        if (!appName || appName.length == 0) return;
        
        // 复制
        [UIPasteboard generalPasteboard].string = appName;
        
        // 弹窗提示
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (!window) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    window = [(UIWindowScene *)scene windows].firstObject;
                    break;
                }
            }
        }
        
        if (window) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"复制成功" message:appName preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

%end
