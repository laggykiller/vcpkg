set(program_name pkg-config)
if(DEFINED "ENV{PKG_CONFIG}")
    debug_message(STATUS "PKG_CONFIG found in ENV! Using $ENV{PKG_CONFIG}")
    set(PKGCONFIG "$ENV{PKG_CONFIG}" CACHE INTERNAL "")
    set(PKGCONFIG "${PKGCONFIG}" PARENT_SCOPE)
    return()
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "OpenBSD")
    # As of 6.8, the OpenBSD specific pkg-config doesn't support {pcfiledir}
    set(rename_binary_to "pkg-config")
    set(program_version 0.29.2.1)
    set(raw_executable ON)
    set(download_filename "pkg-config.openbsd")
    set(tool_subdirectory "openbsd")
    set(download_urls "https://raw.githubusercontent.com/jgilje/pkg-config-openbsd/master/pkg-config")
    set(download_sha512 b7ec9017b445e00ae1377e36e774cf3f5194ab262595840b449832707d11e443a102675f66d8b7e8b2e2f28cebd6e256835507b1e0c69644cc9febab8285080b)
    set(version_command --version)
elseif(CMAKE_HOST_WIN32)
    if(NOT EXISTS "${PKGCONFIG}")
        set(program_version 1.9.5)
        if(DEFINED ENV{PROCESSOR_ARCHITEW6432})
            set(host_arch "$ENV{PROCESSOR_ARCHITEW6432}")
        else()
            set(host_arch "$ENV{PROCESSOR_ARCHITECTURE}")
        endif()

        if("${host_arch}" STREQUAL "ARM64")
            vcpkg_acquire_msys(PKGCONFIG_ROOT
                NO_DEFAULT_PACKAGES
                DIRECT_PACKAGES
                    "https://repo.msys2.org/mingw/clangarm64/mingw-w64-clang-aarch64-pkgconf-1~1.9.5-1-any.pkg.tar.zst"
                    f44bc7fe43f41a3329dd86e39033e06929066a11a77143b995f1b23be256054670eb508c6a48cd9530f08ce48a35204c374945d463f0e887b7dc641d63f00cb0
            )
            set("${program}" "${PKGCONFIG_ROOT}/clangarm64/bin/pkg-config.exe" CACHE INTERNAL "")
        elseif("${host_arch}" MATCHES "64")
            vcpkg_acquire_msys(PKGCONFIG_ROOT
                NO_DEFAULT_PACKAGES
                DIRECT_PACKAGES
                    "https://github.com/laggykiller/MINGW-packages/releases/download/pkgconf-traverse_id-1/mingw-w64-x86_64-pkgconf-1.478199b425b46e9dae36bb174f1bd08bf3ffb0f1-1-any.pkg.tar.zst"
                    af8a765cf2607ce0bb743cf7633ff56980d320f5ae3219fe62ff2e652e6500ecd52fd200b5b6c389d53b72324e8b8d7a2ac503aee6a7b900520e22245b3da0ed
            )
            set("${program}" "${PKGCONFIG_ROOT}/mingw64/bin/pkg-config.exe" CACHE INTERNAL "")
        else()
            vcpkg_acquire_msys(PKGCONFIG_ROOT
                NO_DEFAULT_PACKAGES
                DIRECT_PACKAGES
                    "https://github.com/laggykiller/MINGW-packages/releases/download/pkgconf-traverse_id-1/mingw-w64-clang-i686-pkgconf-1.478199b425b46e9dae36bb174f1bd08bf3ffb0f1-1-any.pkg.tar.zst"
                    68199ece10e9ef08c575ea774494c7ab4e9aff9206f8af947746986cc8fa2b3e14c5b91f764ee45f57615066302263bf772d6da9ce299c8ea6fb5bfa2dd0818e
            )
            set("${program}" "${PKGCONFIG_ROOT}/mingw32/bin/pkg-config.exe" CACHE INTERNAL "")
        endif()
    endif()
    set("${program}" "${${program}}" PARENT_SCOPE)
    return()
else()
    set(brew_package_name pkg-config)
    set(apt_package_name pkg-config)
    set(paths_to_search "/bin" "/usr/bin" "/usr/local/bin")
    if(VCPKG_HOST_IS_OSX)
        vcpkg_list(PREPEND paths_to_search "/opt/homebrew/bin")
    endif()
endif()
