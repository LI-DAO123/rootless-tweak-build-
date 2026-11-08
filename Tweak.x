%hook SpringBoard
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    NSLog(@"MyFirstTweak loaded");
}
%end
