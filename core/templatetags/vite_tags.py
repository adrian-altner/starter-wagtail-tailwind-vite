import json
from functools import lru_cache
from pathlib import Path

from django import template
from django.conf import settings

register = template.Library()


@lru_cache(maxsize=1)
def _load_manifest():
    manifest_path = Path(settings.BASE_DIR) / "core" / "static" / "manifest.json"
    if not manifest_path.exists():
        return {}
    with manifest_path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def _find_entry(manifest, name):
    if name in manifest:
        return manifest[name]
    for key in (f"assets/{name}.js", f"assets/{name}.ts"):
        if key in manifest:
            return manifest[key]
    for entry in manifest.values():
        if entry.get("isEntry") and entry.get("name") == name:
            return entry
    return None


def _static_url(path):
    return f"{settings.STATIC_URL.rstrip('/')}/{path.lstrip('/')}"


@register.simple_tag
def vite_css(name):
    manifest = _load_manifest()
    entry = _find_entry(manifest, name)
    if not entry:
        return []
    css_files = entry.get("css", [])
    if css_files:
        return [_static_url(css_file) for css_file in css_files]
    entry_file = entry.get("file", "")
    if entry_file.endswith(".css"):
        return [_static_url(entry_file)]
    return []
