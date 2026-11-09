#import <UIKit/UIKit.h>

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 {
    %orig;
    NSLog(@"✅ 插件加载成功！支持iOS15 / iOS16");
}

%end
