"""Custom Robot Framework library for smarter UI automation utilities."""

from __future__ import annotations

import difflib
import json
import re
from dataclasses import dataclass
from html.parser import HTMLParser
from pathlib import Path
from typing import Any

try:
    from PIL import Image
except ImportError:  # pragma: no cover - exercised only when optional dependency is missing
    Image = None


@dataclass(frozen=True)
class ElementCandidate:
    tag: str
    attrs: dict[str, str]
    text: str

    @property
    def description(self) -> str:
        values = [self.tag, self.text]
        values.extend(self.attrs.get(name, "") for name in ("id", "name", "data-test", "aria-label"))
        values.extend(self.attrs.get(name, "") for name in ("placeholder", "value", "class"))
        return " ".join(value for value in values if value)


class _DomCandidateParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self._stack: list[ElementCandidate] = []
        self.candidates: list[ElementCandidate] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        interesting_tags = {"a", "button", "input", "select", "textarea", "label"}
        void_tags = {"input"}
        attributes = {name: value or "" for name, value in attrs}
        if tag in interesting_tags or any(name in attributes for name in ("id", "data-test", "aria-label")):
            candidate = ElementCandidate(tag=tag, attrs=attributes, text="")
            if tag in void_tags:
                self.candidates.append(candidate)
            else:
                self._stack.append(candidate)

    def handle_data(self, data: str) -> None:
        if self._stack:
            current = self._stack[-1]
            text = " ".join([current.text, data.strip()]).strip()
            self._stack[-1] = ElementCandidate(tag=current.tag, attrs=current.attrs, text=text)

    def handle_endtag(self, tag: str) -> None:
        if self._stack and self._stack[-1].tag == tag:
            self.candidates.append(self._stack.pop())


class SmartUiLibrary:
    """Robot keywords for resilient UI tests and test-design assistance."""

    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def build_browser_options(self, browser: str = "chrome", headless: str | bool = True) -> Any:
        """Return Selenium browser options configured for reliable local/CI execution."""
        normalized_browser = str(browser).lower()
        enabled_headless = self._as_bool(headless)

        if normalized_browser in {"chrome", "googlechrome"}:
            from selenium.webdriver import ChromeOptions

            options = ChromeOptions()
            if enabled_headless:
                options.add_argument("--headless=new")
            options.add_argument("--disable-dev-shm-usage")
            options.add_argument("--no-sandbox")
            options.add_argument("--window-size=1440,1000")
            return options

        if normalized_browser in {"edge", "msedge"}:
            from selenium.webdriver import EdgeOptions

            options = EdgeOptions()
            if enabled_headless:
                options.add_argument("--headless=new")
            options.add_argument("--window-size=1440,1000")
            return options

        if normalized_browser == "firefox":
            from selenium.webdriver import FirefoxOptions

            options = FirefoxOptions()
            if enabled_headless:
                options.add_argument("-headless")
            return options

        raise ValueError(f"Unsupported browser: {browser}")

    def generate_test_ideas_from_requirement(self, requirement: str) -> str:
        """Generate deterministic positive, negative, and edge-case ideas from a requirement."""
        normalized = self._normalize(requirement)
        nouns = self._keywords(normalized)
        subject = nouns[0] if nouns else "feature"

        ideas = {
            "requirement": requirement,
            "positive": [
                f"Verify {subject} works when all required information is valid.",
                f"Verify confirmation or success feedback appears after completing {subject}.",
            ],
            "negative": [
                f"Verify {subject} rejects missing required values.",
                f"Verify {subject} rejects malformed or unauthorized input.",
            ],
            "edge": [
                f"Verify {subject} handles leading/trailing spaces consistently.",
                f"Verify {subject} remains usable after refresh or retry.",
            ],
            "suggested_tags": sorted(set(["ai-assisted", subject.replace(" ", "-")])),
        }
        return json.dumps(ideas, indent=2)

    def suggest_locator_from_dom_snapshot(self, html: str, target: str) -> str:
        """Suggest a resilient CSS locator by comparing target wording with parsed DOM candidates."""
        parser = _DomCandidateParser()
        parser.feed(html)

        if not parser.candidates:
            raise AssertionError("No interactive or locatable elements found in DOM snapshot.")

        target_text = self._normalize(target)
        ranked = sorted(
            parser.candidates,
            key=lambda candidate: difflib.SequenceMatcher(
                None, target_text, self._normalize(candidate.description)
            ).ratio(),
            reverse=True,
        )
        best = ranked[0]
        return self._locator_for(best)

    def calculate_visual_similarity(self, baseline_path: str, actual_path: str) -> float:
        """Return a perceptual-hash similarity score between two images from 0.0 to 1.0."""
        if Image is None:
            raise ImportError("Pillow is required for visual similarity checks.")

        baseline_hash = self._average_hash(Path(baseline_path))
        actual_hash = self._average_hash(Path(actual_path))
        matching_bits = sum(left == right for left, right in zip(baseline_hash, actual_hash))
        return round(matching_bits / len(baseline_hash), 4)

    def require_minimum_visual_similarity(
        self, baseline_path: str, actual_path: str, minimum_score: float = 0.95
    ) -> None:
        """Fail when two screenshots do not meet the minimum similarity threshold."""
        score = self.calculate_visual_similarity(baseline_path, actual_path)
        if score < float(minimum_score):
            raise AssertionError(
                f"Visual similarity {score:.4f} was below required threshold {float(minimum_score):.4f}"
            )

    @staticmethod
    def _locator_for(candidate: ElementCandidate) -> str:
        attrs = candidate.attrs
        for attr in ("data-test", "id", "name", "aria-label", "placeholder"):
            if attrs.get(attr):
                return f'css=[{attr}="{attrs[attr]}"]'
        if candidate.text:
            return f"xpath=//{candidate.tag}[normalize-space()='{candidate.text}']"
        return candidate.tag

    @staticmethod
    def _average_hash(image_path: Path, size: int = 8) -> str:
        with Image.open(image_path) as image:
            pixels = list(image.convert("L").resize((size, size)).getdata())
        average = sum(pixels) / len(pixels)
        return "".join("1" if pixel >= average else "0" for pixel in pixels)

    @staticmethod
    def _normalize(text: str) -> str:
        return re.sub(r"\s+", " ", re.sub(r"[^a-zA-Z0-9]+", " ", text)).strip().lower()

    @staticmethod
    def _keywords(text: str) -> list[str]:
        stop_words = {
            "a",
            "an",
            "and",
            "are",
            "be",
            "before",
            "for",
            "from",
            "is",
            "of",
            "or",
            "requires",
            "should",
            "the",
            "to",
            "when",
            "with",
        }
        return [word for word in text.split() if word not in stop_words and len(word) > 2]

    @staticmethod
    def _as_bool(value: str | bool) -> bool:
        if isinstance(value, bool):
            return value
        return str(value).strip().lower() in {"1", "yes", "true", "on"}
