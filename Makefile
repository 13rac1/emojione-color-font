
SVG_SOURCE := assets/emojione/assets/svg
SVG_FILES := $(wildcard $(SVG_SOURCE)/*.svg)
SVG_TRACE_FILES := $(patsubst $(SVG_SOURCE)/%.svg, build/4-svg-trace/%.svg, $(SVG_FILES))

.PHONY: build


all: EmojiOne-SVGinOT.ttf

EmojiOne-SVGinOT.ttf: build $(SVG_TRACE_FILES)
	echo "done!"


# Create black SVG traces of the color SVGs to use as glyphs.
# 1. Make the EmojiOne SVG into a PNG with Inkscape
# 2. Make the PNG into a BMP with ImageMagick
# 3. Make the BMP into a Edge Detected PGM with mkbitmap
# 4. Make the PGM into a black SVG trace with potrace
build/4-svg-trace/%.svg: $(SVG_SOURCE)/%.svg
	inkscape -w 1000 -h 1000 -z -e build/1-svg-png/$(*F).png $<
	convert build/1-svg-png/$(*F).png build/2-svg-bmp/$(*F).bmp
	rm build/1-svg-png/$(*F).png
	mkbitmap -g -s1 -f 10 -o build/3-svg-pgm/$(*F).pgm build/2-svg-bmp/$(*F).bmp
	rm build/2-svg-bmp/$(*F).bmp
	potrace -s --height 1000pt --width 1000pt -o $@ build/3-svg-pgm/$(*F).pgm
	rm build/3-svg-pgm/$(*F).pgm

# Create the build directories
build:
	mkdir -p build
	mkdir -p build/1-svg-png
	mkdir -p build/2-svg-bmp
	mkdir -p build/3-svg-pgm
	mkdir -p build/4-svg-trace
