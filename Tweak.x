%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 {
	%orig;

	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"成功"
		message:@"MyFirstTweak 已经加载！"
		preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
	[alert addAction:ok];

	UIWindow *win = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	win.rootViewController = [UIViewController new];
	win.windowLevel = 1000000;
	[win makeKeyAndVisible];
	[win.rootViewController presentViewController:alert animated:YES completion:nil];
}

%end
