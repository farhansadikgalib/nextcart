"""Map Cartup API product records → NextCart's schema."""
from __future__ import annotations

import logging
from dataclasses import dataclass, field
from typing import List, Optional

from cartup_client import image_url

from .categorizer import category_for

LOG = logging.getLogger(__name__)


@dataclass
class RawProduct:
    id: str
    title: str
    description: str
    price: float
    original_price: float
    discount_percent: int
    images: List[str] = field(default_factory=list)
    category_id: str = ""
    stock: int = 0
    source_url: Optional[str] = None

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "price": self.price,
            "originalPrice": self.original_price,
            "discountPercent": self.discount_percent,
            "images": self.images,
            "categoryId": self.category_id,
            "stock": self.stock,
            "sourceUrl": self.source_url,
        }


def _doc_id(api: dict) -> str:
    raw = api.get("id")
    if raw is None:
        slug = api.get("slug") or ""
        return slug[:80] or "unknown"
    return f"cartup_{raw}"


def _description(api: dict) -> str:
    """Cartup's list endpoint doesn't return descriptions. Synthesise a
    short stand-in from the name so the detail page isn't empty."""
    name = api.get("name") or ""
    discount = api.get("discountPercentage") or 0
    parts = [f"{name}."]
    if discount and discount >= 5:
        parts.append(f"Save {int(discount)}% today.")
    parts.append("Cash on Delivery available. Genuine product, fast shipping.")
    return " ".join(parts)


def from_api(api: dict, image_width: int = 600) -> Optional[RawProduct]:
    name = (api.get("name") or "").strip()
    if not name:
        return None

    discounted = api.get("discountedPrice")
    listed = api.get("price")
    if discounted is None and listed is None:
        return None
    price = float(discounted if discounted is not None else listed)
    original = float(listed if listed is not None else discounted)
    if original < price:
        original = price
    discount_pct = int(api.get("discountPercentage") or 0)

    raw_images = api.get("images") or []
    thumb = api.get("thumbnail")
    if thumb and thumb not in raw_images:
        raw_images = [thumb, *raw_images]
    images = [image_url(f, width=image_width) for f in raw_images if f]
    # Dedupe, keep order
    seen = set()
    images = [i for i in images if not (i in seen or seen.add(i))]

    stock = int(api.get("currentStockQty") or 0)
    slug = api.get("slug") or ""

    cat_id, _ = category_for(name)

    return RawProduct(
        id=_doc_id(api),
        title=name,
        description=_description(api),
        price=price,
        original_price=original,
        discount_percent=discount_pct,
        images=images,
        category_id=cat_id,
        stock=stock,
        source_url=f"https://cartup.com/p/{slug}" if slug else None,
    )


def parse_many(items: list[dict], image_width: int = 600) -> list[RawProduct]:
    products: list[RawProduct] = []
    for item in items:
        rp = from_api(item, image_width=image_width)
        if rp is not None:
            products.append(rp)
    LOG.info("Parsed %d / %d items into products", len(products), len(items))
    return products
