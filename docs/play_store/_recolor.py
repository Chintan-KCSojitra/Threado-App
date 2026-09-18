"""Remap generated black-on-cream art to exact Thredo brand colors.

Background -> #E7E3DA (colorE7E3DA), foreground -> #010103 (color010103).
Uses a duotone (grayscale -> two-color gradient) remap so anti-aliased
edges blend smoothly between the two exact brand colors.
"""
from PIL import Image

DARK = (0x01, 0x01, 0x03)   # color010103
LIGHT = (0xE7, 0xE3, 0xDA)  # colorE7E3DA

# Build a 256-entry lookup table from dark (0) to light (255).
lut_r, lut_g, lut_b = [], [], []
for i in range(256):
    t = i / 255.0
    lut_r.append(round(DARK[0] + (LIGHT[0] - DARK[0]) * t))
    lut_g.append(round(DARK[1] + (LIGHT[1] - DARK[1]) * t))
    lut_b.append(round(DARK[2] + (LIGHT[2] - DARK[2]) * t))


def recolor(src, dst, size, crop):
    img = Image.open(src).convert("L")  # grayscale

    # Lock the dominant background tone to pure white and the ink to pure
    # black, so the duotone maps the background to EXACTLY LIGHT and the
    # line art to EXACTLY DARK (the generator's cream isn't pure white).
    hist = img.histogram()
    # Background = most frequent bright value (the large flat cream area).
    bg = max(range(180, 256), key=lambda v: hist[v])
    # Ink = darkest meaningful value present.
    lo = next((v for v in range(256) if hist[v] > 0), 0)
    white_point = max(bg, lo + 1)
    scale = 255.0 / (white_point - lo)
    img = img.point(
        lambda p: 0 if p <= lo else (255 if p >= white_point
                                     else int((p - lo) * scale))
    )

    # Center-crop to the target aspect ratio.
    cw, ch = crop
    w, h = img.size
    target = cw / ch
    if w / h > target:
        new_w = int(h * target)
        left = (w - new_w) // 2
        img = img.crop((left, 0, left + new_w, h))
    else:
        new_h = int(w / target)
        top = (h - new_h) // 2
        img = img.crop((0, top, w, top + new_h))

    img = img.resize(size, Image.LANCZOS)

    # Apply duotone LUT -> RGB.
    out = Image.merge("RGB", (
        img.point(lut_r),
        img.point(lut_g),
        img.point(lut_b),
    ))
    out.save(dst)
    print(dst, out.size)


SRC = "/Users/ayazshekh/.cursor/projects/Users-ayazshekh-Projects-Flutter-Thredo/assets"
recolor(f"{SRC}/play_app_icon_512_v3.png",
        "docs/play_store/app_icon_512.png", (512, 512), (1, 1))
recolor(f"{SRC}/play_feature_graphic_1024x500_v3.png",
        "docs/play_store/feature_graphic_1024x500.png", (1024, 500), (1024, 500))
