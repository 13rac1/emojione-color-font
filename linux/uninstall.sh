#!/bin/sh
#https://github.com/eosrei/emojione-color-font
echo "EmojiOne Color font uninstaller for Linux\n"

set -v

# Set XDG_DATA_HOME to default if empty.
if [ -z "$XDG_DATA_HOME" ];then
  XDG_DATA_HOME=$HOME/.local/share
fi
FONTCONFIG=$HOME/.config/fontconfig

rm $XDG_DATA_HOME/fonts/EmojiOneColor-SVGinOT.ttf
rm $FONTCONFIG/conf.d/56-emojione-color.conf

echo "Clearing font cache"
fc-cache -f

echo "Done!"
