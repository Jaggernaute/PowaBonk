# Use FIND_PACKAGE( Qt5 COMPONENTS ... ) to enable modules
IF( Qt5_FIND_COMPONENTS )
    FOREACH( component ${Qt5_FIND_COMPONENTS} )
        STRING( TOUPPER ${component} _COMPONENT )
        SET( QT_USE_${_COMPONENT} 1 )
    ENDFOREACH( component )

    # To make sure we don't use QtCore or QtGui when not in COMPONENTS
    IF(NOT QT_USE_QTCORE)
        SET( QT_DONT_USE_QTCORE 1 )
    ENDIF(NOT QT_USE_QTCORE)

    IF(NOT QT_USE_QTGUI)
        SET( QT_DONT_USE_QTGUI 1 )
    ENDIF(NOT QT_USE_QTGUI)

ENDIF( Qt5_FIND_COMPONENTS )

# If Qt3 has already been found, fail.
IF(QT_QT_LIBRARY)
    IF(Qt5_FIND_REQUIRED)
        MESSAGE( FATAL_ERROR "Qt4 and Qt5 cannot be used together in one project.  If switching to Qt5, the CMakeCache.txt needs to be cleaned.")
    ELSE(Qt5_FIND_REQUIRED)
        IF(NOT Qt5_FIND_QUIETLY)
            MESSAGE( STATUS    "Qt4 and Qt5 cannot be used together in one project.  If switching to Qt5, the CMakeCache.txt needs to be cleaned.")
        ENDIF(NOT Qt5_FIND_QUIETLY)
        RETURN()
    ENDIF(Qt5_FIND_REQUIRED)
ENDIF(QT_QT_LIBRARY)


INCLUDE(CheckSymbolExists)
INCLUDE(MacroAddFileDependencies)

SET(QT_USE_FILE ${CMAKE_ROOT}/Modules/UseQt5.cmake)

SET( QT_DEFINITIONS "")

