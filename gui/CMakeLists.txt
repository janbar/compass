cmake_minimum_required(VERSION 3.1.0)
# Automatically create moc files
set(CMAKE_AUTOMOC ON)

find_package(Qt5Core REQUIRED)
find_package(Qt5Gui REQUIRED)
find_package(Qt5Qml REQUIRED)
find_package(Qt5Network REQUIRED)
find_package(Qt5Quick REQUIRED)
find_package(Qt5QuickControls2 REQUIRED)
find_package(Qt5Widgets REQUIRED)
find_package(Qt5Xml REQUIRED)
find_package(Qt5Svg REQUIRED)
find_package(Qt5Sensors REQUIRED)
find_package(Qt5Positioning REQUIRED)
if(ANDROID)
  find_package(Qt5AndroidExtras REQUIRED)
endif()

set(CMAKE_CXX_STANDARD 11)

set(
  compass-sources
  main.cpp
  platformextras.cpp
  platformextras.h
  genericcompass.cpp
  genericcompass.h
  plugin.cpp
  plugin.h
)

if(UNIX)
  set(
    extra-sources
    signalhandler.cpp
    signalhandler.h
  )
else()
  unset(extra-sources)
endif()

add_definitions(-DAPP_VERSION="${APP_VERSION}")

qt5_add_resources(compass-resources main.qrc)

if(ANDROID)
  add_library(compass-gui SHARED ${compass-sources} ${compass-resources} ${extra-sources})
else()
  add_executable(compass-gui ${compass-sources} ${compass-resources} ${extra-sources})
endif()

if(ANDROID)
    add_definitions(-frtti) # dynamic_cast: https://github.com/android/ndk/issues/519
    target_link_libraries(compass-gui Qt5::QuickControls2 Qt5::AndroidExtras android log
                          Qt5::Qml Qt5::Quick Qt5::Widgets Qt5::Gui Qt5::Xml Qt5::Svg Qt5::Sensors Qt5::Network Qt5::Core)
else()
    target_link_libraries(compass-gui Qt5::QuickControls2
                          Qt5::Qml Qt5::Quick Qt5::Widgets Qt5::Gui Qt5::Xml Qt5::Svg Qt5::Sensors Qt5::Network Qt5::Core)
endif()

install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/compass-gui
	DESTINATION ${PLUGINS_DIR})
