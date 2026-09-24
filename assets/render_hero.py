#!/usr/bin/env python
"""Render the Adversarial Gate hero image: a terminal frame with REAL text."""

from PIL import Image, ImageDraw, ImageFont
from PIL.ImageFilter import GaussianBlur

# ---------- palette ----------
BG        = (13, 20, 28)       # page background
CHROME    = (26, 43, 60)       # terminal body  #1a2b3c
CHROME_TP = (32, 51, 70)       # title bar
SHADOW    = (0, 0, 0)
TEXT      = (226, 232, 238)
DIM       = (138, 157, 173)
GREEN     = (61, 185, 138)
RED       = (224, 96, 87)
CRIMSON   = (192, 57, 43)      # #c0392b
TEAL      = (22, 160, 133)     # #16a085
BADGE_BG  = (38, 58, 78)

DOT_R, DOT_Y, DOT_G = (255, 95, 86), (255, 189, 46), (39, 201, 63)

# ---------- canvas ----------
W, H = 1600, 900
img = Image.new("RGB", (W, H), BG)
d = ImageDraw.Draw(img)

# terminal rect
TX, TY, TW, TH = 100, 78, W - 200, H - 156
R = 14

# soft shadow
sh = Image.new("RGBA", (W, H), (0, 0, 0, 0))
ImageDraw.Draw(sh).rounded_rectangle([TX + 6, TY + 14, TX + TW + 6, TY + TH + 14],
                                     radius=R, fill=(0, 0, 0, 110))
sh = sh.filter(GaussianBlur(22))
img = Image.alpha_composite(img.convert("RGBA"), sh).convert("RGB")
d = ImageDraw.Draw(img)

d.rounded_rectangle([TX, TY, TX + TW, TY + TH], radius=R, fill=CHROME)
d.rounded_rectangle([TX, TY, TX + TW, TY + 58], radius=R, fill=CHROME_TP)
d.rectangle([TX, TY + 44, TX + TW, TY + 58], fill=CHROME_TP)

# window dots
for i, c in enumerate((DOT_R, DOT_Y, DOT_G)):
    cx = TX + 30 + i * 26
    d.ellipse([cx - 8, TY + 21, cx + 8, TY + 37], fill=c)

# ---------- fonts ----------
MONO  = "/usr/share/fonts/liberation/LiberationMono-Regular.ttf"
MONOB = "/usr/share/fonts/liberation/LiberationMono-Bold.ttf"
f   = ImageFont.truetype(MONO, 27)
fb  = ImageFont.truetype(MONOB, 27)
fs  = ImageFont.truetype(MONO, 22)
fsb = ImageFont.truetype(MONOB, 24)

PAD = 52
x0 = TX + PAD
y = TY + 58 + 46
LH = 42

# ---------- badge: round 2 / 3 ----------
bt = "round 2 / 3"
bw = int(d.textlength(bt, font=fs)) + 32
bx1, by0 = TX + TW - PAD, TY + 58 + 40
d.rounded_rectangle([bx1 - bw, by0, bx1, by0 + 38], radius=8, fill=BADGE_BG)
d.text((bx1 - bw + 16, by0 + 8), bt, font=fs, fill=DIM)

# ---------- user line ----------
d.text((x0, y), "›", font=fb, fill=TEAL)
d.text((x0 + 30, y), "I don't think you need three agents. It's a CRUD app.",
       font=f, fill=TEXT)
y += LH + 28

# ---------- assistant intro ----------
d.text((x0, y), "Adversarial Gate:", font=fb, fill=TEAL)
d.text((x0 + int(d.textlength("Adversarial Gate:", font=fb)) + 12, y),
       "Partly agreed, and partly not.", font=f, fill=TEXT)
y += LH + 26

# ---------- the two verdict lines ----------
block_top = y - 10
bar_x = x0
GX = bar_x + 26          # glyph left edge
GW = 22                  # glyph box size


def draw_check(dr, gx, gy, col):
    """Hand-drawn check mark — font-independent."""
    dr.line([(gx + 2, gy + 11), (gx + 8, gy + 17), (gx + 20, gy + 3)],
            fill=col, width=4, joint="curve")


def draw_cross(dr, gx, gy, col):
    dr.line([(gx + 3, gy + 3), (gx + 18, gy + 18)], fill=col, width=4)
    dr.line([(gx + 18, gy + 3), (gx + 3, gy + 18)], fill=col, width=4)


lines = [
    ("check", "You're right about A1 — cutting it."),
    ("cross", "A2 stays. Remove it and the analysis"),
    (None,    "marks its own homework."),
]
for kind, txt in lines:
    gy = y + 5
    if kind == "check":
        draw_check(d, GX, gy, GREEN)
    elif kind == "cross":
        draw_cross(d, GX, gy, RED)
    d.text((bar_x + 66, y), txt, font=f, fill=TEXT)
    y += LH
d.rectangle([bar_x, block_top, bar_x + 5, y - 8], fill=TEAL)

y += 22
d.text((x0, y), "Revised: 2 agents, ~18k typical / ~29k worst case.",
       font=f, fill=DIM)
y += LH

# ---------- crimson gate bar ----------
by = y + 34
d.rectangle([TX + PAD, by, TX + TW - PAD, by + 56], fill=CRIMSON)
d.text((TX + PAD + 24, by + 14),
       "GATE — nothing proceeds without your approval",
       font=fsb, fill=(255, 245, 243))

# ---------- crop terminal to hug content ----------
new_th = (by + 56) - TY + 46          # bottom of gate bar + breathing room
out_h = new_th + 2 * TY               # equal margin top/bottom
final = Image.new("RGB", (W, out_h), BG)

# shadow for the resized frame
sh2 = Image.new("RGBA", (W, out_h), (0, 0, 0, 0))
ImageDraw.Draw(sh2).rounded_rectangle(
    [TX + 6, TY + 14, TX + TW + 6, TY + new_th + 14], radius=R, fill=(0, 0, 0, 110))
sh2 = sh2.filter(GaussianBlur(22))
final = Image.alpha_composite(final.convert("RGBA"), sh2).convert("RGB")

body = img.crop((TX, TY, TX + TW, TY + new_th))
mask = Image.new("L", (TW, new_th), 0)
ImageDraw.Draw(mask).rounded_rectangle([0, 0, TW - 1, new_th - 1], radius=R, fill=255)
final.paste(body, (TX, TY), mask)

final.save("/mnt/user-data/outputs/adversarial-gate/docs/hero-contradictory-review.png",
           "PNG", optimize=True)
print("saved")
