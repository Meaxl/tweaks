// respring function
@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)exitAndRelaunch:(bool)arg1;
@end

static void RespringDevice() {
    [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

// prefs
@interface NSUserDefaults (LiberatePrefs)
-(id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
-(void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

static NSString *nsDomainString = @"degarni.tweaks.liberate";
static NSString *nsNotificationString = @"degarni.tweaks.liberate/preferences.changed";

// declare pref things here (switches, buttons, etc.)
static BOOL enabled;
static BOOL statusBarShowTimeLS;
static BOOL hideFolderTitle;
static BOOL hideFolderBG;
static BOOL hideFolderBGSB;
static BOOL hideFolderDots;
static BOOL hideNoOlderNotifs;
static BOOL hideCCGrabber;
static BOOL hideZoom;
static BOOL hideSpotlight;
static BOOL hideWeatherInfo;

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSNumber *eEnabled = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:nsDomainString];
    NSNumber *eStatusBarShowTimeLS = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"statusBarShowTimeLS" inDomain:nsDomainString];
    NSNumber *eHideFolderTitle = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideFolderTitle" inDomain:nsDomainString];
    NSNumber *eHideFolderBG = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideFolderBG" inDomain:nsDomainString];
    NSNumber *eHideFolderBGSB = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideFolderBGSB" inDomain:nsDomainString];
    NSNumber *eHideFolderDots = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideFolderDots" inDomain:nsDomainString];
    NSNumber *eHideNoOlderNotifs = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideNoOlderNotifs" inDomain:nsDomainString];
    NSNumber *eHideCCGrabber = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideCCGrabber" inDomain:nsDomainString];
    NSNumber *eHideZoom = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideZoom" inDomain:nsDomainString];
    NSNumber *eHideSpotlight = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideSpotlight" inDomain:nsDomainString];
    NSNumber *ehideWeatherInfo = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideWeatherInfo" inDomain:nsDomainString];

    enabled = (eEnabled) ? [eEnabled boolValue]:NO;

    statusBarShowTimeLS = (eStatusBarShowTimeLS) ? [eStatusBarShowTimeLS boolValue]:NO;
    hideFolderTitle = (eHideFolderTitle) ? [eHideFolderTitle boolValue]:NO;
    hideFolderBG = (eHideFolderBG) ? [eHideFolderBG boolValue]:NO;
    hideFolderBGSB = (eHideFolderBGSB) ? [eHideFolderBGSB boolValue]:NO;
    hideFolderDots = (eHideFolderDots) ? [eHideFolderDots boolValue]:NO;
    hideNoOlderNotifs = (eHideNoOlderNotifs) ? [eHideNoOlderNotifs boolValue]:NO;
    hideCCGrabber = (eHideCCGrabber) ? [eHideCCGrabber boolValue]:NO;
    hideZoom = (eHideZoom) ? [eHideZoom boolValue]:NO;
    hideSpotlight = (eHideSpotlight) ? [eHideSpotlight boolValue]:NO;
    hideWeatherInfo = (ehideWeatherInfo) ? [ehideWeatherInfo boolValue]:NO;
}

// HEADERS AND HOOKS START //
#import <UIKit/UIKit.h>
#import <UIKit/UITextView.h>

@interface SBIconView : UIView
-(void)setLabelHidden:(BOOL)hidden;
@end

@interface SBIcon : NSObject
-(id)badgeNumberOrString;
@end

@interface CSTeachableMomentsContainerView
@property (nonatomic,retain) UIView * controlCenterGrabberView;
@end

@interface SBDashBoardTeachableMomentsContainerView
@property (nonatomic,retain) UIView * controlCenterGrabberView;
@end

@interface SBFolderIconImageView : UIView 
@property (nonatomic, retain) UIView *backgroundView;
@end

@interface SBIconListPageControl
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end

@interface SBIconController : NSObject
+(id)sharedInstance;
-(void)_closeFolderController:(id)arg1 animated:(BOOL)arg2 withCompletion:(id)arg3;
@end

@interface SBUILegibilityLabel : UIView
@property (nonatomic,copy) NSString *string;
@end

@interface NCNotificationListSectionRevealHintView : UIView 
@property (nonatomic,retain)SBUILegibilityLabel *revealHintTitle;
@end

@interface WGWidgetAttributionView : UITextView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end

#ifndef kCFCoreFoundationVersionNumber_iOS_13_0
#define kCFCoreFoundationVersionNumber_iOS_13_0 1665.15
#endif

#define kSLSystemVersioniOS13 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_13_0
// HEADERS AND HOOKS END //

// ++ UNIVERSAL IOS GROUP START ++ //
%group universal

// hideNoOlderNotifs START //
%hook NCNotificationListSectionRevealHintView
-(void)didMoveToWindow {
    %orig;
    if (enabled && hideNoOlderNotifs) {
        self.revealHintTitle.string = @"";
    }
}
%end
// hideNoOlderNotifs END //

// hideFolderTitle START //
%hook SBFloatyFolderView
-(BOOL)_showsTitle {
    if (enabled && hideFolderTitle) {
        return NO;
    }
    else {
        return %orig;
    }
}
%end
// hideFolderTitle END //

// hideFolderBG START //
%hook SBFloatyFolderView
-(void)setBackgroundAlpha:(CGFloat)arg1 {
    if (enabled && hideFolderBG) {
        %orig(0.0);
    }
    else {
        %orig;
    }
}
%end

%hook SBFolderIconImageView
-(void)layoutSubviews {
    %orig;
    if (enabled && hideFolderBGSB) {
        self.backgroundView.alpha = 0;
        self.backgroundView.hidden = 1;
    }
}
%end
// hideFolderBG END //

// hideFolderDots START //
%hook SBIconListPageControl
-(void)layoutSubviews {
    if (enabled && hideFolderDots) {
        self.hidden = YES;
    }
    else {
        %orig;
    }
}
%end
// hideFolderDots END //

// hideInfinityZoom START //
%hook PUOneUpSettings
- (void)setDefaultMaximumZoomFactor:(CGFloat)factor {
    if (enabled && hideZoom) {
        %orig(INFINITY);
    }
    else {
        return %orig;
    }
}
%end
// hideInfinityZoom END //

// hideSpotlight START //
%hook SBSearchScrollView
-(bool) gestureRecognizerShouldBegin:(id)arg1 {
    if (enabled && hideSpotlight) {
         return NO;
    }
    else {
        return %orig;
    }
}
%end
// hideSpotlight END //

// hideWeatherInfo START //
%hook WGWidgetAttributionView
-(void)layoutSubviews {
    if (enabled && hideWeatherInfo) {
        self.hidden = YES;
    }
    else {
        %orig;
    }
}
%end
// hideWeatherInfo END

%end
// ++ UNIVERSAL IOS GROUP END ++ //

// ++ IOS 13 GROUP START ++ //
%group ios13

// statusBarShowTimeLS START //
%hook CSCoverSheetViewController
- (bool)shouldShowLockStatusBarTime {
    if (enabled && statusBarShowTimeLS) {
        return YES;
    }
    else {
        return %orig;
    }
}
%end
// statusBarShowTimeLS END //

// hideCCGrabber START //
%hook CSTeachableMomentsContainerView
- (void)layoutSubviews {
    if (enabled && hideCCGrabber) {
        [self.controlCenterGrabberView setHidden:YES];
    }
    else {
        [self.controlCenterGrabberView setHidden:NO];
    }
    return %orig;
}
%end
// hideCCGrabber END //

// hideInfinityZoom START //
%hook PUOneUpSettings
- (void)setDefaultMaximumZoomFactor:(CGFloat)factor {
    if (enabled && hideZoom) {
        %orig(INFINITY);
    }
    else {
        return %orig;
    }
}
%end
// hideInfinityZoom End //

// hideSpotlight START //
%hook SBSearchScrollView
-(bool) gestureRecognizerShouldBegin:(id)arg1 {
    if (enabled && hideSpotlight) {
         return NO;
    }
    else {
        return %orig;
    }
}
%end
// hideSpotlight END //

%end
// ++ IOS 13 GROUP END ++ //

// ++ IOS 12 GROUP START ++ //
%group ios12

// statusBarShowTimeLS START //
%hook SBLockScreenViewControllerBase
- (bool)shouldShowLockStatusBarTime {
    if (enabled && statusBarShowTimeLS) {
        return YES;
    }
    else {
        return %orig;
    }
}
%end
// statusBarShowTimeLS END //

// hideCCGrabber START //
%hook SBDashBoardTeachableMomentsContainerView
- (void)layoutSubviews {
    if (enabled && hideCCGrabber) {
        [self.controlCenterGrabberView setHidden:YES];
    }
    else {
        [self.controlCenterGrabberView setHidden:NO];
    }
    return %orig;
}
%end
// hideCCGrabber END //

%end 
// ++ IOS 12 GROUP END ++ //

// LISTENERS
%ctor {
    %init(universal);
    // check iOS version
    if (kSLSystemVersioniOS13) {
        %init(ios13);
    }
    else {
        %init(ios12);
    }

    // prefs changed listener
    notificationCallback(NULL, NULL, NULL, NULL, NULL);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);

    // respring listener
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)RespringDevice, CFSTR("degarni.tweaks.liberate/respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
