#import <Tweak.h>

// RESPRING FUNCTION //
@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)exitAndRelaunch:(bool)arg1;
@end

static void RespringDevice() {
    [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}
// ----------------- //

// DECLARE PREF THINGS //
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSNumber *eEnabled = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:nsDomainString];
	NSNumber *eHideNoOlderNotifs = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideNoOlderNotifs" inDomain:nsDomainString];
	NSNumber *eStatusBarShowTimeLS = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"statusBarShowTimeLS" inDomain:nsDomainString];
	NSNumber *ehidePageDots = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"hidePageDots" inDomain:nsDomainString];	
	NSNumber *ehideHomeBar = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideHomeBar" inDomain:nsDomainString];
	NSNumber *ehideWeatherInfo = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideWeatherInfo" inDomain:nsDomainString];
	NSNumber *eHideFolderTitle = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideFolderTitle" inDomain:nsDomainString];
    NSNumber *eHideFolderBG = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideFolderBG" inDomain:nsDomainString];
	NSNumber *eHideSpotlight = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideSpotlight" inDomain:nsDomainString];
	NSNumber *eHideZoom = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideZoom" inDomain:nsDomainString];

	enabled = (eEnabled) ? [eEnabled boolValue]:NO;

	hideNoOlderNotifs = (eHideNoOlderNotifs) ? [eHideNoOlderNotifs boolValue]:NO;
	statusBarShowTimeLS = (eStatusBarShowTimeLS) ? [eStatusBarShowTimeLS boolValue]:NO;
	hidePageDots = (ehidePageDots) ? [ehidePageDots boolValue]:NO;
	hideHomeBar = (ehideHomeBar) ? [ehideHomeBar boolValue]:NO;
	hideWeatherInfo = (ehideWeatherInfo) ? [ehideWeatherInfo boolValue]:NO;
	hideFolderTitle = (eHideFolderTitle) ? [eHideFolderTitle boolValue]:NO;
    hideFolderBG = (eHideFolderBG) ? [eHideFolderBG boolValue]:NO;
	hideSpotlight = (eHideSpotlight) ? [eHideSpotlight boolValue]:NO;
	hideZoom = (eHideZoom) ? [eHideZoom boolValue]:NO;
}
// ------------------- //

//	+++ HOOKS +++	//
/* hideNoOlderNotif */
%hook NCNotificationListSectionRevealHintView
-(void)didMoveToWindow {
    %orig;
    if (enabled && hideNoOlderNotifs) {
        self.revealHintTitle.string = @"";
    }
}
%end

/* 	  SBShowTimeLS  */
%hook CSCoverSheetViewController
-(bool)shouldShowLockStatusBarTime {
	if (enabled && statusBarShowTimeLS) {
		return YES;
	} else {
		return %orig;
	}
}
%end

/* 	  hidePageDots 	*/
%hook SBIconListPageControl
-(void)layoutSubviews {
	if (enabled && hidePageDots) {
		self.hidden = YES;
	} else {
		return %orig;
	}
}
%end

/*    hideHomeBar   */
%hook MTStaticColorPillView // Lockscreen Homebar
-(void)setPillColor:(UIColor *)color {
	if (enabled && hideHomeBar) {
		color = [UIColor clearColor];
		%orig(color);
	} else {
		return %orig;
	}
}
%end
%hook MTLumaDodgePillView // Home-/Appscreen Homebar
-(void)setStyle:(long long)arg1 { 
	if (enabled && hideHomeBar) {
		return %orig(0);
	} else {
		return %orig;
	}
}
%end

/*	hideWeatherInfo */
%hook WGWidgetAttributionView
-(void)layoutSubviews {
	if (enabled && hideWeatherInfo) {
		self.hidden = YES;
	} else {
		return %orig;
	}
}
%end

/*  hideFolderTitle */
%hook SBFloatyFolderView
-(bool)_showsTitle {
	if (enabled && hideFolderTitle) {
		return NO;
	} else {
		return %orig;
	}
}
%end

/* 	 hideFolderBG   */
%hook SBFloatyFolderView
-(void)setBackgroundAlpha:(CGFloat)arg1 {
	if (enabled && hideFolderBG) {
		%orig(0.0);
	} else {
		return %orig;
	}
}
%end

/*	hideSpotlight	*/
%hook SBSearchScrollView
-(bool)gestureRecognizerShouldBegin:(id)arg1 {
	if (enabled && hideSpotlight) {
		return NO;
	} else {
		return %orig;
	}
}
%end

/*	  hideInfZoom	*/
%hook PUOneUpSettings
-(void)setDefaultMaximumZoomFactor:(CGFloat)factor {
	if (enabled && hideZoom) {
		%orig(INFINITY);
	} else {
		return %orig;
	}
}
%end
// ----------------- //

// LISTENERS //
%ctor {
    // prefs changed listener
    notificationCallback(NULL, NULL, NULL, NULL, NULL);
    CFNotificationCenterAddObserver(
		CFNotificationCenterGetDarwinNotifyCenter(), 
		NULL, 
		notificationCallback, 
		(CFStringRef)nsNotificationString, 
		NULL, 
		CFNotificationSuspensionBehaviorCoalesce
	);

    // respring listener
    CFNotificationCenterAddObserver(
		CFNotificationCenterGetDarwinNotifyCenter(), 
		NULL, 
		(CFNotificationCallback)RespringDevice, 
		CFSTR("degarni.tweaks.liberate/respring"), 
		NULL, 
		CFNotificationSuspensionBehaviorDeliverImmediately);
}
// --------- //