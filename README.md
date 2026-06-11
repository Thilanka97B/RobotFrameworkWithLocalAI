# RobotFrameworkWithAI

UI automation framework for [SauceDemo](https://www.saucedemo.com/) using Robot Framework, Python, and Selenium.

The project demonstrates maintainable keyword-driven tests, reusable page resources, environment-based configuration, a Python custom library, and a lightweight AI-inspired utility for generating test ideas and suggesting resilient locators from DOM snippets.

## Tech Stack

- Robot Framework
- Python 3.10+
- SeleniumLibrary / Selenium WebDriver
- Custom Python library for visual/NLP-style QA utilities
- unittest for fast custom-library checks

## Project Structure

```text
.
├── config/
│   └── environments.robot
├── libraries/
│   └── SmartUiLibrary.py
├── resources/
│   ├── common.resource
│   └── pages/
│       ├── cart_page.resource
│       ├── checkout_page.resource
│       ├── inventory_page.resource
│       └── login_page.resource
├── tests/
│   ├── ui/
│   │   ├── checkout.robot
│   │   ├── inventory.robot
│   │   └── login.robot
│   └── unit/
│       └── test_smart_ui_library.py
├── .gitignore
├── pyproject.toml
└── requirements.txt
```

## Setup

Create and activate a virtual environment:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt
```

Chrome is the default browser. Selenium Manager will resolve the browser driver automatically when Selenium starts the test.

## Running Tests

Run all UI tests headlessly:

```powershell
robot -d results tests/ui
```

Run a specific suite:

```powershell
robot -d results tests/ui/login.robot
```

Run with a visible browser:

```powershell
robot -d results -v HEADLESS:false tests/ui
```

Run against another browser:

```powershell
robot -d results -v BROWSER:edge tests/ui
```

Run the custom library unit tests:

```powershell
python -m unittest discover -s tests/unit
```

Run the AI-style custom tool demonstration:

```powershell
robot -d results tests/ai
```

## Test Coverage

The UI test suites cover:

- Valid login and invalid login messaging
- Locked-out user edge case
- Inventory sorting from low to high price
- Cart add/remove behavior
- End-to-end checkout flow
- Required checkout information validation

## Custom Library Highlights

`libraries/SmartUiLibrary.py` exposes reusable Robot keywords:

- `Generate Test Ideas From Requirement`
  - Converts a natural-language requirement into structured positive, negative, and edge-case test ideas.
- `Suggest Locator From Dom Snapshot`
  - Parses HTML and ranks candidate selectors by semantic similarity to a target phrase.
- `Calculate Visual Similarity`
  - Compares two screenshots using perceptual hashing, useful for lightweight visual validation.
- `Require Minimum Visual Similarity`
  - Fails a test if screenshot similarity falls below a threshold.

These utilities are intentionally deterministic and offline-friendly, which keeps CI runs stable while still demonstrating how AI/NLP-style assistance can enhance test design and locator maintenance.

## Example AI Utility Usage

```robot
*** Settings ***
Library    ../../libraries/SmartUiLibrary.py

*** Test Cases ***
Generate Checkout Test Ideas
    ${ideas}=    Generate Test Ideas From Requirement
    ...    Checkout requires first name, last name, and postal code before payment.
    Log    ${ideas}
```

## Notes For Reviewers

- Credentials are public SauceDemo training credentials: `standard_user`, `locked_out_user`, and password `secret_sauce`.
- Tests isolate page-level behavior into resource files to keep suite files concise.
- The framework avoids hard sleeps and uses explicit wait keywords around browser interactions.
- Reports are written to `results/`, which is ignored by Git.
