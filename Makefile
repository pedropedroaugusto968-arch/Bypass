TWEAK_NAME = SpaceXit

# Arquivos que o compilador deve ler
SpaceXit_FILES = Tweak.xm
# Bibliotecas necessárias para o Menu e o ESP
SpaceXit_FRAMEWORKS = UIKit QuartzCore CoreGraphics
# Ignorar avisos chatos do iOS novo
SpaceXit_CFLAGS = -fobjc-arc -O3 -Wno-deprecated-declarations -Wno-unused-variable

export ARCHS = arm64
export TARGET = iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
