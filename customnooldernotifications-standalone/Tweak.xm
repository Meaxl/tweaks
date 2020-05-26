// remove space between Notificationcenter and ls

@interface SBLockScreenNotificationTableView : UITableView
@end

%hook SBLockScreenNotificationListView
-(id)initWithFrame:(CGRect)arg1 {
	id result = %orig(arg1);
	UIView *containerView = (UIView *)MSHookIvar<UIView *>(self, "_containerView");
	((UIView *)[containerView subviews][1]).hidden = YES;
	((UIView *)[containerView subviews][2]).hidden = YES;
	((UITableView *)MSHookIvar<SBLockScreenNotificationTableView *>(self, "_tableView")).separatorStyle = UITableViewCellSeparatorStyleNone;
	return result;
}
%end

%hook SBDashBoardClippingLine
-(CGFloat)lineAlpha {
	return 0.0;
}

-(void)setLineAlpha:(CGFloat)arg1 {
	%orig(0.0);
}
%end

// respring function
/*@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)exitAndRelaunch:(bool)arg1;
@end

static void RespringDevice() {
    [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}*/

// headers
@interface SBUILegibilityLabel : UIView
@property (nonatomic,copy) NSString *string;
@property (assign,nonatomic) long long textAlignment; 
@end

@interface NCNotificationListSectionRevealHintView : UIView 
@property (nonatomic,retain)SBUILegibilityLabel *revealHintTitle;
@end

// prefs
@interface NSUserDefaults (CnonPrefs)
-(id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
-(void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

static NSString *nsDomainString = @"degarni.tweaks.cnon";
static NSString *nsNotificationString = @"degarni.tweaks.cnon/preferences.changed";

// declare switch and string
static BOOL enabled;
static NSString *customText = @"";

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSNumber *eEnabled = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:nsDomainString];
    NSString *eCustomText = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"customText" inDomain:nsDomainString];

    enabled = (eEnabled) ? [eEnabled boolValue]:NO;
    customText = eCustomText;
}

// check iOS version
#ifndef kCFCoreFoundationVersionNumber_iOS_13_0
#define kCFCoreFoundationVersionNumber_iOS_13_0 1665.15
#endif

#define kSLSystemVersioniOS13 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_13_0

// hook class
%hook NCNotificationListSectionRevealHintView

-(void)didMoveToWindow {
	%orig;
	if (enabled) {
		self.revealHintTitle.string = customText;
		if (kSLSystemVersioniOS13) {
			self.revealHintTitle.textAlignment = 1;
		}
	}
}

%end

%ctor {
	// prefs changed listener
    notificationCallback(NULL, NULL, NULL, NULL, NULL);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);

    // respring notification listener
    //CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)RespringDevice, CFSTR("degarni.tweaks.cnon/respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
