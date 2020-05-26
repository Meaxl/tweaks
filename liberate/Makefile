include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e
TWEAK_NAME = Liberate
TARGET = iphone:clang:13.2:11.0

INSTALL_TARGET_PROCESSES = SpringBoard

Liberate_FILES = Tweak.xm
Liberate_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += liberateprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
