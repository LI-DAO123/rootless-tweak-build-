#import <UIKit/UIKit.h>

%hook SBIconView

- (void)_handleLongPressGesture:(id)gesture {
    %orig; 
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *appName = nil;
        
        // 使用 @try 防止读取私有属性时崩溃
        @try {
            appName = [self valueForKey:@"displayName"];
            if (!appName || appName.length == 0) {
                // 兜底：尝试读取图标下面的 UILabel
                UILabel *iconLabel = [self valueForKey:@"_labelView"];
                appName = iconLabel.text;
            }
        } @catch (NSException *exception) {
            // 忽略异常
        }
        
        if (!appName || appName.length == 0) return;
        
        // 复制到剪贴板
        [UIPasteboard generalPasteboard].string = appName;
        
        // 修复 keyWindow 弃用问题的现代写法
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *w in scene.windows) {
                        if (w.isKeyWindow) {
                            window = w;
                            break;
                        }
                    }
                }
            }
        }
        
        // 兜底获取窗口
        if (!window) {
            window = [[UIApplication sharedApplication].windows firstObject];
        }
        
        // 弹窗提示
        if (window) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"复制成功" message:appName preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

%end
