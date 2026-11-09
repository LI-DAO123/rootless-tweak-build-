Tweak_NAME = UniversalTweak
export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:15.0
export THEOS_PACKAGE_SCHEME = roothide

include $(THEOS)/makefiles/common.mk
TWEAK_NAME = $(Tweak_NAME)
$(TWEAK_NAME)_FILES = Tweak.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk
