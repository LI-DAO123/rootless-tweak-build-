ARCHS = arm64 arm64e
TARGET = iphone:clang:17.0:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MyFirstTweak
MyFirstTweak_FILES = Tweak.x
MyFirstTweak_FILTER = Filter.plist
MyFirstTweak_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard || true"
