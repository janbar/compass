project(compass C CXX)
cmake_minimum_required(VERSION 3.1.0)

set(APP_VERSION       "0.1.0")
set(APP_VERSION_CODE  1)
set(APP_NAME          "compass")
set(APP_ID            "io.github.janbar.compass")
set(EXEC              "compass")
set(ICON_FILE         "compass.png")
set(DESKTOP_FILE_NAME "compass.desktop")
set(APPDATA_FILE_NAME "compass.appdata.xml")

# Components PATH
execute_process(
  COMMAND dpkg-architecture -qDEB_HOST_MULTIARCH
  OUTPUT_VARIABLE ARCH_TRIPLET
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

# Set install paths
include(GNUInstallDirs)
set(APPDATA_DIR ${CMAKE_INSTALL_DATADIR}/metainfo)
set(DESKTOP_DIR ${CMAKE_INSTALL_DATADIR}/applications)
set(PLUGINS_DIR ${CMAKE_INSTALL_FULL_LIBDIR}/${APP_NAME})
set(COMPASS_GUI "${PLUGINS_DIR}/compass-gui")

install(
  PROGRAMS "${CMAKE_CURRENT_BINARY_DIR}/${EXEC}"
  DESTINATION ${CMAKE_INSTALL_BINDIR}
)

configure_file(
  ${DESKTOP_FILE_NAME}.in
  ${CMAKE_CURRENT_BINARY_DIR}/${DESKTOP_FILE_NAME}
)

install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/${DESKTOP_FILE_NAME}
  DESTINATION ${DESKTOP_DIR} RENAME ${APP_ID}.desktop
)

install(
  FILES "${ICON_FILE}"
  DESTINATION ${CMAKE_INSTALL_DATADIR}/icons/hicolor/256x256/apps RENAME ${APP_NAME}.png
)

configure_file(
  ${APPDATA_FILE_NAME}.in
  ${CMAKE_CURRENT_BINARY_DIR}/${APPDATA_FILE_NAME}
)

install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/${APPDATA_FILE_NAME}
  DESTINATION ${APPDATA_DIR} RENAME ${APP_ID}.appdata.xml
)

add_subdirectory(gui)
if(ANDROID)
  configure_file(
    ${CMAKE_SOURCE_DIR}/android/AndroidManifest.xml.in
    ${CMAKE_SOURCE_DIR}/android/package-sources/AndroidManifest.xml
  )
  include(android/AddQtAndroidApk.cmake)
  #add_dependencies(compass-gui crypto ssl)
  add_qt_android_apk(compass-apk compass-gui
      NAME ${APP_NAME}
      VERSION_CODE ${APP_VERSION_CODE}
      PACKAGE_NAME ${APP_ID}
      PACKAGE_SOURCES ${CMAKE_SOURCE_DIR}/android/package-sources
      BUILDTOOLS_REVISION ${QT_ANDROID_SDK_BUILDTOOLS_REVISION}
      KEYSTORE ${KEYSTORE_FILE} ${KEYSTORE_ALIAS}
      KEYSTORE_PASSWORD ${KEYSTORE_PASSWORD}
  )
endif()

add_custom_target(
  "run"
  ${CMAKE_BINARY_DIR}/gui/compass-gui
  DEPENDS compass-gui
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/gui
)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake IMMEDIATE @ONLY
)

add_custom_target(
  "uninstall"
  ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake
)
