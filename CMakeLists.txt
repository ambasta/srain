cmake_minimum_required(VERSION 3.0)
include(GNUInstallDirs)

project(Srain
        VERSION 1.0.0.9999
        LANGUAGES C
        DESCRIPTION "Modern IRC client written in GTK"
        HOMEPAGE_URL "https://srain.im")

# PACKAGE_BUILD = $(shell [ -d .git ] && \ git rev-parse --git-dir > /dev/null
# 2>&1 && \ echo -n -git@0.`git rev-list --count HEAD`.`git describe --always`)
string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWER)
set(PACKAGE_APPID "im.srain.Srain")
set(PACKAGE_AUTHOR "Shengyu Zhang")
set(PACKAGE_EMAIL i@silverrainz.me)
set(PACKAGE_WEBSITE "https://srain.im")
set(PACKAGE_COPYRIGHT_DATES "2016 - 2019")
set(PACKAGE_VERSION "1.0.0rc9999")

add_definitions(-DPACKAGE="${PROJECT_NAME_LOWER}"
                -DPACKAGE_VERSION="${PACKAGE_VERSION}"
                -DPACKAGE_NAME="${PROJECT_NAME}"
                -DPACKAGE_BUILD=""
                -DPACKAGE_APPID="${PACKAGE_APPID}"
                -DPACKAGE_AUTHOR="${PACKAGE_AUTHOR}"
                -DPACKAGE_EMAIL="${PACKAGE_EMAIL}"
                -DPACKAGE_DESC="${PROJECT_DESCRIPTION}"
                -DPACKAGE_WEBSITE="${PROJECT_HOMEPAGE_URL}"
                -DPACKAGE_COPYRIGHT_DATES="${PACKAGE_COPYRIGHT_DATES}"
                -DPACKAGE_CONFIG_DIR="${CMAKE_INSTALL_FULL_SYSCONFDIR}")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
include(${CMAKE_SOURCE_DIR}/cmake/GResources.cmake)
find_package(Gettext REQUIRED)
find_package(PkgConfig REQUIRED)
find_package(OpenSSL REQUIRED)

pkg_check_modules(GLIB
                  REQUIRED
                  IMPORTED_TARGET
                  glib-2.0)
pkg_check_modules(GTK
                  REQUIRED
                  IMPORTED_TARGET
                  gtk+-3.0)
pkg_check_modules(LIBSOUP
                  REQUIRED
                  IMPORTED_TARGET
                  libsoup-2.4)
pkg_check_modules(LIBCONFIG
                  REQUIRED
                  IMPORTED_TARGET
                  libconfig)
pkg_check_modules(LIBSECRET
                  REQUIRED
                  IMPORTED_TARGET
                  libsecret-1)

set(${PROJECT_NAME}_SOURCES
    src/config/manager.c
    src/config/password.c
    src/config/reader.c
    src/core/app.c
    src/core/app_config.c
    src/core/app_irc_event.c
    src/core/app_ui_event.c
    src/core/app_url.c
    src/core/chat.c
    src/core/chat_command.c
    src/core/chat_config.c
    src/core/chat_user.c
    src/core/login_config.c
    src/core/message.c
    src/core/server.c
    src/core/server_cap.c
    src/core/server_config.c
    src/core/server_state.c
    src/core/server_user.c
    src/core/srain.c
    src/core/user_config.c
    src/filter/filter.c
    src/filter/log_filter.c
    src/filter/pattern_filter.c
    src/filter/user_filter.c
    src/lib/command.c
    src/lib/command_test.c
    src/lib/extra_data.c
    src/lib/i18n.c
    src/lib/libecdsaauth/base64.c
    src/lib/libecdsaauth/keypair.c
    src/lib/libecdsaauth/op.c
    src/lib/log.c
    src/lib/markup_renderer.c
    src/lib/path.c
    src/lib/pattern_set.c
    src/lib/ret.c
    src/lib/utils.c
    src/lib/version.c
    src/render/mention_renderer.c
    src/render/mirc_colorize_renderer.c
    src/render/mirc_strip_renderer.c
    src/render/pattern_render.c
    src/render/render.c
    src/render/url_renderer.c
    src/sirc/io_stream.c
    src/sirc/sirc.c
    src/sirc/sirc_cmd.c
    src/sirc/sirc_config.c
    src/sirc/sirc_event_hdr.c
    src/sirc/sirc_parse.c
    src/sirc/sirc_utils.c
    src/sui/nick_menu.c
    src/sui/sui_app.c
    src/sui/sui_buffer.c
    src/sui/sui.c
    src/sui/sui_channel_buffer.c
    src/sui/sui_chat_buffer.c
    src/sui/sui_common.c
    src/sui/sui_completion.c
    src/sui/sui_config.c
    src/sui/sui_connect_panel.c
    src/sui/sui_dialog_buffer.c
    src/sui/sui_event_hdr.c
    src/sui/sui_join_panel.c
    src/sui/sui_message.c
    src/sui/sui_message_list.c
    src/sui/sui_misc_message.c
    src/sui/sui_notification.c
    src/sui/sui_prefs_dialog.c
    src/sui/sui_recv_message.c
    src/sui/sui_send_message.c
    src/sui/sui_server_buffer.c
    src/sui/sui_side_bar.c
    src/sui/sui_side_bar_item.c
    src/sui/sui_theme.c
    src/sui/sui_url_previewer.c
    src/sui/sui_user.c
    src/sui/sui_user_list.c
    src/sui/sui_window.c)

glib_compile_resources(${PROJECT_NAME}_RESOURCES_RING SOURCE
                       data/srain.gresource.xml)
message("Ring sources: ${${PROJECT_NAME}_RESOURCES_RING}")
message("Ring sources: ${PROJECT_NAME}_RESOURCES_RING")
add_executable(${PROJECT_NAME} ${${PROJECT_NAME}_RESOURCES_RING}
                               ${${PROJECT_NAME}_SOURCES})

target_include_directories(${PROJECT_NAME} PRIVATE src/inc)
target_link_libraries(${PROJECT_NAME}
                      PkgConfig::GLIB
                      PkgConfig::GTK
                      PkgConfig::LIBSOUP
                      PkgConfig::LIBCONFIG
                      PkgConfig::LIBSECRET
                      OpenSSL::SSL)

# message("Looking at ${CMAKE_CURRENT_SOURCE_DIR}/data/ui/srain.gresource.xml")
# execute_process(OUTPUT_VARIABLE _files WORKING_DIRECTORY
# "${CMAKE_CURRENT_SOURCE_DIR}/data" COMMAND ${GLib_COMPILE_RESOURCES}
# --generate-dependencies "srain.gresource.xml")
#
# message("Files: ${_files} prog: ${GLib_COMPILE_RESOURCES}") string(REPLACE
# "\n" ";" _FILES ${_files})
#
# set(DATA_FILES "") get_filename_component(resource_name "srain.gresource.xml"
# NAME_WE)
#
# foreach(_FILE ${_FILES}) list(APPEND DATA_FILES
# "${CMAKE_CURRENT_SOURCE_DIR}/data/ui/${_FILE}") endforeach(_FILE ${_FILES})
#
# add_custom_command( OUTPUT GRE_SOURCES DEPENDS
# "${CMAKE_CURRENT_SOURCE_DIR}/data/ui/srain.gresource.xml" ${DATA_FILES}
# WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/data/ui/" COMMAND
# ${GLib_COMPILE_RESOURCES_EXECUTABLE} --generate-source
# --target="${CMAKE_CURRENT_BINARY_DIR}/${resource_name}-resources.c")
