#import <UIKit/UIKit.h>

%hook SBIconView

- (void)_handleLongPressGesture:(id)gesture {
    %orig; 
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *appName = nil;
        
        @try {
            // 核心修复：将 self 强转为 id 类型，绕过 SBIconView 前向声明的类型检查
            appName = [(id)self valueForKey:@"displayName"];
            if (!appName || appName.length == 0) {
                UILabel *iconLabel = [(id)self valueForKey:@"_labelView"];
                appName = iconLabel.text;
            }
        } @catch (NSException *exception) {
            // 忽略异常
        }
        
        if (!appName || appName.length == 0) return;
        
        // 复制到剪贴板
        [UIPasteboard generalPasteboard].string = appName;
        
        // 获取当前窗口，去除了被废弃的 windows 兜底写法
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
        } else {
            window = [[UIApplication sharedApplication].delegate window];
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
