# Adapted from https://devblogs.microsoft.com/cppblog/registries-bring-your-own-libraries-to-vcpkg/
if(EXISTS "${CURRENT_INSTALLED_DIR}/share/arpackng/copyright")
    message(FATAL_ERROR "Can't build ${PORT} if arpackng is installed. Please remove arpackng:${TARGET_TRIPLET}, and try to install ${PORT}:${TARGET_TRIPLET} again.")
endif()

include(vcpkg_find_fortran)
SET(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO juanjosegarciaripoll/arpack-ng
  REF 333c9ca0505d1ff6793a59ac25fa129fd20d71d6
  SHA512 fc3e828991ba7af5de0a256d9aa6101130c08a7a36744e7c3a558a27bb49a523dfcc4ef85d72bbb6b4a978fa113f21cf7dee57aa550554085ae61cbf439a8ab6
  HEAD_REF cmake-essential
)

if(NOT VCPKG_TARGET_IS_WINDOWS)
  set(ENV{FFLAGS} "$ENV{FFLAGS} -fPIC")
endif()

vcpkg_find_fortran(FORTRAN_CMAKE)

vcpkg_configure_cmake(
  SOURCE_PATH "${SOURCE_PATH}"
  PREFER_NINJA
  OPTIONS
  "-DICB=ON"
  ${FORTRAN_CMAKE}
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(
  PACKAGE_NAME arpackng
  CONFIG_PATH lib/cmake/arpackng)

# handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

vcpkg_fixup_pkgconfig()

# remove debug includes
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
