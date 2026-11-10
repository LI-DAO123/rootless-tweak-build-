#import <UIKit/UIKit.h>
#import <Vision/Vision.h>

%hook SpringBoard

- (void)_handleStatusBarDoubleTap:(id)arg1 {
    %orig;
    
    // 读取设置开关
    CFBooleanRef enabled = CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR("com.yourname.universaltweak"));
    BOOL isEnabled = enabled ? CFBooleanGetValue(enabled) : YES;
    if (enabled) CFRelease(enabled);
    if (!isEnabled) return;
    
    // 获取窗口
    UIWindow *keyWindow = nil;
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *window in scene.windows) {
                if (window.isKeyWindow) { keyWindow = window; break; }
            }
        }
    }
    if (!keyWindow) return;

    // 截图
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithBounds:keyWindow.bounds];
    UIImage *screenshot = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        [keyWindow drawViewHierarchyInRect:keyWindow.bounds afterScreenUpdates:YES];
    }];
    
    UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:nil message:@"正在识别屏幕文字..." preferredStyle:UIAlertControllerStyleAlert];
    [keyWindow.rootViewController presentViewController:loadingAlert animated:YES completion:nil];

    // Vision 识别
    VNRecognizeTextRequest *request = [[VNRecognizeTextRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        if (error) return;
        NSMutableString *allText = [NSMutableString string];
        for (VNRecognizedTextObservation *observation in request.results) {
            VNRecognizedText *topCandidate = [[observation topCandidates:1] firstObject];
            if (topCandidate) [allText appendFormat:@"%@\n", topCandidate.string];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingAlert dismissViewControllerAnimated:YES completion:^{
                if (allText.length > 0) {
                    [UIPasteboard generalPasteboard].string = allText;
                    UIAlertController *resultAlert = [UIAlertController alertControllerWithTitle:@"✅ 识别成功" message:[NSString stringWithFormat:@"已提取 %lu 个字符并复制。", (unsigned long)allText.length] preferredStyle:UIAlertControllerStyleAlert];
                    [resultAlert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
                    [keyWindow.rootViewController presentViewController:resultAlert animated:YES completion:nil];
                } else {
                    UIAlertController *failAlert = [UIAlertController alertControllerWithTitle:@"❌ 识别失败" message:@"未找到文字。" preferredStyle:UIAlertControllerStyleAlert];
                    [failAlert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
                    [keyWindow.rootViewController presentViewController:failAlert animated:YES completion:nil];
                }
            }];
        });
    }];
    
    request.recognitionLanguages = @[@"zh-Hans", @"en-US"];
    request.recognitionLevel = VNRequestTextRecognitionLevelAccurate;
    
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:screenshot.CGImage options:@{}];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [handler performRequests:@[request] error:nil];
    });
}
%end
