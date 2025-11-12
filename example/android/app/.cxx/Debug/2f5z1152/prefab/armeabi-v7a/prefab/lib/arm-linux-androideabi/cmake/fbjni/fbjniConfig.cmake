if(NOT TARGET fbjni::fbjni)
add_library(fbjni::fbjni SHARED IMPORTED)
set_target_properties(fbjni::fbjni PROPERTIES
    IMPORTED_LOCATION "/Users/tanphat12041998/.gradle/caches/8.10.2/transforms/5fe158f8ea163bb35d3bf43c1a22f754/transformed/fbjni-0.7.0/prefab/modules/fbjni/libs/android.armeabi-v7a/libfbjni.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/tanphat12041998/.gradle/caches/8.10.2/transforms/5fe158f8ea163bb35d3bf43c1a22f754/transformed/fbjni-0.7.0/prefab/modules/fbjni/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

