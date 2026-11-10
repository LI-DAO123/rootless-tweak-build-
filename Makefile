Tweak_NAME = UniversalTweak

# 兼容双架构
export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:15.0

# 无根模式打包 (完美兼容 Dopamine 和 RootHide)
export THEOS_PACKAGE_SCHEME = rootless

# 强制签名
export TARGET_CODESIGN = ldid

# 将 layout 文件夹内容打包进 deb (用于设置界面)
export THEOS_PACKAGE_INSTALL_PREFIX = layout

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = $(Tweak_NAME)
$(TWEAK_NAME)_FILES = Tweak.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = UIKit Vision CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk
