ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MyFirstTweak

MyFirstTweak_FILES = Tweak.x
MyFirstTweak_FRAMEWORKS = UIKit Foundation
MyFirstTweak_USE_MODULES = 0

include $(THEOS_MAKE_PATH)/tweak.mk
