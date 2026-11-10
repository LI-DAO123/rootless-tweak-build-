Tweak_NAME = UniversalTweak
export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:15.0
export THEOS_PACKAGE_SCHEME = rootless
export TARGET_CODESIGN = ldid

# 🚨 就是这行！没有这行，设置界面永远进不去手机！
export THEOS_PACKAGE_INSTALL_PREFIX = layout

include $(THEOS)/makefiles/common.mk
TWEAK_NAME = $(Tweak_NAME)
$(TWEAK_NAME)_FILES = Tweak.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = UIKit
include $(THEOS_MAKE_PATH)/tweak.mk
