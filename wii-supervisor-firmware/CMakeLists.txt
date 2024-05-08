cmake_minimum_required(VERSION 3.12)

# Pull in SDK (must be before project)
include(pico_sdk_import.cmake)

project(wii_supervisor C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# Initialize the SDK
pico_sdk_init()

include_directories(include)
add_executable(wii_supervisor main.cpp joybus.cpp)

# Pull in our pico_stdlib which aggregates commonly used features
target_link_libraries(wii_supervisor pico_stdlib pico_platform hardware_pio pico_multicore)

# enable usb output, disable uart output
pico_enable_stdio_usb(wii_supervisor 1)
pico_enable_stdio_uart(wii_supervisor 0)

# create map/bin/hex/uf2 file etc.
pico_add_extra_outputs(wii_supervisor)

pico_generate_pio_header(wii_supervisor ${CMAKE_CURRENT_LIST_DIR}/pio/joybus.pio)

add_custom_command(OUTPUT ${CMAKE_CURRENT_LIST_DIR}/generated/joybus.pio.h
        DEPENDS ${CMAKE_CURRENT_LIST_DIR}/joybus.pio
        COMMAND Pioasm ${CMAKE_CURRENT_LIST_DIR}/joybus.pio ${CMAKE_CURRENT_LIST_DIR}/generated/joybus.pio.h
        )
