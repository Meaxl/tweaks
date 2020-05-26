ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = liberateprefs

liberateprefs_FILES = LibRootListController.m
liberateprefs_INSTALL_PATH = /Library/PreferenceBundles
liberateprefs_FRAMEWORKS = UIKit
liberateprefs_PRIVATE_FRAMEWORKS = Preferences
liberateprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/liberateprefs.plist$(ECHO_END)
