# Emoji One Color SVGinOT Font
A color and B&W emoji SVGinOT font built primarily from [Emoji One][1] artwork
with support for [ZWJ][2], [skin tone modifiers][3] and [country flags][4].

The font works in all operating systems, but will *currently* only show color
emoji in Mozilla Firefox and Thunderbird. This is not a limitation of the font,
but of the operating systems and applications. Regular B&W outline emoji are
included for backwards/fallback compatibility.

[Do you prefer Twitter Emoji for Everyone graphics?][5]

[1]: http://emojione.com/
[2]: http://unicode.org/emoji/charts/emoji-zwj-sequences.html
[3]: http://www.unicode.org/reports/tr51/#Diversity
[4]: http://www.unicode.org/reports/tr51/#Flags
[5]: https://github.com/eosrei/twemoji-color-font

## Table of Contents

* [Examples](#examples)
* [What is SVGinOT?](#what-is-svginot)
* [Install on Linux](#install-on-linux)
* [Install on OS X](#install-on-os-x)
* [Install on Windows](#install-on-windows)
* [Known issues](#known-issues)
* [Building](#building)
* [License](#license)

## Examples

**Before**: Firefox in Ubuntu Linux.

[![Before Emoji One Color in Firefox Linux](images/demo-before.png?raw=true)](images/before-linux-firefox.png?raw=true)

**After**: Firefox in all three operating systems, plus fallback outline
characters in the other browsers.
![Firefox color emoji in Linux, OS X, and Firefox](images/demo.png?raw=true)

Some examples to see before and after on your machine:
* http://eosrei.github.io/emojione-color-font/full-demo.html
* http://unicode.org/emoji/charts/emoji-zwj-sequences.html
* https://en.wikipedia.org/wiki/Regional_Indicator_Symbol

## What is SVGinOT?
*SVG in Open Type* is a standard by Adobe and Mozilla for color OpenType
and Open Font Format fonts. It allows font creators to embed complete SVG files
within a font enabling full color and even animations. There are more details
in the [SVGinOT proposal][6] and the [OpenType SVG table specifications][7].

SVGinOT Demos (Firefox only):

* https://www.adobe.com/devnet-apps/type/svgopentype.html
* https://hacks.mozilla.org/2014/10/svg-colors-in-opentype-fonts/

[6]: https://www.w3.org/2013/10/SVG_in_OpenType/
[7]: https://www.microsoft.com/typography/otspec/svg.htm

## Install on Linux
The font can be installed for a user or system-wide. This describes how to
install for a user and does not require root. You *can* simply copy/paste it all
at one time.

```sh
# 1. Download the latest version from: https://github.com/eosrei/emojione-color-font/releases
wget https://github.com/eosrei/emojione-color-font/releases/download/v1.0-beta2/EmojiOneColor-SVGinOT-1.0-beta2.zip
# 2. Uncompress the zip file
unzip -o EmojiOneColor-SVGinOT-1.0-beta2.zip
# 3. Create a user font directory, if you don't have one:
mkdir -p ~/.fonts/
# 4. Move the font into ~/.fonts/
mv EmojiOneColor-SVGinOT.ttf ~/.fonts/
# 5. Create a font config directory
mkdir -p ~/.config/fontconfig/
# 6. Override your defaults by creating a ~/.config/fontconfig/fonts.conf
cat << 'EOF' > ~/.config/fontconfig/fonts.conf
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">

<fontconfig>
  <!--
  Make Emoji One Color the initial fallback font for sans-serif, sans, and
  monospace. Override any specific requests for Apple Color Emoji.
  -->
  <match>
    <test name="family"><string>sans-serif</string></test>
    <edit name="family" mode="prepend" binding="strong">
      <string>Emoji One Color</string>
    </edit>
  </match>
  <match>
    <test name="family"><string>serif</string></test>
    <edit name="family" mode="prepend" binding="strong">
      <string>Emoji One Color</string>
    </edit>
  </match>
  <match>
    <test name="family"><string>monospace</string></test>
    <edit name="family" mode="prepend" binding="strong">
      <string>Emoji One Color</string>
    </edit>
  </match>
  <match>
    <test name="family"><string>Apple Color Emoji</string></test>
    <edit name="family" mode="prepend" binding="strong">
      <string>Emoji One Color</string>
    </edit>
  </match>
</fontconfig>
EOF
# 7. Just to be sure, clear your font cache and restart Firefox
fc-cache -f -v
# Done!
```

Try the full demo at: http://eosrei.github.io/emojione-color-font/full-demo.html

## Install on OS X

There are three install options for OS X. Both SVGinOT versions are available
from releases: https://github.com/eosrei/emojione-color-font/releases

1. `EmojiOneColor-SVGinOT-1.0-beta2.zip` - The regular version of the font installs
   like any other font and can be specifically selected, but OS X will
   default to the `Apple Color Emoji` font.
2. ` EmojiOneColor-SVGinOT-OSX-1.0-beta2.zip` - A "hack" to replace the `Apple Color
   Emoji` font by [using the same internal name][8]. Install and accept the
   warning in Font Book.
3. `emojione-apple.ttf` - A bitmap Apple-format Emoji One color font is
   [available in the emojione project][9].

[8]:http://www.macissues.com/2014/11/21/how-to-change-the-default-system-font-in-mac-os-x/
[9]:https://github.com/Ranks/emojione/tree/master/assets/fonts

*Reiterating: Only FireFox supports the SVGinOT color emoji for now. Safari and
Chrome will use the fallback black and white emoji.*

## Install on Windows

The font installs like any other font and can be specifically selected, but
the system will default to the `Segoe UI Emoji` font.

It can be manually selected in CSS, but making it the default is still TBD.

## Known issues

* VLC uses the system default Sans-Serif font for subtitles/OSD *without*
  falling back for missing characters. Specifically select a subtitle/OSD font
  [[details][10]].

[10]:https://github.com/eosrei/emojione-color-font/issues/5

## Building
The build process has only been tested on Ubuntu Linux.

Overview:

1. B&W SVGs are generated on-the-fly from the color SVGs
2. The B&W SVGs are imported based on their filename to create either regular
   glyphs or ligature glyphs.
3. The color SVGs are imported to override both types of glyphs.

Required applications:

* Inkscape
* Imagemagick
* mkbitmap
* potrace
* FontTools
* FontForge
* SVGO
* [SCFBuild][11] *(created for this project!)*
* make

[11]: https://github.com/eosrei/scfbuild
Run: `make`

Or faster with multiple builds: `make -j 4`

*I am happy with the resulting outline glyphs, but there's room for improvement.
Let me know if you have ideas about making them look even better! I am not a
font building professional and only recently learned how to do all of this.* 😋

## License

The artwork and TTF fonts are licensed CC-BY-4.0. Please see
[LICENSE.md](LICENSE.md) for details.
