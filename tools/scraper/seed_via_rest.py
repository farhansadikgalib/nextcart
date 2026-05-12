"""Push data/*.json into Firestore via Google's Firestore REST API.

Works WITHOUT a service-account JSON when your Firestore database is in
test mode (default for new Firebase projects, 30-day window). Once rules
are deployed, switch to seed_from_file.py --upload firebase with proper
admin credentials.

Reads:
  data/category.list.json  →  /categories/{id}
  data/product.list.json   →  /products/{id}

Usage:
  python seed_via_rest.py \
    --project twinkle-237f4 \
    --api-key AIzaSyDoQiq-vVaUiilm_n63LDeMZmQunr8QoIA

The API key is the same one in lib/firebase_options.dart — public,
embedded in mobile apps. It's only useful in combination with the
project's rules, so it's not secret.
"""
from __future__ import annotations

import argparse
import json
import logging
import sys
import time
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any
from urllib.parse import urlencode

import requests

LOG = logging.getLogger(__name__)


# Fields the Flutter side casts as Firestore Timestamp. Strings under
# these keys are sent as timestampValue, not stringValue.
_TIMESTAMP_FIELDS = {"createdAt", "updatedAt", "addedAt"}


def to_firestore_value(value: Any, *, as_timestamp: bool = False) -> dict:
    """Encode a JSON value as a Firestore REST API typed value."""
    if value is None:
        return {"nullValue": None}
    if isinstance(value, bool):
        return {"booleanValue": value}
    if isinstance(value, int):
        return {"integerValue": str(value)}
    if isinstance(value, float):
        return {"doubleValue": value}
    if isinstance(value, str):
        if as_timestamp:
            return {"timestampValue": value}
        return {"stringValue": value}
    if isinstance(value, list):
        return {
            "arrayValue": {
                "values": [to_firestore_value(v) for v in value],
            }
        }
    if isinstance(value, dict):
        return {
            "mapValue": {
                "fields": {
                    k: to_firestore_value(
                        v, as_timestamp=(k in _TIMESTAMP_FIELDS)
                    )
                    for k, v in value.items()
                },
            }
        }
    raise TypeError(f"Unsupported value type: {type(value)}")


def to_firestore_doc(data: dict) -> dict:
    return {
        "fields": {
            k: to_firestore_value(v, as_timestamp=(k in _TIMESTAMP_FIELDS))
            for k, v in data.items()
        }
    }


class FirestoreRestClient:
    def __init__(self, project_id: str, api_key: str) -> None:
        self.project_id = project_id
        self.api_key = api_key
        self.session = requests.Session()
        self.base = (
            f"https://firestore.googleapis.com/v1/projects/{project_id}"
            f"/databases/(default)/documents"
        )

    def upsert(self, collection: str, doc_id: str, data: dict) -> None:
        # PATCH to .../documents/{collection}/{doc_id} performs an upsert
        # with full document replace. Mask omitted → replace all fields.
        url = f"{self.base}/{collection}/{doc_id}?{urlencode({'key': self.api_key})}"
        resp = self.session.patch(url, json=to_firestore_doc(data), timeout=30)
        if resp.status_code >= 400:
            raise RuntimeError(
                f"Firestore {resp.status_code} for {collection}/{doc_id}: "
                f"{resp.text[:300]}"
            )


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser()
    p.add_argument("--project", required=True)
    p.add_argument("--api-key", required=True)
    p.add_argument("--data-dir", default=None,
                   help="Defaults to repo /data folder")
    p.add_argument("--rate", type=float, default=0.05,
                   help="Seconds between writes (default: 50ms)")
    p.add_argument("--verbose", "-v", action="count", default=0)
    return p.parse_args()


def main() -> int:
    args = parse_args()
    logging.basicConfig(
        level=logging.WARNING - 10 * min(args.verbose, 2),
        format="%(asctime)s %(levelname)s %(name)s: %(message)s",
    )

    data_dir = (
        Path(args.data_dir)
        if args.data_dir
        else Path(__file__).resolve().parent.parent.parent / "data"
    )
    categories = json.loads((data_dir / "category.list.json").read_text())
    products = json.loads((data_dir / "product.list.json").read_text())

    client = FirestoreRestClient(args.project, args.api_key)

    print(f"Writing {len(categories)} categories…")
    for c in categories:
        client.upsert("categories", c["id"], c)
        time.sleep(args.rate)
    print("✓ categories done")

    print(f"Writing {len(products)} products…")
    # Spread createdAt across recent time so orderBy('createdAt') gives
    # a stable, distinct ordering (Firestore otherwise drops docs that
    # share an identical sort key in deterministic queries).
    now = datetime.now(timezone.utc)
    for i, p in enumerate(products):
        record = dict(p)
        stamp = (now - timedelta(minutes=i)).strftime(
            "%Y-%m-%dT%H:%M:%S.%fZ"
        )
        record["createdAt"] = stamp
        client.upsert("products", p["id"], record)
        time.sleep(args.rate)
    print("✓ products done")
    print(
        f"\nDone. Firestore now has {len(categories)} categories and "
        f"{len(products)} products in project {args.project!r}."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
