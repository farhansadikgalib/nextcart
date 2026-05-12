"""Seed Firestore (and optionally Firebase Storage) from RawProduct/Category."""
from __future__ import annotations

import io
import logging
import mimetypes
from pathlib import Path
from typing import Optional, Sequence
from urllib.parse import urlparse

import requests
from firebase_admin import credentials, firestore, initialize_app, storage

from parsers.category import Category
from parsers.product import RawProduct

LOG = logging.getLogger(__name__)


class FirebaseUploader:
    def __init__(
        self,
        bucket_name: Optional[str] = None,
        service_account_path: Optional[Path] = None,
    ) -> None:
        cred = (
            credentials.Certificate(str(service_account_path))
            if service_account_path
            else credentials.ApplicationDefault()
        )
        options: dict = {}
        if bucket_name:
            options["storageBucket"] = bucket_name
        try:
            initialize_app(cred, options)
        except ValueError:
            pass  # already initialised
        self._db = firestore.client()
        self._bucket = storage.bucket() if bucket_name else None

    # ── Categories ───────────────────────────────────────────────────

    def write_categories(self, categories: Sequence[Category]) -> None:
        batch = self._db.batch()
        col = self._db.collection("categories")
        for c in categories:
            ref = col.document(c.id)
            batch.set(ref, c.to_dict(), merge=True)
        batch.commit()
        LOG.info("Upserted %d categories", len(categories))

    # ── Products ─────────────────────────────────────────────────────

    def write_products(
        self,
        products: Sequence[RawProduct],
        rehost_images: bool = False,
    ) -> None:
        col = self._db.collection("products")
        for p in products:
            if rehost_images and self._bucket:
                images = [
                    self._upload_image(p.id, i, url)
                    for i, url in enumerate(p.images)
                ]
                images = [u for u in images if u]
            else:
                images = list(p.images)
            data = p.to_dict()
            data["images"] = images
            data["createdAt"] = firestore.SERVER_TIMESTAMP
            col.document(p.id).set(data, merge=True)
        LOG.info("Upserted %d products", len(products))

    # ── Image upload (optional) ──────────────────────────────────────

    def _upload_image(
        self,
        product_id: str,
        index: int,
        url: str,
    ) -> Optional[str]:
        if not url or not self._bucket:
            return url
        try:
            resp = requests.get(url, timeout=25)
            resp.raise_for_status()
        except Exception as exc:  # noqa: BLE001
            LOG.warning("Could not download %s: %s", url, exc)
            return None
        parsed = urlparse(url)
        suffix = Path(parsed.path).suffix or ".webp"
        blob_name = f"products/{product_id}/{index}{suffix}"
        blob = self._bucket.blob(blob_name)
        content_type = (
            resp.headers.get("Content-Type")
            or mimetypes.guess_type(blob_name)[0]
            or "image/webp"
        )
        blob.upload_from_file(
            io.BytesIO(resp.content), content_type=content_type
        )
        blob.make_public()
        return blob.public_url
