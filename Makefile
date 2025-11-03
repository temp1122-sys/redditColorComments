FINALPACKAGE=1
TARGET = iphone:clang:latest:15.0
# INSTALL_TARGET_PROCESSES = SpringBoard
GO_EASY_ON_ME=1
ARCHS = arm64
THEOS_PACKAGE_SCHEME=rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = redditColorComments

redditColorComments_FILES = Tweak.x
redditColorComments_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
