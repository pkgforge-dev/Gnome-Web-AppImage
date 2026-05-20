#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q epiphany | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/org.gnome.Epiphany.svg
export DESKTOP=/usr/share/applications/org.gnome.Epiphany.desktop
export STARTUPWMCLASS=org.gnome.Epiphany # Default to Wayland's wmclass. For X11, GTK_CLASS_FIX will force the wmclass to be the Wayland one.
export GTK_CLASS_FIX=1 

# Deploy dependencies
quick-sharun /usr/bin/epiphany \
             /usr/share/help/*/epiphany \
             /usr/bin/xdg-dbus-proxy \
             /usr/lib/gio/modules/libgiognomeproxy.so

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
