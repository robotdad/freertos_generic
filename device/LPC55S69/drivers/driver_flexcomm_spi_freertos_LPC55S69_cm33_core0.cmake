include_guard()
message("driver_flexcomm_spi_freertos component is included.")

target_sources(${MCUX_SDK_PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/fsl_spi_freertos.c
)


target_include_directories(${MCUX_SDK_PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/.
)


include(driver_flexcomm_LPC55S69_cm33_core0)

include(driver_common_LPC55S69_cm33_core0)

include(driver_flexcomm_spi_LPC55S69_cm33_core0)

include(middleware_freertos-kernel_LPC55S69_cm33_core0)

