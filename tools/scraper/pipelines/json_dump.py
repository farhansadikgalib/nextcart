"""Write categories and products to /data/*.json for riv generate model."""
from __future__ import annotations

import json
import logging
from pathlib import Path
from typing import Sequence

from parsers.category import Category
from parsers.product import RawProduct

LOG = logging.getLogger(__name__)


def _atomic_write(path: Path, payload: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(path.suffix + ".tmp")
    tmp.write_text(json.dumps(payload, indent=2, ensure_ascii=False))
    tmp.replace(path)


def dump_categories(
    categories: Sequence[Category],
    out_path: Path,
) -> None:
    """Write a single representative category (for riv generate model)
    plus the full list at <out_path>.list.json for reference."""
    data = [c.to_dict() for c in categories]
    if data:
        _atomic_write(out_path, data[0])
        _atomic_write(out_path.with_suffix(".list.json"), data)
        LOG.info("Wrote %d categories to %s", len(data), out_path)


def dump_products(
    products: Sequence[RawProduct],
    out_path: Path,
) -> None:
    data = [p.to_dict() for p in products]
    if data:
        _atomic_write(out_path, data[0])
        _atomic_write(out_path.with_suffix(".list.json"), data)
        LOG.info("Wrote %d products to %s", len(data), out_path)
