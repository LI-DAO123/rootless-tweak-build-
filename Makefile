Tweak_NAME = UniversalTweak

# 支持 iPhone 6s Plus (arm64) 和 iPhone 13 (arm64e)
export ARCHS = arm64 arm64e

# 最低支持 iOS 15
export TARGET = iphone:clang:latest:15.0

# 关键修改：改回标准的无根模式，完美兼容 Dopamine 和 RootHide
export THEOS_PACKAGE_SCHEME = rootless

# 强制使用 ldid 签名
export TARGET_CODESIGN = ldid

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = $(Tweak_NAME)
$(TWEAK_NAME)_FILES = Tweak.x
$(Tweak_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
