
# Run with: make -j [NUMBER_OF_CPUS]

.PHONY: clean

OUTPUT_FONT := build/EmojiOneColor-SVGinOT.ttf
SCFBUILD := SCFBuild/bin/scfbuild

TMP := /tmp
# Use Linux Shared Memory to avoid wasted disk writes.
#TMP := /dev/shm

# There are two SVG source directories to keep the emojione assets separate.
SVG_EMOJIONE := assets/emojione-svg
SVG_MORE := assets/svg

# Create the lists of traced and color SVGs
SVG_FILES := $(wildcard $(SVG_EMOJIONE)/*.svg) $(wildcard $(SVG_MORE)/*.svg)
SVG_TRACE_FILES := $(patsubst $(SVG_EMOJIONE)/%.svg, build/svg-trace/%.svg, $(SVG_FILES))
SVG_TRACE_FILES := $(patsubst $(SVG_MORE)/%.svg, build/svg-trace/%.svg, $(SVG_TRACE_FILES))
SVG_COLOR_FILES := $(patsubst build/svg-trace/%.svg, build/staging/%.svg, $(SVG_TRACE_FILES))

all: $(OUTPUT_FONT)

$(OUTPUT_FONT): $(SVG_TRACE_FILES) $(SVG_COLOR_FILES)
	$(SCFBUILD) -c scfbuild.yml -o $(OUTPUT_FONT)

# Create black SVG traces of the color SVGs to use as glyphs.
# 1. Make the EmojiOne SVG into a PNG with Inkscape
# 2. Make the PNG into a BMP with ImageMagick and add margin by increasing the
#    canvas size to allow the outer "stroke" to fit.
# 3. Make the BMP into a Edge Detected PGM with mkbitmap
# 4. Make the PGM into a black SVG trace with potrace
build/svg-trace/%.svg: build/staging/%.svg | build/svg-trace
	inkscape -w 1000 -h 1000 -z -e $(TMP)/$(*F).png $<
	convert $(TMP)/$(*F).png -gravity center -extent 1066x1066 $(TMP)/$(*F).bmp
	rm $(TMP)/$(*F).png
	mkbitmap -g -s 1 -f 10 -o $(TMP)/$(*F).pgm $(TMP)/$(*F).bmp
	rm $(TMP)/$(*F).bmp
	potrace -s --height 2048pt --width 2048pt -o $@ $(TMP)/$(*F).pgm
	rm $(TMP)/$(*F).pgm

# Copy the files from multiple directories into one source directory
build/staging/%.svg: $(SVG_EMOJIONE)/%.svg | build/staging
	cp $< $@

build/staging/%.svg: $(SVG_MORE)/%.svg | build/staging
	cp $< $@

# Create the build directories
build:
	mkdir build

build/staging: | build
	mkdir build/staging

build/svg-trace: | build
	mkdir build/svg-trace

clean:
	rm -rf build
