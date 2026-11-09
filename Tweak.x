#import <UIKit/UIKit.h>

%hook SBFLockScreenDateView

- (void)setTimeText:(id)text {
    %orig(@"环境已通");
}

%end
