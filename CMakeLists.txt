cmake_minimum_required(VERSION 3.16)

project(Dont_Forget VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Sql)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(appDont_Forget
    main.cpp
    notificationclient.cpp
    databasemanager.cpp
)

set_target_properties(appDont_Forget PROPERTIES
   QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")

qt_add_qml_module(appDont_Forget
    URI Dont_Forget
    VERSION 1.0

    QML_FILES
        Main.qml
        Home.qml
        AddReminder.qml
        Kategori.qml
        Statistik.qml
        Checklist.qml

    SOURCES
        notificationclient.h
        notificationclient.cpp
        databasemanager.h
        databasemanager.cpp
        SOURCES settingsmanager.h settingsmanager.cpp
        SOURCES notificationlaunchmanager.h notificationlaunchmanager.cpp
)

# set_target_properties(appDont_Forget PROPERTIES
#     QT_ANDROID_PACKAGE_SOURCE_DIR
#     ${CMAKE_CURRENT_SOURCE_DIR}/android

#     WIN32_EXECUTABLE TRUE

#     MACOSX_BUNDLE TRUE
#     MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
#     MACOSX_BUNDLE_SHORT_VERSION_STRING
#     ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
# )

target_link_libraries(appDont_Forget
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Sql
)

install(TARGETS appDont_Forget
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)