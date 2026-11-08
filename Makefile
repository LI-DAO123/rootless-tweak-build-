# 原来可能是：TARGET = iphone:clang:latest:15.0
# 改为下面这样：
TARGET = iphone:clang:15.0:15.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Tweak
Tweak_FILES = Tweak.x

include $(THEOS_MAKE_PATH)/tweak.mk
