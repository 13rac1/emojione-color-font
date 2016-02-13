
# Run with: make -j [NUMBER_OF_CPUS]

SVG_SOURCE := assets/emojione/assets/svg
SVG_FILES := $(wildcard $(SVG_SOURCE)/*.svg)
SVG_TRACE_FILES := $(patsubst $(SVG_SOURCE)/%.svg, build/svg-trace/%.svg, $(SVG_FILES))

# Use the default Linux ramdisk, change for other systems or testing.
TMP := /dev/shm/emojione

.PHONY: build clean

all: EmojiOne-SVGinOT.ttf

EmojiOne-SVGinOT.ttf: build $(SVG_TRACE_FILES)
	echo "done!"

# Create black SVG traces of the color SVGs to use as glyphs.
# 1. Make the EmojiOne SVG into a PNG with Inkscape
# 2. Make the PNG into a BMP with ImageMagick
# 3. Make the BMP into a Edge Detected PGM with mkbitmap
# 4. Make the PGM into a black SVG trace with potrace
build/svg-trace/%.svg: $(SVG_SOURCE)/%.svg
	inkscape -w 1000 -h 1000 -z -e $(TMP)/$(*F).png $<
	convert $(TMP)/$(*F).png $(TMP)/$(*F).bmp
	rm $(TMP)/$(*F).png
	mkbitmap -g -s1 -f 10 -o $(TMP)/$(*F).pgm $(TMP)/$(*F).bmp
	rm $(TMP)/$(*F).bmp
	potrace -s --height 1000pt --width 1000pt -o $@ $(TMP)/$(*F).pgm
	rm $(TMP)/$(*F).pgm

# Create the build directories
build:
	mkdir -p $(TMP)
	mkdir -p build
	mkdir -p build/svg-trace

clean:
	rm -rf build
