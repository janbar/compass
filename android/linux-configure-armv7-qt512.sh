rm -rf build-armv7/*
mkdir -p build-armv7
cd build-armv7

export JAVA_HOME=/home/jlb/bin/jdk1.8.0
export ANDROID_SDK=/home/shared/Android/Sdk
export ANDROID_NDK=/home/shared/Android/android-ndk-r17c
export ANDROID_NATIVE_API_LEVEL=21
export QT_DIR=/home/shared/Qt/5.12.9/android_armv7

cmake ../.. -DCMAKE_SYSTEM_NAME=Android \
-DCMAKE_PREFIX_PATH=$QT_DIR \
-DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
-DCMAKE_MAKE_PROGRAM=$ANDROID_NDK/prebuilt/linux-x86_64/bin/make \
-DCMAKE_BUILD_TYPE=Release \
-DANDROID_ABI="armeabi-v7a" \
-DANDROID_STL_PREFIX="llvm-libc++" \
-DANDROID_STL_SHARED_LIBRARIES="c++_shared" \
-DANDROID_NATIVE_API_LEVEL=$ANDROID_NATIVE_API_LEVEL \
-DQT_ANDROID_PLATFORM_LEVEL=$ANDROID_NATIVE_API_LEVEL \
-DQT_ANDROID_TOOL_PREFIX="arm-linux-androideabi" \
-DQT_ANDROID_SDK_ROOT=$ANDROID_SDK \
-DQT_ANDROID_NDK_ROOT=$ANDROID_NDK \
-DQT_ANDROID_QT_ROOT=$QT_DIR \
-DQT_ANDROID_SDK_BUILDTOOLS_REVISION="21.0.0" \
-DQt5Core_DIR=$QT_DIR/lib/cmake/Qt5Core \
-DQt5Gui_DIR=$QT_DIR/lib/cmake/Qt5Gui \
-DQt5Qml_DIR=$QT_DIR/lib/cmake/Qt5Qml \
-DQt5Network_DIR=$QT_DIR/lib/cmake/Qt5Network \
-DQt5Quick_DIR=$QT_DIR/lib/cmake/Qt5Quick \
-DQt5QuickControls2_DIR=$QT_DIR/lib/cmake/Qt5QuickControls2 \
-DQt5Xml_DIR=$QT_DIR/lib/cmake/Qt5Xml \
-DQt5Svg_DIR=$QT_DIR/lib/cmake/Qt5Svg \
-DQt5Widgets_DIR=$QT_DIR/lib/cmake/Qt5Widgets \
-DQt5Sensors_DIR=$QT_DIR/lib/cmake/Qt5Sensors \
-DQt5Positioning_DIR=$QT_DIR/lib/cmake/Qt5Positioning \
-DQt5AndroidExtras_DIR=$QT_DIR/lib/cmake/Qt5AndroidExtras \
$@
