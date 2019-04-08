set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(APPLE AND NOT IOS)
    set(CMAKE_OSX_DEPLOYMENT_TARGET "10.9" CACHE STRING "Minimum OS X deployment version" FORCE)
endif()

if(MSVC)
    add_compile_options(
        $<$<CONFIG:Release>:/Gy> # Enable function-level linking
        /MP # Multi-processor compilation
        $<$<CONFIG:>:/MT> #---------|
        $<$<CONFIG:Debug>:/MTd> #---|-- Statically link the runtime libraries
        $<$<CONFIG:Release>:/MT> #--|
        $<$<CONFIG:Release>:/Oi> # Generate intrinsic functions
        /permissive- # Standard C++ conformance
        $<$<CONFIG:Debug>:/ZI> # Produces a program database (PDB) that supports edit and continue
        $<$<CONFIG:Release>:/Zi> # Produces a program database (PDB)
    )

    add_link_options(
        $<$<CONFIG:Release>:/DEBUG> # Generate debug information
        $<$<CONFIG:Release>:/LTCG:incremental> # Link-time code generation
        $<$<CONFIG:Release>:/OPT:ICF> # Perform identical COMDAT folding
        $<$<CONFIG:Release>:/OPT:REF> # Eliminates functions and/or data that are never referenced
        /SAFESEH:NO # Don't produce an image with a table of safe exceptions handlers
    )
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    add_link_options(
        -static-libgcc
        -static-libstdc++
    )
elseif(ANDROID)
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -g0")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -g0")
elseif(IOS)
    add_link_options(
        "${XCODE_IOS_PLATFORM_VERSION_FLAGS}"
    )
endif()
