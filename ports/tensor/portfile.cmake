# Adapted from https://devblogs.microsoft.com/cppblog/registries-bring-your-own-libraries-to-vcpkg/
if(EXISTS "${CURRENT_INSTALLED_DIR}/share/tensor/copyright")
    message(FATAL_ERROR "Can't build ${PORT} if tensor is installed. Please remove tensor:${TARGET_TRIPLET}, and try to install ${PORT}:${TARGET_TRIPLET} again.")
endif()

SET(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO juanjosegarciaripoll/tensor
  REF 5c155422fa7e4239087b633e62ffdcbf40724e9e
  SHA512 f6125820b59cf89f0fa8de72918ad342f427879ae1662127bebe2952cc8b8e9ba65f5eaeed1086216671fbf62a77c236cc44b036e4da580344a58daed59853ff
  HEAD_REF cmake
)

vcpkg_configure_cmake(
  SOURCE_PATH "${SOURCE_PATH}"
  DISABLE_PARALLEL_CONFIGURE
  OPTIONS -DTENSOR_ARPACK=ON -DTENSOR_FFTW=ON -DTENSOR_OPTIMIZED_BUILD=ON -DTENSOR_TEST=OFF -DTENSOR_BUILD_PROFILE=OFF -DTENSOR_FORCE_STATIC=ON
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(
  PACKAGE_NAME tensor
  CONFIG_PATH lib/cmake/tensor)

# handle copyright
file(INSTALL "${SOURCE_PATH}/COPYRIGHT" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

# remove debug includes
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)