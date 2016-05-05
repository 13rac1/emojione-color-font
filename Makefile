# Makefile to create all versions of the Emoji One Color SVGinOT font
# Run with: make -j [NUMBER_OF_CPUS]

TMP := /tmp
# Use Linux Shared Memory to avoid wasted disk writes.
#TMP := /dev/shm

# Where to find scfbuild?
SCFBUILD := SCFBuild/bin/scfbuild

VERSION := 1.0
FONT_PREFIX := EmojiOneColor-SVGinOT
REGULAR_FONT := build/$(FONT_PREFIX).ttf
REGULAR_PACKAGE := build/$(FONT_PREFIX)-$(VERSION)
OSX_FONT := build/$(FONT_PREFIX)-OSX.ttf
OSX_PACKAGE := build/$(FONT_PREFIX)-OSX-$(VERSION)
LINUX_PACKAGE := $(FONT_PREFIX)-Linux-$(VERSION)
DEB_PACKAGE := fonts-emojione-svginot

# There are two SVG source directories to keep the emojione assets separate.
SVG_EMOJIONE := assets/emojione-svg
SVG_MORE := assets/svg

# Create the lists of traced and color SVGs
SVG_FILES := $(wildcard $(SVG_EMOJIONE)/*.svg) $(wildcard $(SVG_MORE)/*.svg)
SVG_STAGE_FILES := $(patsubst $(SVG_EMOJIONE)/%.svg, build/stage/%.svg, $(SVG_FILES))
SVG_STAGE_FILES := $(patsubst $(SVG_MORE)/%.svg, build/stage/%.svg, $(SVG_STAGE_FILES))
SVG_TRACE_FILES := $(patsubst build/stage/%.svg, build/svg-trace/%.svg, $(SVG_STAGE_FILES))
SVG_COLOR_FILES := $(patsubst build/stage/%.svg, build/svg-color/%.svg, $(SVG_STAGE_FILES))

.PHONY: all package regular-package linux-package osx-package clean

all: $(REGULAR_FONT) $(OSX_FONT)

# Create the operating system specific packages
package: regular-package linux-package deb-package osx-package

regular-package: $(REGULAR_FONT)
	rm -f $(REGULAR_PACKAGE).zip
	rm -rf $(REGULAR_PACKAGE)
	mkdir $(REGULAR_PACKAGE)
	cp $(REGULAR_FONT) $(REGULAR_PACKAGE)
	cp LICENSE* $(REGULAR_PACKAGE)
	cp README.md $(REGULAR_PACKAGE)
	7z a -tzip -mx=9 $(REGULAR_PACKAGE).zip ./$(REGULAR_PACKAGE)

linux-package: $(REGULAR_FONT)
	rm -f build/$(LINUX_PACKAGE).tar.gz
	rm -rf build/$(LINUX_PACKAGE)
	mkdir build/$(LINUX_PACKAGE)
	cp $(REGULAR_FONT) build/$(LINUX_PACKAGE)
	cp LICENSE* build/$(LINUX_PACKAGE)
	cp README.md build/$(LINUX_PACKAGE)
	cp -R linux/* build/$(LINUX_PACKAGE)
	tar zcvf build/$(LINUX_PACKAGE).tar.gz -C build $(LINUX_PACKAGE)

deb-package: linux-package
	rm -rf build/$(DEB_PACKAGE)-$(VERSION)
	cp build/$(LINUX_PACKAGE).tar.gz build/$(DEB_PACKAGE)_$(VERSION).orig.tar.gz
	cp -R build/$(LINUX_PACKAGE) build/$(DEB_PACKAGE)-$(VERSION)
	cd build/$(DEB_PACKAGE)-$(VERSION); debuild -us -uc
	#debuild -S

osx-package: $(OSX_FONT)
	rm -f $(OSX_PACKAGE).zip
	rm -rf $(OSX_PACKAGE)
	mkdir $(OSX_PACKAGE)
	cp $(OSX_FONT) $(OSX_PACKAGE)
	cp LICENSE* $(OSX_PACKAGE)
	cp README.md $(OSX_PACKAGE)
	7z a -tzip -mx=9 $(OSX_PACKAGE).zip ./$(OSX_PACKAGE)

# Build both versions of the fonts
$(REGULAR_FONT): $(SVG_TRACE_FILES) $(SVG_COLOR_FILES)
	$(SCFBUILD) -c scfbuild.yml -o $(REGULAR_FONT) --font-version="$(VERSION)"

$(OSX_FONT): $(SVG_TRACE_FILES) $(SVG_COLOR_FILES)
	$(SCFBUILD) -c scfbuild-osx.yml -o $(OSX_FONT) --font-version="$(VERSION)"

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
	potrace --flat -s --height 2048pt --width 2048pt -o $@ $(TMP)/$(*F).pgm
	rm $(TMP)/$(*F).pgm

# Optimize/clean the color SVG files
build/svg-color/%.svg: build/staging/%.svg | build/svg-color
	svgo -i $< -o $@

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

build/svg-color: | build
	mkdir build/svg-color

clean:
	rm -rf build
