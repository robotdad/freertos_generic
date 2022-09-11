# CMake template file
# Use this file with
# . ~/.vcpkg/vcpkg-init.ps1
# vcpkg activate
# cmake --preset m33-debug
# cmake --build --preset m33-debug

cmake_minimum_required(VERSION 3.20)

# Optional: print out extra messages to see what is going on. Comment it to have less verbose messages
set(CMAKE_VERBOSE_MAKEFILE ON)

enable_language(C ASM)
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

SET(CMAKE_STATIC_LIBRARY_PREFIX)
SET(CMAKE_STATIC_LIBRARY_SUFFIX)

SET(CMAKE_EXECUTABLE_LIBRARY_PREFIX)
SET(CMAKE_EXECUTABLE_LIBRARY_SUFFIX)

# CURRENT DIRECTORY
SET(ProjDirPath ${CMAKE_CURRENT_SOURCE_DIR})

# Setup project
project(freertos_generic)
set(MCUX_SDK_PROJECT_NAME ${PROJECT_NAME}.elf)

include(flags.cmake)
include(config.cmake)

# Optional: issue a message to be sure it uses the correct toolchain file.
message(STATUS "CMAKE_TOOLCHAIN_FILE is: ${CMAKE_TOOLCHAIN_FILE}")

set(SOURCES
    "app/freertos_generic.c"
    "app/pin_mux.c"
    "app/pin_mux.h"
    "app/FreeRTOSConfig.h"
    "app/board.c"
    "app/board.h"
    "app/clock_config.c"
    "app/clock_config.h"
)

add_executable(${MCUX_SDK_PROJECT_NAME} ${SOURCES})

target_include_directories(${MCUX_SDK_PROJECT_NAME} PRIVATE
    app/
)

set(CMAKE_MODULE_PATH
    ${ProjDirPath}/rtos/freertos/freertos_kernel
    ${ProjDirPath}/device/LPC55S69/drivers
    ${ProjDirPath}/device/LPC55S69
    ${ProjDirPath}/device/LPC55S69/utilities
    ${ProjDirPath}/components/uart
    ${ProjDirPath}/components/serial_manager
    ${ProjDirPath}/components/lists
    ${ProjDirPath}/CMSIS/Core/Include
)

# include modules
include(middleware_freertos-kernel_cm33_nonsecure_port_LPC55S69_cm33_core0)
include(middleware_freertos-kernel_heap_4_LPC55S69_cm33_core0)
include(driver_common_LPC55S69_cm33_core0)
include(driver_power_LPC55S69_cm33_core0)
include(driver_clock_LPC55S69_cm33_core0)
include(device_LPC55S69_CMSIS_LPC55S69_cm33_core0)
include(device_LPC55S69_startup_LPC55S69_cm33_core0)
include(driver_flexcomm_usart_LPC55S69_cm33_core0)
include(driver_flexcomm_LPC55S69_cm33_core0)
include(driver_lpc_iocon_LPC55S69_cm33_core0)
include(driver_lpc_gpio_LPC55S69_cm33_core0)
include(utility_assert_LPC55S69_cm33_core0)
include(utility_debug_console_LPC55S69_cm33_core0)
include(component_usart_adapter_LPC55S69_cm33_core0)
include(component_serial_manager_LPC55S69_cm33_core0)
include(component_lists_LPC55S69_cm33_core0)
include(component_serial_manager_uart_LPC55S69_cm33_core0)
include(middleware_freertos-kernel_LPC55S69_cm33_core0)
include(middleware_freertos-kernel_extension_LPC55S69_cm33_core0)
include(driver_reset_LPC55S69_cm33_core0)
include(CMSIS_Include_core_cm_LPC55S69_cm33_core0)
include(utilities_misc_utilities_LPC55S69_cm33_core0)
include(device_LPC55S69_system_LPC55S69_cm33_core0)

TARGET_LINK_LIBRARIES(${MCUX_SDK_PROJECT_NAME} PRIVATE -Wl,--start-group)
TARGET_LINK_LIBRARIES(${MCUX_SDK_PROJECT_NAME} PRIVATE m)
TARGET_LINK_LIBRARIES(${MCUX_SDK_PROJECT_NAME} PRIVATE c)
TARGET_LINK_LIBRARIES(${MCUX_SDK_PROJECT_NAME} PRIVATE gcc)
TARGET_LINK_LIBRARIES(${MCUX_SDK_PROJECT_NAME} PRIVATE nosys)
TARGET_LINK_LIBRARIES(${MCUX_SDK_PROJECT_NAME} PRIVATE -Wl,--end-group)

# Optional: Print executable size as part of the post build process
add_custom_command(TARGET ${MCUX_SDK_PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_SIZE_UTIL} ${MCUX_SDK_PROJECT_NAME})

# Optional: Create hex, bin and S-Record files after the build
add_custom_command(TARGET ${MCUX_SDK_PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O srec --srec-len=64 "${MCUX_SDK_PROJECT_NAME}" "${PROJECT_NAME}.s19"
        COMMAND ${CMAKE_OBJCOPY} -O ihex "${MCUX_SDK_PROJECT_NAME}" "${PROJECT_NAME}.hex"
        COMMAND ${CMAKE_OBJCOPY} -O binary "${MCUX_SDK_PROJECT_NAME}" "${PROJECT_NAME}.bin" 
        )
