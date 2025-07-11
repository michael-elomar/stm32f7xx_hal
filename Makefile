##########################################################################################################################
# File automatically-generated by tool: [projectgenerator] version: [4.6.0.1-B1] date: [Sun Jun 15 14:37:53 CEST 2025]
##########################################################################################################################

# ------------------------------------------------
# Generic Makefile (based on gcc)
#
# ChangeLog :
#	2017-02-10 - Several enhancements + project update mode
#   2015-07-22 - first version
# ------------------------------------------------

# CURRENT DIR
LOCAL_PATH := ${CURDIR}


######################################
# target
######################################
TARGET = libstm32f7xx_hal


######################################
# building variables
######################################
# debug build
DEBUG = 1
# optimization
OPT = -Og


#######################################
# paths
#######################################
# Build path
BUILD_DIR = $(LOCAL_PATH)/build
# Out path
ifdef PREFIX
OUT_DIR = $(PREFIX)
else
OUT_DIR = $(LOCAL_PATH)/out
endif


OUT_DIR_LIB = $(OUT_DIR)/lib
OUT_DIR_INCLUDE = $(OUT_DIR)/include
######################################
# source
######################################
C_SOURCES = $(shell find $(LOCAL_PATH)/stm32f7xx-hal-driver/Src/ -type f -name "*.c" ! -name "*template*.c")

#######################################
# binaries
#######################################
PREFIX = arm-none-eabi-
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.

ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
AR = $(GCC_PATH)/$(PREFIX)ar
else
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
AR = $(PREFIX)ar
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

#######################################
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m7

# fpu
FPU = -mfpu=fpv5-d16

# float-abi
FLOAT-ABI = -mfloat-abi=hard

# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# macros for gcc
# AS defines
AS_DEFS =

# C defines
C_DEFS =  \
-DUSE_FULL_LL_DRIVER \
-DUSE_HAL_DRIVER \
-DSTM32F767xx

# C includes
C_INCLUDES =  \
-Istm32f7xx-hal-driver/Inc \
-Istm32f7xx-hal-driver/Inc/Legacy \
-ICMSIS/Device/Include \
-ICMSIS/Include \
-IInclude

CFLAGS += $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif


# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"

#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = STM32F767XX_FLASH.ld

# libraries
LIBS = -lc -lm -lnosys
LDFLAGS = $(MCU) -specs=nano.specs $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# default action: build all
all: $(TARGET).a headers

#######################################
# build the application
#######################################
# list of objects

OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(TARGET).a: $(OBJECTS) Makefile | $(OUT_DIR) $(OUT_DIR_INCLUDE) $(OUT_DIR_LIB)
	$(AR) rcs $(OUT_DIR_LIB)/$(TARGET).a $(OBJECTS)

headers:
	cp -r --parents stm32f7xx-hal-driver/Inc/ $(OUT_DIR_INCLUDE)
	cp -r --parents stm32f7xx-hal-driver/Inc/Legacy/ $(OUT_DIR_INCLUDE)
	cp -r --parents CMSIS/Device/Include/* $(OUT_DIR_INCLUDE)
	cp -r --parents CMSIS/Include/* $(OUT_DIR_INCLUDE)
	cp -r --parents Include/ $(OUT_DIR_INCLUDE)

$(BUILD_DIR):
	mkdir $@

$(OUT_DIR):
	mkdir $@

$(OUT_DIR_LIB):
	mkdir $@

$(OUT_DIR_INCLUDE):
	mkdir $@

#######################################
# clean up
#######################################
clean:
	-rm -fR $(BUILD_DIR) $(OUT_DIR)

#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# *** EOF ***