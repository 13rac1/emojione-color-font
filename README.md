# Symbola Color Emoji

A SVG-in-OpenType color emoji font created by starting with the "free for any use"
Symbola font and adding the colorful Emoji One SVG emojis where possible.

# Usage (Linux)

1. Store the font file in your `~/.fonts/` directory.
2. Create a fontconfig directory:
```sh
mkdir -p `~/.config/fontconfig/`
```

3. Override your defaults by creating a `fonts.conf`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<!-- -->
<fontconfig>
  <!-- Generic name aliasing -->
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Symbola</family>
    </prefer>
  </alias>
  <alias>
    <family>serif</family>
    <prefer>
      <family>Symbola</family>
    </prefer>
  </alias>
</fontconfig>
```
