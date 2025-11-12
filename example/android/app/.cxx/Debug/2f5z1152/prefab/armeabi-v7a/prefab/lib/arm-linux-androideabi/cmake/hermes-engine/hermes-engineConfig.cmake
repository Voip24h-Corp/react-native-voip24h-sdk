if(NOT TARGET hermes-engine::libhermes)
add_library(hermes-engine::libhermes SHARED IMPORTED)
set_target_properties(hermes-engine::libhermes PROPERTIES
    IMPORTED_LOCATION "/Users/tanphat12041998/.gradle/caches/8.10.2/transforms/ef24fa952371840de6b363eb1c7fd968/transformed/hermes-android-0.77.3-debug/prefab/modules/libhermes/libs/android.armeabi-v7a/libhermes.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/tanphat12041998/.gradle/caches/8.10.2/transforms/ef24fa952371840de6b363eb1c7fd968/transformed/hermes-android-0.77.3-debug/prefab/modules/libhermes/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

