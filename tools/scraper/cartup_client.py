"""Polite HTTP client for Cartup's JSON API.

Authenticated via Bearer JWT + sxsrf header — both supplied via env vars
(never committed). Use:

    export CARTUP_TOKEN='eyJ...'
    export CARTUP_SXSRF='WlhsS2J...'
    export CARTUP_HASHKEY='d0cb38...'

Endpoint:
    GET https://api.cartup.com/product/api/v1/personalize-product/get-products
        ?currentPage=N&rowsPerPage=R&hashKey=...

Rate-limited to 1 req/s by default; retries 429/5xx with backoff.
"""
from __future__ import annotations

import logging
import os
import time
from typing import Any, Iterator, Optional

import requests
from tenacity import (
    retry,
    retry_if_exception_type,
    stop_after_attempt,
    wait_exponential,
)

LOG = logging.getLogger(__name__)

API_BASE = "https://api.cartup.com"
PRODUCTS_PATH = "/product/api/v1/personalize-product/get-products"

# Cartup serves images through an imrs.cartup.com resize proxy:
#   https://imrs.cartup.com/api/v1/image-resize
#       ?imageUrl=https://sl-dev-s3.s3.amazonaws.com/product/<filename>&width=<N>
IMAGE_PROXY = "https://imrs.cartup.com/api/v1/image-resize"
S3_PRODUCT_PREFIX = "https://sl-dev-s3.s3.amazonaws.com/product"
DEFAULT_IMAGE_WIDTH = 400


class RateLimitError(Exception):
    """Raised when the server asks us to slow down (429/5xx)."""


class CartupClient:
    def __init__(
        self,
        token: Optional[str] = None,
        sxsrf: Optional[str] = None,
        hashkey: Optional[str] = None,
        rate_limit_seconds: float = 1.0,
        timeout: int = 20,
    ) -> None:
        self.token = token or os.environ.get("CARTUP_TOKEN")
        self.sxsrf = sxsrf or os.environ.get("CARTUP_SXSRF")
        self.hashkey = hashkey or os.environ.get("CARTUP_HASHKEY")
        if not (self.token and self.sxsrf and self.hashkey):
            raise RuntimeError(
                "Missing Cartup credentials. Set CARTUP_TOKEN, CARTUP_SXSRF, "
                "and CARTUP_HASHKEY env vars (grab them from a logged-in "
                "browser session's DevTools → Network panel)."
            )
        self.rate_limit_seconds = rate_limit_seconds
        self.timeout = timeout
        self._last_request_at: float = 0.0
        self._session = requests.Session()
        self._session.headers.update(
            {
                "accept": "*/*",
                "accept-language": "en-US,en;q=0.9",
                "authorization": f"Bearer {self.token}",
                "origin": "https://cartup.com",
                "referer": "https://cartup.com/",
                "sxsrf": self.sxsrf,
                "user-agent": (
                    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                    "AppleWebKit/537.36 (KHTML, like Gecko) "
                    "Chrome/147.0.0.0 Safari/537.36"
                ),
            }
        )

    def _throttle(self) -> None:
        elapsed = time.monotonic() - self._last_request_at
        wait = self.rate_limit_seconds - elapsed
        if wait > 0:
            time.sleep(wait)
        self._last_request_at = time.monotonic()

    @retry(
        retry=retry_if_exception_type(
            (RateLimitError, requests.RequestException)
        ),
        wait=wait_exponential(multiplier=1, min=2, max=30),
        stop=stop_after_attempt(4),
        reraise=True,
    )
    def _get(self, path: str, params: dict) -> dict:
        self._throttle()
        url = f"{API_BASE}{path}"
        LOG.debug("GET %s %s", url, params)
        resp = self._session.get(url, params=params, timeout=self.timeout)
        if resp.status_code == 429 or resp.status_code >= 500:
            raise RateLimitError(f"{resp.status_code} on {url}")
        resp.raise_for_status()
        return resp.json()

    def fetch_page(self, page: int, per_page: int = 50) -> dict:
        return self._get(
            PRODUCTS_PATH,
            {
                "currentPage": page,
                "rowsPerPage": per_page,
                "hashKey": self.hashkey,
            },
        )

    def iter_products(
        self,
        max_products: int = 100,
        per_page: int = 50,
    ) -> Iterator[dict[str, Any]]:
        """Yield product dicts up to max_products, paginating as needed."""
        seen = 0
        page = 1
        total_pages: Optional[int] = None
        while seen < max_products:
            payload = self.fetch_page(page, per_page=per_page)
            data = payload.get("data") or {}
            page_info = data.get("pageInfo") or {}
            total_pages = page_info.get("totalPageCount", total_pages)
            items = data.get("items") or []
            for item in items:
                if seen >= max_products:
                    return
                yield item
                seen += 1
            if not page_info.get("hasNextPage"):
                return
            page += 1
            if total_pages and page > total_pages:
                return


def image_url(filename: str, width: int = DEFAULT_IMAGE_WIDTH) -> str:
    """Wrap a bare S3 filename in Cartup's image-resize proxy URL."""
    if not filename:
        return ""
    if filename.startswith("http"):
        return filename
    source = f"{S3_PRODUCT_PREFIX}/{filename}"
    return f"{IMAGE_PROXY}?imageUrl={source}&width={width}"
