#import <UIKit/UIKit.h>
#import <UIKit/UITextView.h>

// PREFERENCE INTERFACE //
@interface NSUserDefaults (LiberatePrefs)
-(id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
-(void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

static NSString *nsDomainString = @"degarni.tweaks.liberate";
static NSString *nsNotificationString = @"degarni.tweaks.liberate/preferences.changed";
// --------------------- //


static BOOL enabled;                /* TWEAK ON/OFF */
static BOOL hideNoOlderNotifs;      /* LOCKSCREEN */
static BOOL statusBarShowTimeLS;    /* LOCKSCREEN */
static BOOL hidePageDots;           /* HOMESCREEN */
static BOOL hideHomeBar;            /* HOMESCREEN */
static BOOL hideWeatherInfo;        /* HOMESCREEN */
static BOOL hideFolderTitle;        /* HOMESCREEN */
static BOOL hideFolderBG;           /* HOMESCREEN */
static BOOL hideFolderBGSB;         /* HOMESCREEN */
static BOOL hideFolderDots;         /* HOMESCREEN */
static BOOL hideSpotlight;          /* MISCELLANEOUS */
static BOOL hideZoom;               /* MISCELLANEOUS */


/* SETUP INTERFACES/HOOKS */
/*	   hideWeatherInfo    */
@interface WGWidgetAttributionView : UITextView
@property (nonatomic,assign,readwrite,getter=isHidden) BOOL hidden;
@end
/*    hideNoOlderNotifs   */
@interface SBUILegibilityLabel : UIView
@property (nonatomic,copy) NSString *string;
@end
@interface NCNotificationListSectionRevealHintView : UIView 
@property (nonatomic,retain)SBUILegibilityLabel *revealHintTitle;
@end
/*      hidePageDots      */
@interface SBIconListPageControl : UIPageControl
@property (nonatomic,assign,readwrite,getter=isHidden) BOOL hidden;
@end
/*      hideHomeBar       */
@interface MTLumaDodgePillView : UIView
@end
@interface MTStaticColorPillView : UIView
@end
