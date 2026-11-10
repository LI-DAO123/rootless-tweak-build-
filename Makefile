Tweak_NAME = UniversalTweak
export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:15.0
export THEOS_PACKAGE_SCHEME = rootless
export TARGET_CODESIGN = ldid

# 必须有这一行，否则 layout 里的设置文件进不去包里
export THEOS_PACKAGE_INSTALL_PREFIX = layout

include $(THEOS)/makefiles/common.mk
TWEAK_NAME = $(Tweak_NAME)
$(TWEAK_NAME)_FILES = Tweak.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = UIKit Vision CoreGraphics
include $(THEOS_MAKE_PATH)/tweak.mk
