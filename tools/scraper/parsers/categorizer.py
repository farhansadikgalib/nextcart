"""Infer one of the 14 canonical categories from a product name.

Cartup's `personalize-product` endpoint doesn't expose a category ID per
product, so we map by keyword. Rules are ordered: the first category
whose keyword list matches wins. Keep the most specific rules first
(e.g. "mother & baby" before "fashion", because "kids fashion" should
land in baby, not men's).
"""
from __future__ import annotations

import re
from typing import Sequence

from .category import CATEGORY_NAMES, canonical_categories

# (category_name, [keyword tokens])  — tokens are matched case-insensitively
# as whole words (word boundary either side).
_RULES: list[tuple[str, Sequence[str]]] = [
    (
        "Mother & Baby",
        [
            "baby", "babies", "infant", "newborn", "kids", "kid",
            "diaper", "nappy", "stroller", "pacifier", "feeding bottle",
            "cereal stage", "wipes",
        ],
    ),
    (
        "Phones & Accessories",
        [
            "phone case", "phone cover", "mobile case", "mobile cover",
            "back cover", "screen protector", "tempered glass",
            "phone holder", "mobile holder", "smartphone", "iphone",
            "android phone", "vivo", "oppo", "xiaomi", "redmi", "samsung galaxy",
        ],
    ),
    (
        "Electronic Accessories",
        [
            "earphone", "earbud", "earbuds", "headphone", "headset",
            "bluetooth", "tws", "speaker", "powerbank", "power bank",
            "charger", "cable", "usb", "adapter", "smartwatch",
            "ups", "router", "wifi", "wi-fi",
        ],
    ),
    (
        "Computer & Gaming",
        [
            "laptop", "keyboard", "mouse", "monitor", "ssd", "hdd",
            "graphics card", "gpu", "ram", "motherboard", "cpu",
            "gaming", "console", "controller", "joystick", "resistor",
            "capacitor", "module", "circuit", "arduino",
        ],
    ),
    (
        "TV & Home Appliances",
        [
            "tv ", " tv", "television", "fridge", "refrigerator",
            "air conditioner", "ac ", "microwave", "oven", "rice cooker",
            "washing machine", "iron", "fan", "blender", "mixer",
            "grinder", "kettle", "toaster", "vacuum",
            "ip camera", "cctv", "security camera",
        ],
    ),
    (
        "Home & Living",
        [
            "storage", "organizer", "wardrobe",
            "container", "bottle", "kitchen",
            "cookware", "cutlery", "plate", "bowl", "spoon", "fork",
            "knife set", "bedsheet", "pillow", "blanket", "curtain",
            "doormat", "rug", "carpet", "vase", "lamp", "candle",
            "broom", "cleaner", "dust", "floor", "rack",
        ],
    ),
    (
        "Groceries & Pet Supplies",
        [
            "rice", "flour", "oil", "ghee", "sugar", "salt", "tea",
            "coffee", "milk powder", "milk", "ketchup", "sauce",
            "noodle", "biscuit", "chips", "chocolate", "honey",
            "chia seed", "chia seeds", "almond", "cashew", "spice",
            "cat food", "dog food", "pet",
        ],
    ),
    (
        "Health & Beauty",
        [
            "face wash", "cleanser", "shampoo", "conditioner", "soap",
            "lotion", "moisturizer", "cream", "serum", "lipstick",
            "perfume", "body spray", "deodorant", "cologne", "fragrance",
            "vitamin", "supplement", "mask", "scrub", "toner",
        ],
    ),
    (
        "Sports & Outdoors",
        [
            "dumbbell", "yoga", "gym", "treadmill", "barbell", "fitness",
            "bicycle", "cycle", "helmet", "skipping rope", "football",
            "cricket bat", "racket", "tent", "camping",
        ],
    ),
    (
        "Automotives & Motorbikes",
        [
            "motorbike", "motorcycle", "bike helmet", "bike cover",
            "car cover", "car perfume", "car holder", "bike grip",
            "motor oil", "spark plug", "dc motor", "dc fan motor",
            "battery charger control", "auto",
        ],
    ),
    (
        "Watches & Bags",
        [
            "watch", "wristwatch", "casio", "rolex",
            "bag", "backpack", "wallet", "purse", "handbag",
            "sling bag", "tote", "luggage",
        ],
    ),
    (
        "Lifestyle & Hobbies",
        [
            "ring", "rings set", "necklace", "earring", "bracelet",
            "pendant", "jewellery", "jewelry", "chain", "anklet",
            "key ring", "keychain", "puzzle", "board game", "guitar",
            "ukulele", "piano",
        ],
    ),
    (
        "Women's Fashion",
        [
            "women", "ladies", "girls", "kurta", "kurti", "saree",
            "salwar", "frock", "dress for", "skirt", "blouse", "scarf",
        ],
    ),
    (
        "Men's Fashion",
        [
            "men ", " men", "men's", "mens ", "boy ", " boys",
            "shirt", "pant", "trousers", "panjabi", "punjabi",
            "polo", "t-shirt", "tshirt", "jacket", "hoodie",
            "blazer", "lungi", "slipper", "sandal", "shoe",
            "loafer", "belt", "cap ", "tie ",
        ],
    ),
]

_WORD_BOUNDARY = re.compile(r"\W+")


def _normalize(text: str) -> str:
    return " " + _WORD_BOUNDARY.sub(" ", text.lower()).strip() + " "


_PRECOMPILED = [
    (name, [(_normalize(k), k) for k in keywords]) for name, keywords in _RULES
]
_NAME_TO_ID = {c.name: c.id for c in canonical_categories()}
# Fallback if nothing matches — assigning to a generic catch-all keeps
# orphan products visible rather than dropping them.
_FALLBACK_NAME = "Lifestyle & Hobbies"


def category_for(name: str) -> tuple[str, str]:
    """Return (category_id, category_name) for a product name."""
    hay = _normalize(name)
    for cat_name, keywords in _PRECOMPILED:
        for needle, _ in keywords:
            if needle in hay:
                return _NAME_TO_ID[cat_name], cat_name
    return _NAME_TO_ID[_FALLBACK_NAME], _FALLBACK_NAME


def all_category_ids() -> list[str]:
    return [_NAME_TO_ID[n] for n in CATEGORY_NAMES]
