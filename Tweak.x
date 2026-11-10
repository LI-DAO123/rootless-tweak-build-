#import <UIKit/UIKit.h>
#import <Vision/Vision.h>

%hook SpringBoard

// Hook 状态栏的双击事件
- (void)_handleStatusBarDoubleTap:(id)arg1 {
    %orig;
    
    // 1. 获取当前屏幕的截图
    UIWindow *keyWindow = nil;
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *window in scene.windows) {
                if (window.isKeyWindow) { keyWindow = window; break; }
            }
        }
    }
    if (!keyWindow) return;

    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithBounds:keyWindow.bounds];
    UIImage *screenshot = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        [keyWindow drawViewHierarchyInRect:keyWindow.bounds afterScreenUpdates:YES];
    }];
    
    // 提示开始识别
    UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:nil message:@"正在识别屏幕文字..." preferredStyle:UIAlertControllerStyleAlert];
    [keyWindow.rootViewController presentViewController:loadingAlert animated:YES completion:nil];

    // 2. 调用苹果 Vision 框架进行 OCR 文字识别
    VNRecognizeTextRequest *request = [[VNRecognizeTextRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        if (error) return;
        
        NSMutableString *allText = [NSMutableString string];
        for (VNRecognizedTextObservation *observation in request.results) {
            VNRecognizedText *topCandidate = [[observation topCandidates:1] firstObject];
            if (topCandidate) {
                [allText appendFormat:@"%@\n", topCandidate.string];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingAlert dismissViewControllerAnimated:YES completion:^{
                if (allText.length > 0) {
                    // 识别成功，复制到剪贴板并弹窗
                    [UIPasteboard generalPasteboard].string = allText;
                    
                    UIAlertController *resultAlert = [UIAlertController alertControllerWithTitle:@"✅ 识别成功" 
                                                                                         message:[NSString stringWithFormat:@"已提取到 %lu 个字符并复制到剪贴板。\n\n(由于篇幅限制，请在任意输入框粘贴查看)", (unsigned long)allText.length] 
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                    [resultAlert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
                    [keyWindow.rootViewController presentViewController:resultAlert animated:YES completion:nil];
                } else {
                    // 没识别到
                    UIAlertController *failAlert = [UIAlertController alertControllerWithTitle:@"❌ 识别失败" 
                                                                                       message:@"屏幕上没有找到可识别的文字（可能是图像太模糊或没有文字）" 
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                    [failAlert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
                    [keyWindow.rootViewController presentViewController:failAlert animated:YES completion:nil];
                }
            }];
        });
    }];
    
    // 设置为支持中文识别
    request.recognitionLanguages = @[@"zh-Hans", @"en-US"];
    request.recognitionLevel = VNRequestTextRecognitionLevelAccurate;
    
    // 3. 执行识别请求
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:screenshot.CGImage options:@{}];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [handler performRequests:@[request] error:nil];
    });
}

%end
