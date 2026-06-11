import json
import unittest

from libraries.SmartUiLibrary import SmartUiLibrary


class SmartUiLibraryTests(unittest.TestCase):
    def setUp(self):
        self.library = SmartUiLibrary()

    def test_generates_structured_test_ideas(self):
        result = self.library.generate_test_ideas_from_requirement(
            "Checkout requires first name, last name, and postal code before payment."
        )

        ideas = json.loads(result)

        self.assertIn("positive", ideas)
        self.assertIn("negative", ideas)
        self.assertIn("edge", ideas)
        self.assertEqual(2, len(ideas["positive"]))

    def test_suggests_data_test_locator_from_dom_snapshot(self):
        html = """
        <form>
            <input data-test="firstName" placeholder="First Name">
            <button id="continue">Continue</button>
        </form>
        """

        locator = self.library.suggest_locator_from_dom_snapshot(html, "first name")

        self.assertEqual('css=[data-test="firstName"]', locator)

    def test_unsupported_browser_raises_clear_error(self):
        with self.assertRaisesRegex(ValueError, "Unsupported browser"):
            self.library.build_browser_options("netscape", True)


if __name__ == "__main__":
    unittest.main()
