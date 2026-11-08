# 支持 arm64 (iPhone 6s等老设备) 和 arm64e (iPhone 13等新设备)
ARCHS = arm64 arm64e

# 目标系统版本设定为 15.0 (保证在老设备上能跑，新设备向下兼容)
# 注意：如果你的项目里写死了 15.5，刚才的 workflow 已经拉取了所有 SDK 会解决这个问题，
# 但统一写 15.0 更稳妥。
TARGET = iphone:clang:latest:15.0

# 其他包含的头文件等...
include $(THEOS)/makefiles/common.mk
