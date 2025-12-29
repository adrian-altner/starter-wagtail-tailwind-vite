import json
from functools import lru_cache
from pathlib import Path

from django import template
from django.conf import settings
from django.templatetags.static import static

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


@register.simple_tag
def vite_css(name):
    manifest = _load_manifest()
    entry = _find_entry(manifest, name)
    if not entry:
        return []
    return [static(css_file) for css_file in entry.get("css", [])]
