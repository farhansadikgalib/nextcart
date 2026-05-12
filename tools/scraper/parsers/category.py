"""Category parser.

The 14 top-level categories specified in the project README. We hard-code
the slug list because Cartup's HTML for the homepage may shift; the
14 names are part of the product spec, not derived data.
"""
from __future__ import annotations

from dataclasses import dataclass
from typing import List, Optional

from slugify import slugify


@dataclass
class Category:
    id: str
    name: str
    icon: Optional[str]
    image: Optional[str]
    order: int

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "name": self.name,
            "icon": self.icon,
            "image": self.image,
            "order": self.order,
        }


# Canonical category names from the README master prompt.
CATEGORY_NAMES: List[str] = [
    "Men's Fashion",
    "Computer & Gaming",
    "Home & Living",
    "Groceries & Pet Supplies",
    "Health & Beauty",
    "Women's Fashion",
    "TV & Home Appliances",
    "Lifestyle & Hobbies",
    "Electronic Accessories",
    "Watches & Bags",
    "Sports & Outdoors",
    "Mother & Baby",
    "Automotives & Motorbikes",
    "Phones & Accessories",
]


def canonical_categories() -> List[Category]:
    """Return the 14 canonical categories with stable IDs."""
    return [
        Category(
            id=slugify(name, separator="_"),
            name=name,
            icon=None,
            image=None,
            order=i,
        )
        for i, name in enumerate(CATEGORY_NAMES)
    ]


def discover_category_urls(soup) -> dict[str, str]:
    """Best-effort: pair canonical names with anchor URLs in the homepage.

    Returns {category_id: url}. Falls back to an empty dict if Cartup's
    HTML doesn't match. The scraper degrades gracefully — without URLs
    it can still emit the categories (with image=None) so the Flutter
    catalogue has structure.
    """
    by_id: dict[str, str] = {}
    if soup is None:
        return by_id
    canonical = {c.name.lower(): c.id for c in canonical_categories()}
    for a in soup.select("a[href]"):
        text = a.get_text(strip=True)
        if not text:
            continue
        cid = canonical.get(text.lower())
        if cid and cid not in by_id:
            href = a["href"]
            by_id[cid] = href
    return by_id
