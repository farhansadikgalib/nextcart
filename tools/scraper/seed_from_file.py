"""Transform a saved Cartup API response → data/*.json (+ optional Firestore).

Reads `sample_response.json` (or any path passed via --input), runs the
items through the same parser + categoriser the live scraper uses, and
writes the result to data/. Optionally uploads to Cloud Firestore.

Usage:

    python seed_from_file.py                       # JSON dump only
    python seed_from_file.py --upload firebase \
        --service-account /path/to/service-account.json
"""
from __future__ import annotations

import argparse
import json
import logging
import os
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(SCRIPT_DIR))

from parsers import canonical_categories, parse_many  # noqa: E402
from pipelines.json_dump import dump_categories, dump_products  # noqa: E402

REPO_ROOT = SCRIPT_DIR.parent.parent
DATA_DIR = REPO_ROOT / "data"
DEFAULT_INPUT = SCRIPT_DIR / "sample_response.json"


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser()
    p.add_argument("--input", default=str(DEFAULT_INPUT),
                   help="Path to a saved Cartup API response JSON")
    p.add_argument("--image-width", type=int, default=600)
    p.add_argument("--upload", choices=("firebase", "none"), default="none")
    p.add_argument("--dump", choices=("json", "none"), default="json")
    p.add_argument("--bucket", default=None)
    p.add_argument("--service-account", default=None)
    p.add_argument("--rehost-images", action="store_true")
    p.add_argument("--verbose", "-v", action="count", default=0)
    return p.parse_args()


def main() -> int:
    args = parse_args()
    logging.basicConfig(
        level=logging.WARNING - 10 * min(args.verbose, 2),
        format="%(asctime)s %(levelname)s %(name)s: %(message)s",
    )

    raw = json.loads(Path(args.input).read_text())
    items = ((raw.get("data") or {}).get("items")) or []
    if not items:
        logging.error("No items in %s", args.input)
        return 1
    products = parse_many(items, image_width=args.image_width)
    if not products:
        logging.error("Parser returned 0 products")
        return 1

    by_cat: dict[str, int] = {}
    for p in products:
        by_cat[p.category_id] = by_cat.get(p.category_id, 0) + 1

    categories = canonical_categories()
    # Backfill category thumbnails from a representative product
    thumb: dict[str, str] = {}
    for p in products:
        if p.images and p.category_id not in thumb:
            thumb[p.category_id] = p.images[0]
    for c in categories:
        if c.id in thumb:
            c.image = thumb[c.id]

    if args.dump == "json":
        DATA_DIR.mkdir(parents=True, exist_ok=True)
        dump_categories(categories, DATA_DIR / "category.json")
        dump_products(products, DATA_DIR / "product.json")

    if args.upload == "firebase":
        from pipelines.firebase import FirebaseUploader

        cred = args.service_account or os.environ.get(
            "GOOGLE_APPLICATION_CREDENTIALS"
        )
        if not cred:
            logging.error(
                "Set --service-account or GOOGLE_APPLICATION_CREDENTIALS"
            )
            return 2
        uploader = FirebaseUploader(
            bucket_name=args.bucket if args.rehost_images else None,
            service_account_path=Path(cred),
        )
        uploader.write_categories(categories)
        uploader.write_products(products, rehost_images=args.rehost_images)
        print(
            f"Uploaded {len(categories)} categories and "
            f"{len(products)} products to Firestore."
        )

    name_by_id = {c.id: c.name for c in categories}
    print(f"\n{len(products)} products parsed.\n")
    print("Category distribution:")
    for cid, n in sorted(by_cat.items(), key=lambda kv: -kv[1]):
        print(f"  {n:>3}  {name_by_id.get(cid, cid)}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
