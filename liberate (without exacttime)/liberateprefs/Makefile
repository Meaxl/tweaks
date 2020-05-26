include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e
BUNDLE_NAME = liberateprefs
TARGET = iphone:clang:13.2:11.0

liberateprefs_FILES = Preferences.m LBRLinkCell.m LBRTableCell.m
liberateprefs_INSTALL_PATH = /Library/PreferenceBundles
liberateprefs_FRAMEWORKS = UIKit
liberateprefs_PRIVATE_FRAMEWORKS = Preferences
liberateprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(BUNDLE_NAME).plist$(ECHO_END)