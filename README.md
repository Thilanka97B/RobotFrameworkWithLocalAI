# RobotFrameworkWithAI

UI automation framework for [SauceDemo](https://www.saucedemo.com/) using Robot Framework, Python, Selenium, and a local AI failure analyzer powered by Ollama/Qwen.

The project demonstrates maintainable keyword-driven tests, reusable page resources, custom Python libraries, unit tests for framework utilities, and AI-assisted debugging when automation execution fails.

## Tech Stack

- Robot Framework
- Python 3.10+
- SeleniumLibrary / Selenium WebDriver
- Python custom libraries
- Ollama with `qwen2.5:1.5b` for local AI failure analysis
- unittest for fast custom-library checks

## Project Structure

```text
.
|-- config/
|   `-- environments.robot
|-- libraries/
|   |-- __init__.py
|   |-- AIAnalyzer.py
|   `-- SmartUiLibrary.py
|-- resources/
|   |-- common.resource
|   `-- pages/
|       |-- cart_page.resource
|       |-- checkout_page.resource
|       |-- inventory_page.resource
|       `-- login_page.resource
|-- tests/
|   |-- ai/
|   |   `-- smart_ui_tools.robot
|   |-- ui/
|   |   |-- checkout.robot
|   |   |-- inventory.robot
|   |   |-- login.robot
|   |   `-- order.args
|   `-- unit/
|       `-- test_smart_ui_library.py
|-- pyproject.toml
|-- requirements.txt
`-- README.md
```

## Setup

Create the virtual environment and install dependencies:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt
```

If activation is unavailable, run commands through the venv Python directly:

```powershell
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

Chrome is the default browser. Selenium Manager is used to resolve the browser driver.

## Local AI Setup

Install and run Ollama, then pull the Qwen model:

```powershell
& "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe" serve
```

In another terminal:

```powershell
& "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe" pull qwen2.5:1.5b
```

If `ollama` is already in PATH, these commands can be shortened:

```powershell
ollama serve
ollama pull qwen2.5:1.5b
```

## Running Tests

Run all UI tests in the required order:

```powershell
.\.venv\Scripts\python.exe -m robot -d results -A tests/ui/order.args
```

Execution order:

```text
1. tests/ui/login.robot
2. tests/ui/inventory.robot
3. tests/ui/checkout.robot
```

Run a specific UI suite:

```powershell
.\.venv\Scripts\python.exe -m robot -d results tests/ui/login.robot
```

Run with visible browser:

```powershell
.\.venv\Scripts\python.exe -m robot -d results -v HEADLESS:false -A tests/ui/order.args
```

Run against Edge:

```powershell
.\.venv\Scripts\python.exe -m robot -d results -v BROWSER:edge -A tests/ui/order.args
```

Run the AI/helper keyword demo:

```powershell
.\.venv\Scripts\python.exe -m robot -d results tests/ai
```

Run Python unit tests:

```powershell
.\.venv\Scripts\python.exe -m unittest discover -s tests/unit
```

Run a dry run without launching the browser:

```powershell
.\.venv\Scripts\python.exe -m robot --dryrun -d results-dryrun -A tests/ui/order.args
```

## Reports

Robot writes execution output to:

```text
results/output.xml
results/log.html
results/report.html
```

Use `results/log.html` for detailed keyword logs, screenshots, and AI analyzer responses.

`results-dryrun/` is only used for dry-run validation and can be deleted anytime.

## AI Failure Analyzer

`libraries/AIAnalyzer.py` sends Robot failure messages to local Ollama:

```text
http://localhost:11434/api/generate
```

Model:

```text
qwen2.5:1.5b
```

When a test fails, the framework automatically:

1. Captures the Robot failure message.
2. Sends it to local Ollama.
3. Prints the AI response in the terminal.
4. Logs the response in `results/log.html`.

The response includes:

- Root cause
- Fix suggestion
- Severity

If a test passes, the console/log shows a success message instead.

The AI analyzer is wired through `resources/common.resource` using test and suite teardown keywords. Suite-level analysis is included so setup failures, such as browser driver issues, are also analyzed.

## Resource Files

The `.resource` files keep test cases clean and reusable:

- `resources/common.resource`
  - browser setup and teardown
  - SeleniumLibrary import
  - custom library imports
  - AI failure analyzer teardown logic
- `resources/pages/login_page.resource`
  - login actions and assertions
- `resources/pages/inventory_page.resource`
  - inventory, sorting, and cart badge keywords
- `resources/pages/cart_page.resource`
  - cart page actions and assertions
- `resources/pages/checkout_page.resource`
  - checkout actions and assertions

This keeps `.robot` test files focused on business scenarios instead of low-level Selenium details.

## Custom Libraries

`libraries/SmartUiLibrary.py` provides custom Robot keywords for:

- browser option setup
- disabling Chrome/Edge password-manager and notification popups
- generating test ideas from requirement text
- suggesting locators from DOM snippets
- comparing screenshots with visual similarity helpers

`libraries/AIAnalyzer.py` provides:

- `Analyze Failure`
- local Ollama/Qwen failure analysis
- graceful handling when Ollama is unavailable

`libraries/__init__.py` marks the folder as a Python package. This supports imports such as:

```python
from libraries.SmartUiLibrary import SmartUiLibrary
```

## Test Coverage

The UI test suites cover:

- valid login
- invalid password validation
- locked-out user validation
- inventory sorting
- cart add/remove behavior
- end-to-end checkout
- required checkout information validation

## Test Folders

`tests/ui`

Real browser automation tests using Robot Framework and Selenium.

`tests/ai`

Robot demonstrations for AI-style helper keywords in `SmartUiLibrary.py`.

`tests/ai/smart_ui_tools.robot` shows simple examples of the smart helper keywords. It demonstrates how requirement text can be converted into test ideas and how a DOM snippet can be used to suggest a stable locator.

`tests/unit`

Fast Python unit tests for custom library logic. These do not launch a browser and help validate framework utilities.

`tests/unit/test_smart_ui_library.py` tests `SmartUiLibrary.py` directly with Python `unittest`. These checks are fast because they do not open a browser. They help confirm that the custom library logic works before running the full Robot UI suite.

## Notes For Reviewers

- SauceDemo credentials are public training credentials:
  - username: `standard_user`
  - locked user: `locked_out_user`
  - password: `secret_sauce`
- Chrome may show a password breach warning for public demo passwords. The framework disables Chrome/Edge password-manager prompts through Selenium options.
- Tests avoid hard sleeps and use explicit waits around browser interactions.
- Reports are written to `results/`, which is ignored by Git.