# convenience macro for dealing with debug/release library names
MACRO (_QT5_ADJUST_LIB_VARS _camelCaseBasename)

    STRING(TOUPPER "${_camelCaseBasename}" basename)

    # The name of the imported targets, i.e. the prefix "Qt5::" must not change,
    # since it is stored in EXPORT-files as name of a required library. If the name would change
    # here, this would lead to the imported Qt5-library targets not being resolved by cmake anymore.
    IF (QT_${basename}_LIBRARY_RELEASE OR QT_${basename}_LIBRARY_DEBUG)

        IF(NOT TARGET Qt5::${_camelCaseBasename})
            ADD_LIBRARY(Qt5::${_camelCaseBasename} UNKNOWN IMPORTED )

            IF (QT_${basename}_LIBRARY_RELEASE)
                SET_PROPERTY(TARGET Qt5::${_camelCaseBasename} APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
                SET_PROPERTY(TARGET Qt5::${_camelCaseBasename}        PROPERTY IMPORTED_LOCATION_RELEASE "${QT_${basename}_LIBRARY_RELEASE}" )
            ENDIF (QT_${basename}_LIBRARY_RELEASE)

            IF (QT_${basename}_LIBRARY_DEBUG)
                SET_PROPERTY(TARGET Qt5::${_camelCaseBasename} APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
                SET_PROPERTY(TARGET Qt5::${_camelCaseBasename}        PROPERTY IMPORTED_LOCATION_DEBUG "${QT_${basename}_LIBRARY_DEBUG}" )
            ENDIF (QT_${basename}_LIBRARY_DEBUG)
        ENDIF(NOT TARGET Qt5::${_camelCaseBasename})

        # If QT_USE_IMPORTED_TARGETS is enabled, the QT_QTFOO_LIBRARY variables are set to point at these
        # imported targets. This works better in general, and is also in almost all cases fully
        # backward compatible. The only issue is when a project A which had this enabled then exports its
        # libraries via export or EXPORT_LIBRARY_DEPENDENCIES(). In this case the libraries from project
        # A will depend on the imported Qt targets, and the names of these imported targets will be stored
        # in the dependency files on disk. This means when a project B then uses project A, these imported
        # targets must be created again, otherwise e.g. "Qt5__QtCore" will be interpreted as name of a
        # library file on disk, and not as a target, and linking will fail:
        IF(QT_USE_IMPORTED_TARGETS)
            SET(QT_${basename}_LIBRARY       Qt5::${_camelCaseBasename} )
            SET(QT_${basename}_LIBRARIES     Qt5::${_camelCaseBasename} )
        ELSE(QT_USE_IMPORTED_TARGETS)

            # if the release- as well as the debug-version of the library have been found:
            IF (QT_${basename}_LIBRARY_DEBUG AND QT_${basename}_LIBRARY_RELEASE)
                # if the generator supports configuration types then set
                # optimized and debug libraries, or if the CMAKE_BUILD_TYPE has a value
                IF (CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE)
                    SET(QT_${basename}_LIBRARY       optimized ${QT_${basename}_LIBRARY_RELEASE} debug ${QT_${basename}_LIBRARY_DEBUG})
                ELSE(CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE)
                    # if there are no configuration types and CMAKE_BUILD_TYPE has no value
                    # then just use the release libraries
                    SET(QT_${basename}_LIBRARY       ${QT_${basename}_LIBRARY_RELEASE} )
                ENDIF(CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE)
                SET(QT_${basename}_LIBRARIES       optimized ${QT_${basename}_LIBRARY_RELEASE} debug ${QT_${basename}_LIBRARY_DEBUG})
            ENDIF (QT_${basename}_LIBRARY_DEBUG AND QT_${basename}_LIBRARY_RELEASE)

            # if only the release version was found, set the debug variable also to the release version
            IF (QT_${basename}_LIBRARY_RELEASE AND NOT QT_${basename}_LIBRARY_DEBUG)
                SET(QT_${basename}_LIBRARY_DEBUG ${QT_${basename}_LIBRARY_RELEASE})
                SET(QT_${basename}_LIBRARY       ${QT_${basename}_LIBRARY_RELEASE})
                SET(QT_${basename}_LIBRARIES     ${QT_${basename}_LIBRARY_RELEASE})
            ENDIF (QT_${basename}_LIBRARY_RELEASE AND NOT QT_${basename}_LIBRARY_DEBUG)

            # if only the debug version was found, set the release variable also to the debug version
            IF (QT_${basename}_LIBRARY_DEBUG AND NOT QT_${basename}_LIBRARY_RELEASE)
                SET(QT_${basename}_LIBRARY_RELEASE ${QT_${basename}_LIBRARY_DEBUG})
                SET(QT_${basename}_LIBRARY         ${QT_${basename}_LIBRARY_DEBUG})
                SET(QT_${basename}_LIBRARIES       ${QT_${basename}_LIBRARY_DEBUG})
            ENDIF (QT_${basename}_LIBRARY_DEBUG AND NOT QT_${basename}_LIBRARY_RELEASE)

            # put the value in the cache:
            SET(QT_${basename}_LIBRARY ${QT_${basename}_LIBRARY} CACHE STRING "The Qt ${basename} library" FORCE)

        ENDIF(QT_USE_IMPORTED_TARGETS)

        SET(QT_${basename}_FOUND 1)

    ELSE (QT_${basename}_LIBRARY_RELEASE OR QT_${basename}_LIBRARY_DEBUG)

        SET(QT_${basename}_LIBRARY "" CACHE STRING "The Qt ${basename} library" FORCE)

    ENDIF (QT_${basename}_LIBRARY_RELEASE OR QT_${basename}_LIBRARY_DEBUG)

    IF (QT_${basename}_INCLUDE_DIR)
        #add the include directory to QT_INCLUDES
        SET(QT_INCLUDES "${QT_${basename}_INCLUDE_DIR}" ${QT_INCLUDES})
    ENDIF (QT_${basename}_INCLUDE_DIR)

    # Make variables changeble to the advanced user
    MARK_AS_ADVANCED(QT_${basename}_LIBRARY QT_${basename}_LIBRARY_RELEASE QT_${basename}_LIBRARY_DEBUG QT_${basename}_INCLUDE_DIR)
ENDMACRO (_QT5_ADJUST_LIB_VARS)

function(_QT5_QUERY_QMAKE VAR RESULT)
    exec_program(${QT_QMAKE_EXECUTABLE} ARGS "-query ${VAR}" RETURN_VALUE return_code OUTPUT_VARIABLE output )
    if(NOT return_code)
        file(TO_CMAKE_PATH "${output}" output)
        set(${RESULT} ${output} PARENT_SCOPE)
    endif(NOT return_code)
endfunction(_QT5_QUERY_QMAKE)


SET(QT5_INSTALLED_VERSION_TOO_OLD FALSE)

GET_FILENAME_COMPONENT(qt_install_version "[HKEY_CURRENT_USER\\Software\\trolltech\\Versions;DefaultQtVersion]" NAME)
# check for qmake
# Debian uses qmake-qt5
# macports' Qt uses qmake-mac
FIND_PROGRAM(QT_QMAKE_EXECUTABLE NAMES qmake qmake5 qmake-qt5 qmake-mac PATHS
        "[HKEY_CURRENT_USER\\Software\\Trolltech\\Qt5Versions\\5.0.0;InstallDir]/bin"
        "[HKEY_CURRENT_USER\\Software\\Trolltech\\Versions\\5.0.0;InstallDir]/bin"
        "[HKEY_CURRENT_USER\\Software\\Trolltech\\Versions\\${qt_install_version};InstallDir]/bin"
        $ENV{QTDIR}/bin
        DOC "The qmake executable for the Qt installation to use"
        )

IF (QT_QMAKE_EXECUTABLE)

    IF(QT_QMAKE_EXECUTABLE_LAST)
        STRING(COMPARE NOTEQUAL "${QT_QMAKE_EXECUTABLE_LAST}" "${QT_QMAKE_EXECUTABLE}" QT_QMAKE_CHANGED)
    ENDIF(QT_QMAKE_EXECUTABLE_LAST)

    SET(QT_QMAKE_EXECUTABLE_LAST "${QT_QMAKE_EXECUTABLE}" CACHE INTERNAL "" FORCE)

    SET(QT5_QMAKE_FOUND FALSE)

    _qt5_query_qmake(QT_VERSION QTVERSION)

    # check for qt3 qmake and then try and find qmake5 or qmake-qt5 in the path
    IF("${QTVERSION}" MATCHES "Unknown")
        SET(QT_QMAKE_EXECUTABLE NOTFOUND CACHE FILEPATH "" FORCE)
        FIND_PROGRAM(QT_QMAKE_EXECUTABLE NAMES qmake5 qmake-qt5 PATHS
                "[HKEY_CURRENT_USER\\Software\\Trolltech\\Qt3Versions\\5.0.0;InstallDir]/bin"
                "[HKEY_CURRENT_USER\\Software\\Trolltech\\Versions\\5.0.0;InstallDir]/bin"
                $ENV{QTDIR}/bin
                DOC "The qmake executable for the Qt installation to use"
                )
        IF(QT_QMAKE_EXECUTABLE)
            _qt5_query_qmake(QT_VERSION QTVERSION)
        ENDIF(QT_QMAKE_EXECUTABLE)
    ENDIF("${QTVERSION}" MATCHES "Unknown")

    # check that we found the Qt5 qmake, Qt3 qmake output won't match here
    STRING(REGEX MATCH "^[0-9]+\\.[0-9]+\\.[0-9]+" qt_version_tmp "${QTVERSION}")
    IF (qt_version_tmp)

        # we need at least version 5.0.0
        IF (NOT QT_MIN_VERSION)
            SET(QT_MIN_VERSION "5.0.0")
        ENDIF (NOT QT_MIN_VERSION)

        #now parse the parts of the user given version string into variables
        STRING(REGEX MATCH "^[0-9]+\\.[0-9]+\\.[0-9]+" req_qt_major_vers "${QT_MIN_VERSION}")
        IF (NOT req_qt_major_vers)
            MESSAGE( FATAL_ERROR "Invalid Qt version string given: \"${QT_MIN_VERSION}\", expected e.g. \"5.0.1\"")
        ENDIF (NOT req_qt_major_vers)

        # now parse the parts of the user given version string into variables
        STRING(REGEX REPLACE "^([0-9]+)\\.[0-9]+\\.[0-9]+" "\\1" req_qt_major_vers "${QT_MIN_VERSION}")
        STRING(REGEX REPLACE "^[0-9]+\\.([0-9])+\\.[0-9]+" "\\1" req_qt_minor_vers "${QT_MIN_VERSION}")
        STRING(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+)" "\\1" req_qt_patch_vers "${QT_MIN_VERSION}")

        # Suppport finding at least a particular version, for instance FIND_PACKAGE( Qt5 5.5.3 )
        # This implementation is a hack to avoid duplicating code and make sure we stay
        # source-compatible with CMake 2.6.x
        IF( Qt5_FIND_VERSION )
            SET( QT_MIN_VERSION ${Qt5_FIND_VERSION} )
            SET( req_qt_major_vers ${Qt5_FIND_VERSION_MAJOR} )
            SET( req_qt_minor_vers ${Qt5_FIND_VERSION_MINOR} )
            SET( req_qt_patch_vers ${Qt5_FIND_VERSION_PATCH} )
        ENDIF( Qt5_FIND_VERSION )

        IF (NOT req_qt_major_vers EQUAL 5)
            MESSAGE( FATAL_ERROR "Invalid Qt version string given: \"${QT_MIN_VERSION}\", major version 5 is required, e.g. \"5.0.1\"")
        ENDIF (NOT req_qt_major_vers EQUAL 5)

        # and now the version string given by qmake
        STRING(REGEX REPLACE "^([0-9]+)\\.[0-9]+\\.[0-9]+.*" "\\1" QT_VERSION_MAJOR "${QTVERSION}")
        STRING(REGEX REPLACE "^[0-9]+\\.([0-9])+\\.[0-9]+.*" "\\1" QT_VERSION_MINOR "${QTVERSION}")
        STRING(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" QT_VERSION_PATCH "${QTVERSION}")

        # compute an overall version number which can be compared at once
        MATH(EXPR req_vers "${req_qt_major_vers}*10000 + ${req_qt_minor_vers}*100 + ${req_qt_patch_vers}")
        MATH(EXPR found_vers "${QT_VERSION_MAJOR}*10000 + ${QT_VERSION_MINOR}*100 + ${QT_VERSION_PATCH}")

        # Support finding *exactly* a particular version, for instance FIND_PACKAGE( Qt5 5.5.3 EXACT )
        IF( Qt5_FIND_VERSION_EXACT )
            IF(found_vers EQUAL req_vers)
                SET( QT5_QMAKE_FOUND TRUE )
            ELSE(found_vers EQUAL req_vers)
                SET( QT5_QMAKE_FOUND FALSE )
                IF (found_vers LESS req_vers)
                    SET(QT5_INSTALLED_VERSION_TOO_OLD TRUE)
                ELSE (found_vers LESS req_vers)
                    SET(QT5_INSTALLED_VERSION_TOO_NEW TRUE)
                ENDIF (found_vers LESS req_vers)
            ENDIF(found_vers EQUAL req_vers)
        ELSE( Qt5_FIND_VERSION_EXACT )
            IF (found_vers LESS req_vers)
                SET(QT5_QMAKE_FOUND FALSE)
                SET(QT5_INSTALLED_VERSION_TOO_OLD TRUE)
            ELSE (found_vers LESS req_vers)
                SET(QT5_QMAKE_FOUND TRUE)
            ENDIF (found_vers LESS req_vers)
        ENDIF( Qt5_FIND_VERSION_EXACT )
    ENDIF (qt_version_tmp)

ENDIF (QT_QMAKE_EXECUTABLE)

IF (QT5_QMAKE_FOUND)

    # ask qmake for the mkspecs directory
    # we do this first because QT_LIBINFIX might be set
    IF (NOT QT_MKSPECS_DIR  OR  QT_QMAKE_CHANGED)
        _qt5_query_qmake(QMAKE_MKSPECS qt_mkspecs_dirs)
        # do not replace : on windows as it might be a drive letter
        # and windows should already use ; as a separator
        IF(NOT WIN32)
            STRING(REPLACE ":" ";" qt_mkspecs_dirs "${qt_mkspecs_dirs}")
        ENDIF(NOT WIN32)
        set(qt_cross_paths)
        foreach(qt_cross_path ${CMAKE_FIND_ROOT_PATH})
            set(qt_cross_paths ${qt_cross_paths} "${qt_cross_path}/mkspecs")
        endforeach(qt_cross_path)
        SET(QT_MKSPECS_DIR NOTFOUND)
        FIND_PATH(QT_MKSPECS_DIR NAMES qconfig.pri
                HINTS ${qt_cross_paths} ${qt_mkspecs_dirs}
                DOC "The location of the Qt mkspecs containing qconfig.pri")
    ENDIF()

    IF(EXISTS "${QT_MKSPECS_DIR}/qconfig.pri")
        FILE(READ ${QT_MKSPECS_DIR}/qconfig.pri _qconfig_FILE_contents)
        STRING(REGEX MATCH "QT_CONFIG[^\n]+" QT_QCONFIG "${_qconfig_FILE_contents}")
        STRING(REGEX MATCH "CONFIG[^\n]+" QT_CONFIG "${_qconfig_FILE_contents}")
        STRING(REGEX MATCH "EDITION[^\n]+" QT_EDITION "${_qconfig_FILE_contents}")
        STRING(REGEX MATCH "QT_LIBINFIX[^\n]+" _qconfig_qt_libinfix "${_qconfig_FILE_contents}")
        STRING(REGEX REPLACE "QT_LIBINFIX *= *([^\n]*)" "\\1" QT_LIBINFIX "${_qconfig_qt_libinfix}")
    ENDIF(EXISTS "${QT_MKSPECS_DIR}/qconfig.pri")
    IF("${QT_EDITION}" MATCHES "DesktopLight")
        SET(QT_EDITION_DESKTOPLIGHT 1)
    ENDIF("${QT_EDITION}" MATCHES "DesktopLight")

    # ask qmake for the library dir as a hint, then search for QtCore library and use that as a reference for finding the
    # others and for setting QT_LIBRARY_DIR
    IF (NOT QT_QTCORE_LIBRARY OR QT_QMAKE_CHANGED)
        _qt5_query_qmake(QT_INSTALL_LIBS QT_LIBRARY_DIR_TMP)
        SET(QT_QTCORE_LIBRARY_RELEASE NOTFOUND)
        SET(QT_QTCORE_LIBRARY_DEBUG NOTFOUND)
        FIND_LIBRARY(QT_QTCORE_LIBRARY_RELEASE
                NAMES QtCore${QT_LIBINFIX} QtCore${QT_LIBINFIX}5
                HINTS ${QT_LIBRARY_DIR_TMP}
                NO_CMAKE_PATH NO_CMAKE_ENVIRONMENT_PATH NO_SYSTEM_ENVIRONMENT_PATH
                )
        FIND_LIBRARY(QT_QTCORE_LIBRARY_DEBUG
                NAMES QtCore${QT_LIBINFIX}_debug QtCore${QT_LIBINFIX}d QtCore${QT_LIBINFIX}d5
                HINTS ${QT_LIBRARY_DIR_TMP}
                NO_CMAKE_PATH NO_CMAKE_ENVIRONMENT_PATH NO_SYSTEM_ENVIRONMENT_PATH
                )

        # try dropping a hint if trying to use Visual Studio with Qt built by mingw
        IF(NOT QT_QTCORE_LIBRARY_RELEASE AND MSVC)
            IF(EXISTS ${QT_LIBRARY_DIR_TMP}/libqtmain.a)
                MESSAGE( FATAL_ERROR "It appears you're trying to use Visual Studio with Qt built by mingw.  Those compilers do not produce code compatible with each other.")
            ENDIF(EXISTS ${QT_LIBRARY_DIR_TMP}/libqtmain.a)
        ENDIF(NOT QT_QTCORE_LIBRARY_RELEASE AND MSVC)

    ENDIF (NOT QT_QTCORE_LIBRARY OR QT_QMAKE_CHANGED)

    _QT5_ADJUST_LIB_VARS(QtCore)

    # set QT_LIBRARY_DIR based on location of QtCore found.
    IF(QT_QTCORE_LIBRARY_RELEASE)
        GET_FILENAME_COMPONENT(QT_LIBRARY_DIR_TMP "${QT_QTCORE_LIBRARY_RELEASE}" PATH)
        SET(QT_LIBRARY_DIR ${QT_LIBRARY_DIR_TMP} CACHE INTERNAL "Qt library dir" FORCE)
        SET(QT_QTCORE_FOUND 1)
    ELSEIF(QT_QTCORE_LIBRARY_DEBUG)
        GET_FILENAME_COMPONENT(QT_LIBRARY_DIR_TMP "${QT_QTCORE_LIBRARY_DEBUG}" PATH)
        SET(QT_LIBRARY_DIR ${QT_LIBRARY_DIR_TMP} CACHE INTERNAL "Qt library dir" FORCE)
        SET(QT_QTCORE_FOUND 1)
    ELSE()
        MESSAGE("Warning: QT_QMAKE_EXECUTABLE reported QT_INSTALL_LIBS as ${QT_LIBRARY_DIR_TMP}")
        MESSAGE("Warning: But QtCore couldn't be found.  Qt must NOT be installed correctly, or it wasn't found for cross compiling.")
        IF(Qt5_FIND_REQUIRED)
            MESSAGE( FATAL_ERROR "Could NOT find QtCore. Check ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log for more details.")
        ENDIF(Qt5_FIND_REQUIRED)
    ENDIF()

    IF (APPLE)
        IF (EXISTS ${QT_LIBRARY_DIR}/QtCore.framework)
            SET(QT_USE_FRAMEWORKS ON CACHE INTERNAL "" FORCE)
        ELSE (EXISTS ${QT_LIBRARY_DIR}/QtCore.framework)
            SET(QT_USE_FRAMEWORKS OFF CACHE INTERNAL "" FORCE)
        ENDIF (EXISTS ${QT_LIBRARY_DIR}/QtCore.framework)
        MARK_AS_ADVANCED(QT_USE_FRAMEWORKS)
    ENDIF (APPLE)

    # ask qmake for the binary dir
    IF (NOT QT_BINARY_DIR  OR  QT_QMAKE_CHANGED)
        _qt5_query_qmake(QT_INSTALL_BINS qt_bins)
        SET(QT_BINARY_DIR ${qt_bins} CACHE INTERNAL "" FORCE)
    ENDIF (NOT QT_BINARY_DIR  OR  QT_QMAKE_CHANGED)

    # ask qmake for the include dir
    IF (QT_LIBRARY_DIR AND (NOT QT_QTCORE_INCLUDE_DIR OR NOT QT_HEADERS_DIR OR  QT_QMAKE_CHANGED))
        _qt5_query_qmake(QT_INSTALL_HEADERS qt_headers)
        SET(QT_QTCORE_INCLUDE_DIR NOTFOUND)
        FIND_PATH(QT_QTCORE_INCLUDE_DIR QtCore
                HINTS ${qt_headers}
                ${QT_LIBRARY_DIR}/QtCore.framework/Headers
                PATH_SUFFIXES QtCore
                )

        # Set QT_HEADERS_DIR based on finding QtCore header
        IF(QT_QTCORE_INCLUDE_DIR)
            IF(QT_USE_FRAMEWORKS)
                SET(QT_HEADERS_DIR "${qt_headers}" CACHE INTERNAL "" FORCE)
            ELSE(QT_USE_FRAMEWORKS)
                GET_FILENAME_COMPONENT(qt_headers "${QT_QTCORE_INCLUDE_DIR}/../" ABSOLUTE)
                SET(QT_HEADERS_DIR "${qt_headers}" CACHE INTERNAL "" FORCE)
            ENDIF(QT_USE_FRAMEWORKS)
        ELSEIF()
            MESSAGE("Warning: QT_QMAKE_EXECUTABLE reported QT_INSTALL_HEADERS as ${qt_headers}")
            MESSAGE("Warning: But QtCore couldn't be found.  Qt must NOT be installed correctly.")
        ENDIF()
    ENDIF()

    # Set QT_INCLUDE_DIR based on QT_HEADERS_DIR
    IF(QT_HEADERS_DIR)
        IF(QT_USE_FRAMEWORKS)
            # Qt/Mac frameworks has two include dirs.
            # One is the framework include for which CMake will add a -F flag
            # and the other is an include dir for non-framework Qt modules
            SET(QT_INCLUDE_DIR ${QT_HEADERS_DIR} ${QT_QTCORE_LIBRARY} )
        ELSE(QT_USE_FRAMEWORKS)
            SET(QT_INCLUDE_DIR ${QT_HEADERS_DIR})
        ENDIF(QT_USE_FRAMEWORKS)
    ENDIF(QT_HEADERS_DIR)

    # Set QT_INCLUDES
    SET( QT_INCLUDES ${QT_MKSPECS_DIR}/default ${QT_INCLUDE_DIR} ${QT_QTCORE_INCLUDE_DIR})


    # ask qmake for the documentation directory
    IF (QT_LIBRARY_DIR AND NOT QT_DOC_DIR  OR  QT_QMAKE_CHANGED)
        _qt5_query_qmake(QT_INSTALL_DOCS qt_doc_dir)
        SET(QT_DOC_DIR ${qt_doc_dir} CACHE PATH "The location of the Qt docs" FORCE)
    ENDIF (QT_LIBRARY_DIR AND NOT QT_DOC_DIR  OR  QT_QMAKE_CHANGED)


    # ask qmake for the plugins directory
    IF (QT_LIBRARY_DIR AND NOT QT_PLUGINS_DIR  OR  QT_QMAKE_CHANGED)
        _qt5_query_qmake(QT_INSTALL_PLUGINS qt_plugins_dir)
        SET(QT_PLUGINS_DIR NOTFOUND)
        foreach(qt_cross_path ${CMAKE_FIND_ROOT_PATH})
            set(qt_cross_paths ${qt_cross_paths} "${qt_cross_path}/plugins")
        endforeach(qt_cross_path)
        FIND_PATH(QT_PLUGINS_DIR NAMES accessible imageformats sqldrivers codecs designer
                HINTS ${qt_cross_paths} ${qt_plugins_dir}
                DOC "The location of the Qt plugins")
    ENDIF (QT_LIBRARY_DIR AND NOT QT_PLUGINS_DIR  OR  QT_QMAKE_CHANGED)

    # ask qmake for the translations directory
    IF (QT_LIBRARY_DIR AND NOT QT_TRANSLATIONS_DIR  OR  QT_QMAKE_CHANGED)
        _qt5_query_qmake(QT_INSTALL_TRANSLATIONS qt_translations_dir)
        SET(QT_TRANSLATIONS_DIR ${qt_translations_dir} CACHE PATH "The location of the Qt translations" FORCE)
    ENDIF (QT_LIBRARY_DIR AND NOT QT_TRANSLATIONS_DIR  OR  QT_QMAKE_CHANGED)

    # ask qmake for the imports directory
    IF (QT_LIBRARY_DIR AND NOT QT_IMPORTS_DIR OR QT_QMAKE_CHANGED)
        _qt5_query_qmake(QT_INSTALL_IMPORTS qt_imports_dir)
        if(qt_imports_dir)
            SET(QT_IMPORTS_DIR NOTFOUND)
            foreach(qt_cross_path ${CMAKE_FIND_ROOT_PATH})
                set(qt_cross_paths ${qt_cross_paths} "${qt_cross_path}/imports")
            endforeach(qt_cross_path)
            FIND_PATH(QT_IMPORTS_DIR NAMES Qt
                    HINTS ${qt_cross_paths} ${qt_imports_dir}
                    DOC "The location of the Qt imports"
                    NO_CMAKE_PATH NO_CMAKE_ENVIRONMENT_PATH NO_SYSTEM_ENVIRONMENT_PATH
                    NO_CMAKE_SYSTEM_PATH)
            mark_as_advanced(QT_IMPORTS_DIR)
        endif(qt_imports_dir)
    ENDIF (QT_LIBRARY_DIR AND NOT QT_IMPORTS_DIR  OR  QT_QMAKE_CHANGED)

    # Make variables changeble to the advanced user
    MARK_AS_ADVANCED( QT_LIBRARY_DIR QT_DOC_DIR QT_MKSPECS_DIR
            QT_PLUGINS_DIR QT_TRANSLATIONS_DIR)




    #############################################
    #
    # Find out what window system we're using
    #
    #############################################
    # Save required variable
    SET(CMAKE_REQUIRED_INCLUDES_SAVE ${CMAKE_REQUIRED_INCLUDES})
    SET(CMAKE_REQUIRED_FLAGS_SAVE    ${CMAKE_REQUIRED_FLAGS})
    # Add QT_INCLUDE_DIR to CMAKE_REQUIRED_INCLUDES
    SET(CMAKE_REQUIRED_INCLUDES "${CMAKE_REQUIRED_INCLUDES};${QT_INCLUDE_DIR}")
    # Check for Window system symbols (note: only one should end up being set)
    CHECK_SYMBOL_EXISTS(Q_WS_X11 "QtCore/qglobal.h" Q_WS_X11)
    CHECK_SYMBOL_EXISTS(Q_WS_WIN "QtCore/qglobal.h" Q_WS_WIN)
    CHECK_SYMBOL_EXISTS(Q_WS_QWS "QtCore/qglobal.h" Q_WS_QWS)
    CHECK_SYMBOL_EXISTS(Q_WS_MAC "QtCore/qglobal.h" Q_WS_MAC)
    IF(Q_WS_MAC)
        IF(QT_QMAKE_CHANGED)
            UNSET(QT_MAC_USE_COCOA CACHE)
        ENDIF(QT_QMAKE_CHANGED)
        CHECK_SYMBOL_EXISTS(QT_MAC_USE_COCOA "QtCore/qconfig.h" QT_MAC_USE_COCOA)
    ENDIF(Q_WS_MAC)

    IF (QT_QTCOPY_REQUIRED)
        CHECK_SYMBOL_EXISTS(QT_IS_QTCOPY "QtCore/qglobal.h" QT_KDE_QT_COPY)
        IF (NOT QT_IS_QTCOPY)
            MESSAGE(FATAL_ERROR "qt-copy is required, but hasn't been found")
        ENDIF (NOT QT_IS_QTCOPY)
    ENDIF (QT_QTCOPY_REQUIRED)

    # Restore CMAKE_REQUIRED_INCLUDES and CMAKE_REQUIRED_FLAGS variables
    SET(CMAKE_REQUIRED_INCLUDES ${CMAKE_REQUIRED_INCLUDES_SAVE})
    SET(CMAKE_REQUIRED_FLAGS    ${CMAKE_REQUIRED_FLAGS_SAVE})
    #
    #############################################



    ########################################
    #
    #       Setting the INCLUDE-Variables
    #
    ########################################

    SET(QT_MODULES QtGui Qt3Support QtSvg QtScript QtTest QtUiTools
            QtHelp QtWebKit QtXmlPatterns phonon QtNetwork QtMultimedia
            QtNsPlugin QtOpenGL QtSql QtXml QtDesigner QtDBus QtScriptTools
            QtDeclarative)

    IF(Q_WS_X11)
        SET(QT_MODULES ${QT_MODULES} QtMotif)
    ENDIF(Q_WS_X11)

    IF(QT_QMAKE_CHANGED)
        FOREACH(QT_MODULE ${QT_MODULES})
            STRING(TOUPPER ${QT_MODULE} _upper_qt_module)
            SET(QT_${_upper_qt_module}_INCLUDE_DIR NOTFOUND)
            SET(QT_${_upper_qt_module}_LIBRARY_RELEASE NOTFOUND)
            SET(QT_${_upper_qt_module}_LIBRARY_DEBUG NOTFOUND)
        ENDFOREACH(QT_MODULE)
        SET(QT_QTDESIGNERCOMPONENTS_INCLUDE_DIR NOTFOUND)
        SET(QT_QTDESIGNERCOMPONENTS_LIBRARY_RELEASE NOTFOUND)
        SET(QT_QTDESIGNERCOMPONENTS_LIBRARY_DEBUG NOTFOUND)
        SET(QT_QTASSISTANTCLIENT_INCLUDE_DIR NOTFOUND)
        SET(QT_QTASSISTANTCLIENT_LIBRARY_RELEASE NOTFOUND)
        SET(QT_QTASSISTANTCLIENT_LIBRARY_DEBUG NOTFOUND)
        SET(QT_QTASSISTANT_INCLUDE_DIR NOTFOUND)
        SET(QT_QTASSISTANT_LIBRARY_RELEASE NOTFOUND)
        SET(QT_QTASSISTANT_LIBRARY_DEBUG NOTFOUND)
        SET(QT_QTCLUCENE_LIBRARY_RELEASE NOTFOUND)
        SET(QT_QTCLUCENE_LIBRARY_DEBUG NOTFOUND)
        SET(QT_QAXCONTAINER_INCLUDE_DIR NOTFOUND)
        SET(QT_QAXCONTAINER_LIBRARY_RELEASE NOTFOUND)
        SET(QT_QAXCONTAINER_LIBRARY_DEBUG NOTFOUND)
        SET(QT_QAXSERVER_INCLUDE_DIR NOTFOUND)
        SET(QT_QAXSERVER_LIBRARY_RELEASE NOTFOUND)
        SET(QT_QAXSERVER_LIBRARY_DEBUG NOTFOUND)
        IF(Q_WS_WIN)
            SET(QT_QTMAIN_LIBRARY_DEBUG NOTFOUND)
            SET(QT_QTMAIN_LIBRARY_RELEASE NOTFOUND)
        ENDIF(Q_WS_WIN)
    ENDIF(QT_QMAKE_CHANGED)

    FOREACH(QT_MODULE ${QT_MODULES})
        STRING(TOUPPER ${QT_MODULE} _upper_qt_module)
        FIND_PATH(QT_${_upper_qt_module}_INCLUDE_DIR ${QT_MODULE}
                PATHS
                ${QT_HEADERS_DIR}/${QT_MODULE}
                ${QT_LIBRARY_DIR}/${QT_MODULE}.framework/Headers
                NO_DEFAULT_PATH
                )
        # phonon doesn't seem consistent, let's try phonondefs.h for some
        # installations
        IF(${QT_MODULE} STREQUAL "phonon")
            FIND_PATH(QT_${_upper_qt_module}_INCLUDE_DIR phonondefs.h
                    PATHS
                    ${QT_HEADERS_DIR}/${QT_MODULE}
                    ${QT_LIBRARY_DIR}/${QT_MODULE}.framework/Headers
                    NO_DEFAULT_PATH
                    )
        ENDIF(${QT_MODULE} STREQUAL "phonon")
    ENDFOREACH(QT_MODULE)

    IF(Q_WS_WIN)
        SET(QT_MODULES ${QT_MODULES} QAxContainer QAxServer)
        # Set QT_AXCONTAINER_INCLUDE_DIR and QT_AXSERVER_INCLUDE_DIR
        FIND_PATH(QT_QAXCONTAINER_INCLUDE_DIR ActiveQt
                PATHS ${QT_HEADERS_DIR}/ActiveQt
                NO_DEFAULT_PATH
                )
        FIND_PATH(QT_QAXSERVER_INCLUDE_DIR ActiveQt
                PATHS ${QT_HEADERS_DIR}/ActiveQt
                NO_DEFAULT_PATH
                )
    ENDIF(Q_WS_WIN)

    # Set QT_QTDESIGNERCOMPONENTS_INCLUDE_DIR
    FIND_PATH(QT_QTDESIGNERCOMPONENTS_INCLUDE_DIR QDesignerComponents
            PATHS
            ${QT_HEADERS_DIR}/QtDesigner
            ${QT_LIBRARY_DIR}/QtDesigner.framework/Headers
            NO_DEFAULT_PATH
            )

    # Set QT_QTASSISTANT_INCLUDE_DIR
    FIND_PATH(QT_QTASSISTANT_INCLUDE_DIR QtAssistant
            PATHS
            ${QT_HEADERS_DIR}/QtAssistant
            ${QT_LIBRARY_DIR}/QtAssistant.framework/Headers
            NO_DEFAULT_PATH
            )

    # Set QT_QTASSISTANTCLIENT_INCLUDE_DIR
    FIND_PATH(QT_QTASSISTANTCLIENT_INCLUDE_DIR QAssistantClient
            PATHS
            ${QT_HEADERS_DIR}/QtAssistant
            ${QT_LIBRARY_DIR}/QtAssistant.framework/Headers
            NO_DEFAULT_PATH
            )

    ########################################
    #
    #       Setting the LIBRARY-Variables
    #
    ########################################

    # find the libraries
    FOREACH(QT_MODULE ${QT_MODULES})
        STRING(TOUPPER ${QT_MODULE} _upper_qt_module)
        FIND_LIBRARY(QT_${_upper_qt_module}_LIBRARY_RELEASE
                NAMES ${QT_MODULE}${QT_LIBINFIX} ${QT_MODULE}${QT_LIBINFIX}5
                PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH
                )
        FIND_LIBRARY(QT_${_upper_qt_module}_LIBRARY_DEBUG
                NAMES ${QT_MODULE}${QT_LIBINFIX}_debug ${QT_MODULE}${QT_LIBINFIX}d ${QT_MODULE}${QT_LIBINFIX}d5
                PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH
                )
    ENDFOREACH(QT_MODULE)

    # QtUiTools not with other frameworks with binary installation (in /usr/lib)
    IF(Q_WS_MAC AND QT_QTCORE_LIBRARY_RELEASE AND NOT QT_QTUITOOLS_LIBRARY_RELEASE)
        FIND_LIBRARY(QT_QTUITOOLS_LIBRARY_RELEASE NAMES QtUiTools${QT_LIBINFIX} PATHS ${QT_LIBRARY_DIR})
    ENDIF(Q_WS_MAC AND QT_QTCORE_LIBRARY_RELEASE AND NOT QT_QTUITOOLS_LIBRARY_RELEASE)

    # Set QT_QTDESIGNERCOMPONENTS_LIBRARY
    FIND_LIBRARY(QT_QTDESIGNERCOMPONENTS_LIBRARY_RELEASE NAMES QtDesignerComponents${QT_LIBINFIX} QtDesignerComponents${QT_LIBINFIX}5 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
    FIND_LIBRARY(QT_QTDESIGNERCOMPONENTS_LIBRARY_DEBUG   NAMES QtDesignerComponents${QT_LIBINFIX}_debug QtDesignerComponents${QT_LIBINFIX}d QtDesignerComponents${QT_LIBINFIX}d5 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    # Set QT_QTMAIN_LIBRARY
    IF(Q_WS_WIN)
        FIND_LIBRARY(QT_QTMAIN_LIBRARY_RELEASE NAMES qtmain${QT_LIBINFIX} PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
        FIND_LIBRARY(QT_QTMAIN_LIBRARY_DEBUG NAMES qtmain${QT_LIBINFIX}d PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
    ENDIF(Q_WS_WIN)

    # Set QT_QTASSISTANTCLIENT_LIBRARY
    FIND_LIBRARY(QT_QTASSISTANTCLIENT_LIBRARY_RELEASE NAMES QtAssistantClient${QT_LIBINFIX} QtAssistantClient${QT_LIBINFIX}5 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
    FIND_LIBRARY(QT_QTASSISTANTCLIENT_LIBRARY_DEBUG   NAMES QtAssistantClient${QT_LIBINFIX}_debug QtAssistantClient${QT_LIBINFIX}d QtAssistantClient${QT_LIBINFIX}d5 PATHS ${QT_LIBRARY_DIR}  NO_DEFAULT_PATH)

    # Set QT_QTASSISTANT_LIBRARY
    FIND_LIBRARY(QT_QTASSISTANT_LIBRARY_RELEASE NAMES QtAssistantClient${QT_LIBINFIX} QtAssistantClient${QT_LIBINFIX}5 QtAssistant${QT_LIBINFIX} QtAssistant${QT_LIBINFIX}5 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
    FIND_LIBRARY(QT_QTASSISTANT_LIBRARY_DEBUG   NAMES QtAssistantClient${QT_LIBINFIX}_debug QtAssistantClient${QT_LIBINFIX}d QtAssistantClient${QT_LIBINFIX}d5 QtAssistant${QT_LIBINFIX}_debug QtAssistant${QT_LIBINFIX}d5 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    # Set QT_QTHELP_LIBRARY
    FIND_LIBRARY(QT_QTCLUCENE_LIBRARY_RELEASE NAMES QtCLucene${QT_LIBINFIX} QtCLucene${QT_LIBINFIX}5 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
    FIND_LIBRARY(QT_QTCLUCENE_LIBRARY_DEBUG   NAMES QtCLucene${QT_LIBINFIX}_debug QtCLucene${QT_LIBINFIX}d QtCLucene${QT_LIBINFIX}d5 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
    IF(Q_WS_MAC AND QT_QTCORE_LIBRARY_RELEASE AND NOT QT_QTCLUCENE_LIBRARY_RELEASE)
        FIND_LIBRARY(QT_QTCLUCENE_LIBRARY_RELEASE NAMES QtCLucene${QT_LIBINFIX} PATHS ${QT_LIBRARY_DIR})
    ENDIF(Q_WS_MAC AND QT_QTCORE_LIBRARY_RELEASE AND NOT QT_QTCLUCENE_LIBRARY_RELEASE)


    ############################################
    #
    # Check the existence of the libraries.
    #
    ############################################

    # On OSX when Qt is found as framework, never use the imported targets for now, since
    # in this case the handling of the framework directory currently does not work correctly.
    IF(QT_USE_FRAMEWORKS)
        SET(QT_USE_IMPORTED_TARGETS FALSE)
    ENDIF(QT_USE_FRAMEWORKS)


    # Set QT_xyz_LIBRARY variable and add
    # library include path to QT_INCLUDES
    FOREACH(QT_MODULE ${QT_MODULES})
        _QT5_ADJUST_LIB_VARS(${QT_MODULE})
    ENDFOREACH(QT_MODULE)

    _QT5_ADJUST_LIB_VARS(QtAssistant)
    _QT5_ADJUST_LIB_VARS(QtAssistantClient)
    _QT5_ADJUST_LIB_VARS(QtCLucene)
    _QT5_ADJUST_LIB_VARS(QtDesignerComponents)

    # platform dependent libraries
    IF(Q_WS_WIN)
        _QT5_ADJUST_LIB_VARS(qtmain)
        _QT5_ADJUST_LIB_VARS(QAxServer)
        _QT5_ADJUST_LIB_VARS(QAxContainer)
    ENDIF(Q_WS_WIN)


    #######################################
    #
    #       Check the executables of Qt
    #          ( moc, uic, rcc )
    #
    #######################################


    IF(QT_QMAKE_CHANGED)
        SET(QT_UIC_EXECUTABLE NOTFOUND)
        SET(QT_MOC_EXECUTABLE NOTFOUND)
        SET(QT_UIC3_EXECUTABLE NOTFOUND)
        SET(QT_RCC_EXECUTABLE NOTFOUND)
        SET(QT_DBUSCPP2XML_EXECUTABLE NOTFOUND)
        SET(QT_DBUSXML2CPP_EXECUTABLE NOTFOUND)
        SET(QT_LUPDATE_EXECUTABLE NOTFOUND)
        SET(QT_LRELEASE_EXECUTABLE NOTFOUND)
        SET(QT_QCOLLECTIONGENERATOR_EXECUTABLE NOTFOUND)
        SET(QT_DESIGNER_EXECUTABLE NOTFOUND)
        SET(QT_LINGUIST_EXECUTABLE NOTFOUND)
    ENDIF(QT_QMAKE_CHANGED)

    FIND_PROGRAM(QT_MOC_EXECUTABLE
            NAMES moc-qt5 moc
            PATHS ${QT_BINARY_DIR}
            NO_DEFAULT_PATH
            )

    FIND_PROGRAM(QT_UIC_EXECUTABLE
            NAMES uic-qt5 uic
            PATHS ${QT_BINARY_DIR}
            NO_DEFAULT_PATH
            )

    FIND_PROGRAM(QT_UIC3_EXECUTABLE
            NAMES uic3
            PATHS ${QT_BINARY_DIR}
            NO_DEFAULT_PATH
            )

    FIND_PROGRAM(QT_RCC_EXECUTABLE
            NAMES rcc
            PATHS ${QT_BINARY_DIR}
            NO_DEFAULT_PATH
            )

    FIND_PROGRAM(QT_DBUSCPP2XML_EXECUTABLE
            NAMES qdbuscpp2xml
            PATHS ${QT_BINARY_DIR}
            NO_DEFAULT_PATH
            )

    FIND_PROGRAM(QT_DBUSXML2CPP_EXECUTABLE
            NAMES qdbusxml2cpp
            PATHS ${QT_BINARY_DIR}
            NO_DEFAULT_PATH
            )

    FIND_PROGRAM(QT_LUPDATE_EXECUTABLE
            NAMES lupdate-qt5 lupdate
            PATHS ${QT_BINARY_DIR}
            NO_DEFAULT_PATH
            )

    FIND_PROGRAM(QT_LRELEASE_EXECUTABLE
            NAMES lrelease-qt5 lrelease
            PATHS ${QT_BINARY_DIR}
            NO_DEFAULT_PATH
            )

    FIND_PROGRAM(QT_QCOLLECTIONGENERATOR_EXECUTABLE
            NAMES qcollectiongenerator-qt5 qcollectiongenerator
            PATHS ${QT_BINARY_DIR}
            NO_DEFAULT_PATH
            )

    FIND_PROGRAM(QT_DESIGNER_EXECUTABLE
            NAMES designer-qt5 designer
            PATHS ${QT_BINARY_DIR}
            NO_DEFAULT_PATH
            )

    FIND_PROGRAM(QT_LINGUIST_EXECUTABLE
            NAMES linguist-qt5 linguist
            PATHS ${QT_BINARY_DIR}
            NO_DEFAULT_PATH
            )

    IF (QT_MOC_EXECUTABLE)
        SET(QT_WRAP_CPP "YES")
    ENDIF (QT_MOC_EXECUTABLE)

    IF (QT_UIC_EXECUTABLE)
        SET(QT_WRAP_UI "YES")
    ENDIF (QT_UIC_EXECUTABLE)



    MARK_AS_ADVANCED( QT_UIC_EXECUTABLE QT_UIC3_EXECUTABLE QT_MOC_EXECUTABLE
            QT_RCC_EXECUTABLE QT_DBUSXML2CPP_EXECUTABLE QT_DBUSCPP2XML_EXECUTABLE
            QT_LUPDATE_EXECUTABLE QT_LRELEASE_EXECUTABLE QT_QCOLLECTIONGENERATOR_EXECUTABLE
            QT_DESIGNER_EXECUTABLE QT_LINGUIST_EXECUTABLE)


    # get the directory of the current file, used later on in the file
    GET_FILENAME_COMPONENT( _qt5_current_dir  "${CMAKE_CURRENT_LIST_FILE}" PATH)

    ######################################
    #
    #       Macros for building Qt files
    #
    ######################################

    INCLUDE("${_qt5_current_dir}/Qt5Macros.cmake")


    ######################################
    #
    #       decide if Qt got found
    #
    ######################################

    # if the includes,libraries,moc,uic and rcc are found then we have it
    IF( QT_LIBRARY_DIR AND QT_INCLUDE_DIR AND QT_MOC_EXECUTABLE AND
            QT_UIC_EXECUTABLE AND QT_RCC_EXECUTABLE AND QT_QTCORE_LIBRARY)
        SET( QT5_FOUND "YES" )
        INCLUDE(FindPackageMessage)
        FIND_PACKAGE_MESSAGE(Qt5 "Found Qt-Version ${QTVERSION} (using ${QT_QMAKE_EXECUTABLE})"
                "[${QT_LIBRARY_DIR}][${QT_INCLUDE_DIR}][${QT_MOC_EXECUTABLE}][${QT_UIC_EXECUTABLE}][${QT_RCC_EXECUTABLE}]")
    ELSE( QT_LIBRARY_DIR AND QT_INCLUDE_DIR AND QT_MOC_EXECUTABLE AND
            QT_UIC_EXECUTABLE AND QT_RCC_EXECUTABLE AND QT_QTCORE_LIBRARY)
        SET( QT5_FOUND "NO")
        SET(QT_QMAKE_EXECUTABLE "${QT_QMAKE_EXECUTABLE}-NOTFOUND" CACHE FILEPATH "Invalid qmake found" FORCE)
        IF( Qt5_FIND_REQUIRED)
            MESSAGE( FATAL_ERROR "Qt libraries, includes, moc, uic or/and rcc NOT found!")
        ENDIF( Qt5_FIND_REQUIRED)
    ENDIF( QT_LIBRARY_DIR AND QT_INCLUDE_DIR AND QT_MOC_EXECUTABLE AND
            QT_UIC_EXECUTABLE AND  QT_RCC_EXECUTABLE AND QT_QTCORE_LIBRARY)

    SET(QT_FOUND ${QT5_FOUND})


    ###############################################
    #
    #       configuration/system dependent settings
    #
    ###############################################

    INCLUDE("${_qt5_current_dir}/Qt5ConfigDependentSettings.cmake")


    #######################################
    #
    #       compatibility settings
    #
    #######################################
    # Backwards compatibility for CMake1.5 and 1.2
    SET (QT_MOC_EXE ${QT_MOC_EXECUTABLE} )
    SET (QT_UIC_EXE ${QT_UIC_EXECUTABLE} )

    SET( QT_QT_LIBRARY "")
ENDIF (QT5_QMAKE_FOUND)
