#include "LibRootListController.h"

@implementation LibRootListController

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

-(void)openRepo {
	[[UIApplication sharedApplication]
		openURL:[NSURL URLWithString:@"https://repo.degarni.de"]
		options:@{}
		completionHandler:nil];
}

@end
