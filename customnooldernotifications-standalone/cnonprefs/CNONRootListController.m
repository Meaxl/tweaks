#include "CNONRootListController.h"

@implementation CNONRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

// send respring notification
-(void)apply {
	[self.view endEditing:YES];
	//CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("degarni.tweaks.cnon/respring"), NULL, NULL, YES);
}

@end
