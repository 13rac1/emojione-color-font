# Emoji One Color SVGinOT Font
A color and B&W emoji SVGinOT font built primarily from [Emoji One][1] artwork
with support for [ZWJ][2], [skin tone diversity][3] and [country flags][4].

The font works in all operating systems, but will *currently* only show color
emoji in Firefox, Thunderbird and other Mozilla Gecko-based applications. This
is not a limitation of the font, but of the operating systems and applications.
Regular B&W outline emoji are included for backwards/fallback compatibility.

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

**After**: Firefox in all three operating systems, plus fall back outline
characters in the other browsers.
![Firefox color emoji in Linux, OS X, and Firefox](images/demo.png?raw=true)

See before and after on your machine:
* http://eosrei.github.io/emojione-color-font/full-demo.html

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
The font can be installed for a user or system-wide. Get the latest version
from releases: https://github.com/eosrei/emojione-color-font/releases

Install for the current user without root:
```sh
# 1. Download the latest version
wget https://github.com/eosrei/emojione-color-font/releases/download/v1.0/EmojiOneColor-SVGinOT-Linux-1.0.tar.gz
# 2. Uncompress the file
tar zxf EmojiOneColor-SVGinOT-Linux-1.0.tar.gz
# 3. Run the installer
cd EmojiOneColor-SVGinOT-Linux-1.0
./install.sh
```

*Note: This requires `Bitstream Vera` is installed and will change your
systems default serif, sans-serif and monospace fonts.*

### Install on Ubuntu Linux
Launchpad PPA: https://launchpad.net/~eosrei/+archive/ubuntu/fonts

```sh
sudo apt-add-repository ppa:eosrei/fonts
sudo apt-get update
sudo apt-get install fonts-emojione-svginot
```

Useful: [Emojione Picker for Ubuntu][8]
[8]: https://github.com/gentakojima/emojione-picker-ubuntu

### Install on Arch Linux
AUR package: https://aur.archlinux.org/packages/emojione-color-font/

```sh
yaourt -S emojione-color-font
```

### Why Bitstream Vera
The default serif, sans-serif and monospace font for most Linux distributions is
`DejaVu`. `DejaVu` includes a wide range of symbols which override the
`Emoji One Color` characters. The previous solution was to make
`Emoji One Color` the default system font, but that causes a number of issues.
A better solution is a different font that doesn't override any emoji characters
such as `Bitstream Vera`. `Bitstream Vera` is the source of the glyphs used in
`DejaVu`, so it's not very different.

### Additional Default Font Options
The `Noto` and `Roboto` font families conflict far less than `DejaVu`. You may
want to try them. Primary issues are the 0x2639 and 0x263a characters.

## Install on OS X
There are three install options for OS X. Both SVGinOT versions are available
from releases: https://github.com/eosrei/emojione-color-font/releases

1. `EmojiOneColor-SVGinOT-1.0.zip` - The regular version of the font
   installs like any other font and can be specifically selected, but OS X will
   default to the `Apple Color Emoji` font for emojis.
2. ` EmojiOneColor-SVGinOT-OSX-1.0.zip` - A hack to replace the `Apple
   Color Emoji` font by [using the same internal name][9]. Install and accept
   the warning in Font Book.
3. `emojione-apple.ttf` - A SBIX bitmap Apple-format Emoji One color font is
   [available in the emojione project][10].

[9]:http://www.macissues.com/2014/11/21/how-to-change-the-default-system-font-in-mac-os-x/
[10]:https://github.com/Ranks/emojione/tree/master/assets/fonts

*Reiterating: Only FireFox supports the SVGinOT color emoji for now. Safari and
Chrome will use the fallback black and white emoji.*

## Install on Windows

The font installs like any other font and can be specifically selected, but
the system will default to the `Segoe UI Emoji` font. Get the current version
from: https://github.com/eosrei/emojione-color-font/releases

Help wanted: [How to override the Windows default Segoe UI Emoji font][11]

[11]:https://github.com/eosrei/emojione-color-font/issues/15

## Known issues

* [Symbols/emoji in monospace formatted text cause incorrect character
  alignment][12]. The whitespace character widths from the most recently selected
  fallback font are used in Pango/GTK applications.
* [Some font families are not matched correctly in Linux Firefox <47][13].
  Workaround: Open `about:config` set
  `gfx.font_rendering.fontconfig.fontlist.enabled` to `false`.
  Fixed in Firefox 47+. [[issue #31][14]]

[12]:https://bugzilla.gnome.org/show_bug.cgi?id=757785
[13]:https://bugzilla.mozilla.org/show_bug.cgi?id=1245811
[14]:https://github.com/eosrei/emojione-color-font/issues/31

## Building
Overview:

1. B&W SVGs are generated on-the-fly from the color SVGs
2. The B&W SVGs are imported based on their filename to create either regular
   glyphs or ligature glyphs.
3. The color SVGs are imported to override both types of glyphs.

Requires:
* Inkscape
* Imagemagick
* potrace/mkbitmap
* FontTools 3.0+
* FontForge 20160405+
* SVGO
* make
* [SCFBuild][15] *(Created for this project!)*

[15]: https://github.com/eosrei/scfbuild

Setup and build on Ubuntu 14.04 LTS:
```sh
sudo add-apt-repository ppa:fontforge/fontforge
sudo apt-get update
sudo apt-get install inkscape potrace npm nodejs nodejs-legacy fontforge \
python-fontforge python-pip imagemagick git make
sudo npm install -g svgo
sudo pip install fonttools
git clone https://github.com/eosrei/emojione-color-font.git
cd emojione-color-font
git clone https://github.com/eosrei/scfbuild.git SCFBuild
make -j 4
```

## License

The artwork and TTF fonts are licensed CC-BY-4.0. Please see
[LICENSE.md](LICENSE.md) for details.
