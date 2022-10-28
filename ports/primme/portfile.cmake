# Adapted from https://devblogs.microsoft.com/cppblog/registries-bring-your-own-libraries-to-vcpkg/
if(EXISTS "${CURRENT_INSTALLED_DIR}/share/primme/copyright")
    message(FATAL_ERROR "Can't build ${PORT} if primme is installed. Please remove primme:${TARGET_TRIPLET}, and try to install ${PORT}:${TARGET_TRIPLET} again.")
endif()

include(vcpkg_find_fortran)
SET(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO juanjosegarciaripoll/primme
  REF 5453190ca5ef9b13d1954feef2419cdd5d8c0deb
  SHA512 51084cb412aba1e895ea2b29d40f3509f3ca55fd42ba0a896ead632164bffcfd3eab3a9d12a3339df41cc350ebaf1bc44f559134554f61d877413446126effe9
  HEAD_REF cmake
)

if(NOT VCPKG_TARGET_IS_WINDOWS)
  set(ENV{FFLAGS} "$ENV{FFLAGS} -fPIC")
endif()

vcpkg_find_fortran(FORTRAN_CMAKE)

vcpkg_configure_cmake(
  SOURCE_PATH "${SOURCE_PATH}"
  PREFER_NINJA
  OPTIONS
  ${FORTRAN_CMAKE}
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(
  PACKAGE_NAME primme
  CONFIG_PATH lib/cmake/primme
  NO_PREFIX_CORRECTION)

# handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

vcpkg_fixup_pkgconfig()

# remove debug includes
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

if(VCPKG_TARGET_IS_WINDOWS)
    if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/libprimme.lib")
        file(RENAME "${CURRENT_PACKAGES_DIR}/lib/libprimme.lib" "${CURRENT_PACKAGES_DIR}/lib/primme.lib")
    endif()
endif()
