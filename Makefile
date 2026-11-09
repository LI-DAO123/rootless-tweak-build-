ARCHS = arm64 arm64e
TARGET = iphone:clang:16.2:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DualDeviceTest

DualDeviceTest_FILES = Tweak.x
DualDeviceTest_FRAMEWORKS = UIKit Foundation
DualDeviceTest_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard || true"
