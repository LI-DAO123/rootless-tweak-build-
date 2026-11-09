#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// Hook 经典的锁屏控制器
%hook SBUILockScreenViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    
    // 延迟 1 秒后寻找时间控件并修改
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 遍历子视图，找到字号特别大的 UILabel（也就是时间）
        for (UIView *view in self.view.subviews) {
            [self modifyLabelRecursively:view];
        }
    });
}

- (void)modifyLabelRecursively:(UIView *)view {
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        if (label.font.pointSize > 40) {
            label.text = @"插件生效";
        }
    }
    for (UIView *subview in view.subviews) {
        [self modifyLabelRecursively:subview];
    }
}

%end

// 兼容 iOS 16+ 的锁屏时间视图
%hook SBFLockScreenDateView

- (void)setTimeText:(id)text {
    %orig(@"插件生效"); 
}

%end
