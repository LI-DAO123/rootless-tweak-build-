ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Tweak
Tweak_FILES = Tweak.x

# 必须包含这一行，它定义了 package 规则
include $(THEOS_MAKE_PATH)/tweak.mk
