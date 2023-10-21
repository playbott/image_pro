cmake_minimum_required(VERSION 3.18)

include_directories(src/include)

LINK_DIRECTORIES("/src/main/jniLibs/${ANDROID_ABI}")

add_library(libbild SHARED IMPORTED GLOBAL)
set_target_properties(libbild PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/${ANDROID_ABI}/libbild.so)
target_link_libraries(libbild)
