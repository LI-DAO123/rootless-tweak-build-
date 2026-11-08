ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MyFirstTweak

MyFirstTweak_FILES = Tweak.x
MyFirstTweak_CFLAGS = -fobjc-arc
MyFirstTweak_USE_MODULES = 0

include $(THEOS_MAKE_PATH)/tweak.mk
