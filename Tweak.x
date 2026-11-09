#import <Foundation/Foundation.h>

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *logPath = @"/var/mobile/MyTweak_OK.txt";
        NSString *logContent = @"[MyTweak] 双设备测试注入成功！";
        [logContent writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    });
}
