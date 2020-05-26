#include "LiberateRootListController.h"

@implementation LiberateRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

// send respring notification
-(void)saveTapped {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("degarni.tweaks.liberate/respring"), NULL, NULL, YES);
}

// open github on button press
-(void)openRepo {
	[[UIApplication sharedApplication]
		openURL:[NSURL URLWithString:@"https://repo.degarni.de"]
		options:@{}
		completionHandler:nil];
}
@end

@interface LiberateLockController : PSListController
@end
@implementation LiberateLockController
- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [ self loadSpecifiersFromPlistName:@"Lockscreen" target:self];
    }
    [(UINavigationItem *)self.navigationItem setTitle:@"Lockscreen"];
    return _specifiers;
}
@end

@interface LiberateHomeController : PSListController
@end
@implementation LiberateHomeController
- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [ self loadSpecifiersFromPlistName:@"Homescreen" target:self];
    }
    [(UINavigationItem *)self.navigationItem setTitle:@"Homescreen"];
    return _specifiers;
}
@end

@interface LiberateMiscController : PSListController
@end
@implementation LiberateMiscController
- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [ self loadSpecifiersFromPlistName:@"Miscellaneous" target:self];
    }
    [(UINavigationItem *)self.navigationItem setTitle:@"Miscellaneous"];
    return _specifiers;
}
@end