"""
Generates the NextCart launcher icons from a stylised bag-shopping glyph.

Outputs (relative to nextcart/):
  assets/icon/icon.png             - 1024x1024, full bleed (iOS / fallback)
  assets/icon/icon_foreground.png  - 1024x1024, transparent bg (Android adaptive fg)
  assets/icon/icon_background.png  - 1024x1024, gradient only (Android adaptive bg)
"""

from __future__ import annotations

import os
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

# Brand palette (matches lib/core/theme/app_theme.dart)
PRIMARY = (132, 177, 121)        # #84B179
PRIMARY_SOFT = (162, 203, 139)   # #A2CB8B
WHITE = (255, 255, 255, 255)

SIZE = 1024

OUT_DIR = Path(__file__).resolve().parents[2] / "assets" / "icon"
OUT_DIR.mkdir(parents=True, exist_ok=True)


def make_gradient(size: int) -> Image.Image:
    """Diagonal gradient PRIMARY -> PRIMARY_SOFT."""
    img = Image.new("RGB", (size, size), PRIMARY)
    px = img.load()
    for y in range(size):
        for x in range(size):
            # Diagonal blend factor 0..1
            t = (x + y) / (2 * (size - 1))
            r = int(PRIMARY[0] * (1 - t) + PRIMARY_SOFT[0] * t)
            g = int(PRIMARY[1] * (1 - t) + PRIMARY_SOFT[1] * t)
            b = int(PRIMARY[2] * (1 - t) + PRIMARY_SOFT[2] * t)
            px[x, y] = (r, g, b)
    return img


def draw_bag(canvas: Image.Image, scale: float = 0.58, y_shift: int = 40) -> None:
    """
    Draws a centred shopping-bag glyph (filled white) onto `canvas`.

    Geometry (FA bag-shopping inspired):
      - rectangular body, slightly wider than tall, with rounded corners
      - two arched handles peeking above the body
    """
    w, h = canvas.size
    side = int(min(w, h) * scale)
    cx, cy = w // 2, h // 2 + y_shift

    # Bag body — slightly wider than tall, FA-like proportion
    body_w = int(side * 1.05)
    body_h = int(side * 0.95)
    bx0 = cx - body_w // 2
    by0 = cy - body_h // 2
    bx1 = cx + body_w // 2
    by1 = cy + body_h // 2

    # Handles
    handle_w = int(side * 0.34)
    handle_h = int(side * 0.46)
    handle_thickness = int(side * 0.085)

    # Vertical placement: arc top sits well above the bag, bottom tucks just
    # below the bag's top edge so the join reads as continuous.
    handle_y0 = by0 - handle_h + int(side * 0.04)
    handle_y1 = by0 + int(side * 0.06)

    # Symmetric inset from the bag's vertical centre line.
    inset = int(side * 0.06)
    left_h_x0 = cx - inset - handle_w
    left_h_x1 = cx - inset
    right_h_x0 = cx + inset
    right_h_x1 = cx + inset + handle_w

    draw = ImageDraw.Draw(canvas)

    # Handles first so the bag body covers their bottoms.
    for hx0, hx1 in [(left_h_x0, left_h_x1), (right_h_x0, right_h_x1)]:
        draw.arc(
            [hx0, handle_y0, hx1, handle_y1],
            start=180,
            end=360,
            fill=WHITE,
            width=handle_thickness,
        )

    # Rounded-rectangle body in front of handle bottoms.
    radius = int(side * 0.18)
    draw.rounded_rectangle(
        [bx0, by0, bx1, by1],
        radius=radius,
        fill=WHITE,
    )


def build_full_icon() -> None:
    """Solid square icon (iOS + Android legacy fallback)."""
    bg = make_gradient(SIZE).convert("RGBA")
    draw_bag(bg, scale=0.55, y_shift=30)
    bg.save(OUT_DIR / "icon.png", "PNG")


def build_foreground() -> None:
    """
    Adaptive foreground: bag only, transparent background.
    Android adaptive icons clip to a circle/squircle of the inner 66% of the
    image, so the bag is drawn smaller to stay safely inside the mask.
    """
    fg = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    draw_bag(fg, scale=0.42, y_shift=20)
    fg.save(OUT_DIR / "icon_foreground.png", "PNG")


def build_background() -> None:
    """Adaptive background: gradient only."""
    bg = make_gradient(SIZE)
    bg.save(OUT_DIR / "icon_background.png", "PNG")


if __name__ == "__main__":
    build_full_icon()
    build_foreground()
    build_background()
    for name in ("icon.png", "icon_foreground.png", "icon_background.png"):
        size = os.path.getsize(OUT_DIR / name)
        print(f"wrote {name} ({size // 1024} KB)")
