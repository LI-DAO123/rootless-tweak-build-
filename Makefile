ARCHS = arm64 arm64e
TARGET = iphone:clang:16.0:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MyFirstTweak
MyFirstTweak_FILES = Tweak.x
MyFirstTweak_FILTER = Filter.plist

include $(THEOS_MAKE_PATH)/tweak.mk
