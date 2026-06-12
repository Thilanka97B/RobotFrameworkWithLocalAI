param(
    [string]$resultsDir = "results",
    [string]$allureResults = "allure-results",
    [string]$allureReport = "allure-report"
)

# Ensure output folders exist
if (-Not (Test-Path -Path $allureResults)) { New-Item -ItemType Directory -Path $allureResults | Out-Null }
if (-Not (Test-Path -Path $allureReport)) { New-Item -ItemType Directory -Path $allureReport | Out-Null }

# Copy Robot output to allure results
Copy-Item -Path "$resultsDir\output.xml" -Destination "$allureResults\"
Copy-Item -Path "$resultsDir\*.xml" -Destination "$allureResults\" -ErrorAction SilentlyContinue
Copy-Item -Path "$resultsDir\*.json" -Destination "$allureResults\" -ErrorAction SilentlyContinue

Write-Host "Generating Allure report from $allureResults to $allureReport"
# Requires allure commandline in PATH (brew/choco/scoop or manual download)
allure generate $allureResults -o $allureReport --clean
Write-Host "Allure report generated: $allureReport\index.html"