#!/bin/bash
# Tests of fontconfig configuration for Bitstream Vera and EmojiOne Color.
#
# The first two lines of the results of fc-match for each font request are
# are compared to known correct results. Any differences are shown.

# The test result file
TMP=current-results.test
# The expected test result file
EXPECTED=expected-results.test

FONTS[0]='sans'
FONTS[1]="sans-serif"
FONTS[2]="serif"
FONTS[3]="mono"
FONTS[4]="monospace"
FONTS[5]="Bitstream Vera Sans"
FONTS[6]="Bitstream Vera Serif"
FONTS[7]="Bitstream Vera Sans Mono"
FONTS[8]="emoji"
FONTS[9]="EmojiOne Color"
FONTS[10]="Apple Color Emoji"
FONTS[11]="Segoe UI Emoji"
FONTS[12]="Noto Color Emoji"

rm -f $TMP

# Run fc-match against all font values
for FONT in "${FONTS[@]}"; do
  echo "Font: $FONT" >> $TMP
  fc-match -s "$FONT" | head -n2 >> $TMP
  echo >> $TMP
done

# Create expected results if missing, aka delete to update.
if [ ! -f $EXPECTED ]; then
  cp $TMP $EXPECTED
  echo "Fontconfig tests: UPDATE"
  exit 1
fi
# Compare current results to expected results
echo diff $TMP $EXPECTED
diff -yt $TMP $EXPECTED
RESULT=$?
rm $TMP

if [ $RESULT -eq 0 ]; then
  echo "Fontconfig tests: PASS"
  exit 0
else
  echo "Fontconfig tests: FAIL"
  exit 1
fi
