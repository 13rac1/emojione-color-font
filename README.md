# Emoji One SVGinOT Color Font
A color and B&W emoji SVGinOT font built primarily from [Emoji One][1] artwork
with full support for [ZWJ][2] [skin tone modifiers][3] and [country flags][4].

The font works in all operating systems, but will *currently* only show color
emoji in Mozilla Firefox and Thunderbird. This is not a limitation of the font,
but of the operating systems and applications. Regular B&W Emoji are included
for backwards/fallback compatibility.

[1]: http://emojione.com/
[2]: http://unicode.org/emoji/charts/emoji-zwj-sequences.html
[3]: http://www.unicode.org/reports/tr51/#Diversity
[4]: http://www.unicode.org/reports/tr51/#Flags

## Get it

Download the most recent version from releases, you do not need the source:
https://github.com/eosrei/emojione-color-font/releases

## What is SVGinOT?
*SVG in Open Type* is the new standard by Adobe and Mozilla for color OpenType
and Open Font Format fonts [adopted by the W3C on January 27th 2016][5]. It
allows font creators to embed complete SVG files within a font enabling full
color and even animations. There are more details in the [SVGinOT proposal][6]
and the [OpenType SVG table specifications][7].

SVGinOT Demos (Firefox only):

* https://www.adobe.com/devnet-apps/type/svgopentype.html
* https://hacks.mozilla.org/2014/10/svg-colors-in-opentype-fonts/

[5]: https://www.w3.org/community/svgopentype/2016/01/27/opentype-spec-adopts-svg-in-opentype-proposal/
[6]: https://www.w3.org/2013/10/SVG_in_OpenType/
[7]: https://www.microsoft.com/typography/otspec/svg.htm

## Examples
![Firefox color emoji in Linux, OS X, and Firefox](images/demo.png?raw=true)

## Usage - Linux
The font can be installed and set as the default Emoji font system wide.

1. Store the font file in your `~/.fonts/` directory.
2. Create a font config directory:
```sh
mkdir -p ~/.config/fontconfig/
```

3. Override your default by creating a `fonts.conf`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">

<fontconfig>
  <!-- Make Emoji One Color the initial fallback font-->
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
</fontconfig>
```

## Usage - OS X

The font installs like any other font and can be specifically selected, but
the system will default to the `Apple Color Emoji` font. If wanted, change the
default by disabling the original:

```sh
cd /System/Library/Fonts/
sudo mv Apple\ Color\ Emoji.ttf Apple\ Color\ Emoji.ttf-old
```

*Reiterating: Only FireFox supports the color emoji for now. Safari and Chrome
will use the fallback black and white emoji.*

## Usage - Windows 10

The font installs like any other font and can be specifically selected, but
the system will default to the `Segoe UI Emoji` font.

It can be manually selected in CSS, but making it the default is still TBD.

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
* [SCFBuild][8] *(created for this project!)*
* make

[8]: https://github.com/eosrei/scfbuild
Run: `make`

Or faster with multiple builds: `'make -j 4`

*I am happy with the resulting glyphs, but if you have ideas about making
them look even better let me know! I am not a font building professional and
only recently learned how to do all of this.* 😋

## Licenses

### Artwork
* Applies to SVG files
* License: Creative Commons Attribution 4.0 International
* Human Readable License: http://creativecommons.org/licenses/by/4.0/
* Complete Legal Terms: http://creativecommons.org/licenses/by/4.0/legalcode

### Source Code
* Applies to everything else
* License: MIT
* Complete Legal Terms: http://opensource.org/licenses/MIT

### Emoji One License
The SVG files of the [Emoji One](http://emojione.com/) project have been
modified to create the fallback emoji glyphs and used as-is for the SVGinOT
color glyphs. Files are stored in `assets/emojione-svg`.

* Source: https://github.com/Ranks/emojione
* Art License: Creative Commons Attribution 4.0 International

Please review the specific attribution requirements for commercial use of
Emoji One icons: http://emojione.com/licensing/

### Twitter Emoji for Everyone License
A few SVG files of the Twitter Emoji for Everyone project are used to fill in
where Emoji One is missing characters required to generate a font. Files are
stored in `assets/svg`.

* Source: https://github.com/twitter/twemoji
* Art License: Creative Commons Attribution 4.0 International
