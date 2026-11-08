ARCHS = arm64 arm64e
目标 = iPhone：clang：17.0：15.0
THEOS_PACKAGE_SCHEME = 无根模式

包括 $(THEOS)/makefiles/common.mk

TWEAK_NAME = 我的第一个修改
MyFirstTweak_FILES = Tweak.x
MyFirstTweak_FILTER = Filter.plist
MyFirstTweak_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

包括 $(THEOSMAKE_PATH)/tweak.mk

安装后::
	install.exec “killall -9 SpringBoard || true”
