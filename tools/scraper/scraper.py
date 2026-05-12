"""Fetch products from Cartup's API, categorise them, and seed Firestore.

Required env vars (grab from a logged-in Cartup browser session's
DevTools → Network panel; tokens expire ~30 days):

    CARTUP_TOKEN     Bearer JWT (sl_customer)
    CARTUP_SXSRF     sxsrf base64 header
    CARTUP_HASHKEY   the hashKey query param

For Firestore upload (optional):

    GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json

Usage:

    # Just dump JSON to ../../data/ (no auth to Firebase needed)
    python scraper.py --max-products 120 --dump json

    # Dump JSON + upload to Firestore
    python scraper.py --max-products 120 --dump json --upload firebase \
        --bucket twinkle-237f4.firebasestorage.app

For development seeding only.
"""
from __future__ import annotations

import argparse
import logging
import os
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(SCRIPT_DIR))

from cartup_client import CartupClient  # noqa: E402
from parsers import canonical_categories, parse_many  # noqa: E402
from parsers.categorizer import category_for  # noqa: E402
from pipelines.json_dump import dump_categories, dump_products  # noqa: E402

REPO_ROOT = SCRIPT_DIR.parent.parent
DATA_DIR = REPO_ROOT / "data"

LOG_FORMAT = "%(asctime)s %(levelname)s %(name)s: %(message)s"


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Cartup → NextCart seeder")
    p.add_argument("--max-products", type=int, default=120,
                   help="cap total products fetched (default 120)")
    p.add_argument("--per-page", type=int, default=50)
    p.add_argument("--image-width", type=int, default=600,
                   help="width hint for Cartup's image-resize proxy")
    p.add_argument("--upload", choices=("firebase", "none"), default="none")
    p.add_argument("--dump", choices=("json", "none"), default="json")
    p.add_argument("--bucket", default=None,
                   help="Firebase Storage bucket name (only if uploading)")
    p.add_argument("--service-account", default=None)
    p.add_argument("--rehost-images", action="store_true",
                   help="download images and re-upload them to Firebase "
                        "Storage (default: keep Cartup CDN URLs)")
    p.add_argument("--verbose", "-v", action="count", default=0)
    return p.parse_args()


def configure_logging(verbose: int) -> None:
    level = logging.WARNING - 10 * min(verbose, 2)
    logging.basicConfig(level=level, format=LOG_FORMAT)


def main() -> int:
    args = parse_args()
    configure_logging(args.verbose)

    client = CartupClient()
    items = list(
        client.iter_products(
            max_products=args.max_products, per_page=args.per_page
        )
    )
    products = parse_many(items, image_width=args.image_width)
    if not products:
        logging.error("No products parsed — nothing to do.")
        return 1

    # Bucket assignments and stats
    by_cat: dict[str, int] = {}
    for p in products:
        by_cat[p.category_id] = by_cat.get(p.category_id, 0) + 1
    logging.info("Category distribution: %s", by_cat)

    categories = canonical_categories()
    # Pick a representative thumbnail per category from the products we have
    cat_thumb: dict[str, str] = {}
    for p in products:
        if p.images and p.category_id not in cat_thumb:
            cat_thumb[p.category_id] = p.images[0]
    for c in categories:
        if c.id in cat_thumb:
            c.image = cat_thumb[c.id]

    if args.dump == "json":
        DATA_DIR.mkdir(parents=True, exist_ok=True)
        dump_categories(categories, DATA_DIR / "category.json")
        dump_products(products, DATA_DIR / "product.json")
        logging.info("JSON written to %s", DATA_DIR)

    if args.upload == "firebase":
        from pipelines.firebase import FirebaseUploader  # local import

        service_account = args.service_account or os.environ.get(
            "GOOGLE_APPLICATION_CREDENTIALS"
        )
        if not service_account:
            logging.error(
                "Set --service-account or GOOGLE_APPLICATION_CREDENTIALS "
                "to upload to Firestore."
            )
            return 2
        uploader = FirebaseUploader(
            bucket_name=args.bucket if args.rehost_images else None,
            service_account_path=Path(service_account),
        )
        uploader.write_categories(categories)
        uploader.write_products(products, rehost_images=args.rehost_images)
        logging.info(
            "Uploaded %d categories and %d products to Firestore.",
            len(categories),
            len(products),
        )

    print(
        f"Done. {len(products)} products across "
        f"{len({p.category_id for p in products})} categories."
    )
    # Quick category-name sanity table
    name_by_id = {c.id: c.name for c in categories}
    for cid, n in sorted(by_cat.items(), key=lambda kv: -kv[1]):
        print(f"  {n:>3}  {name_by_id.get(cid, cid)}")
    # Spot-check a categorisation
    if products:
        sample = products[0]
        _, cname = category_for(sample.title)
        print(f"\nSample mapping: {sample.title!r} → {cname}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
