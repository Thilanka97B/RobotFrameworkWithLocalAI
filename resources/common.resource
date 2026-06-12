*** Settings ***
Resource    ../config/environments.robot
Library     SeleniumLibrary    timeout=${DEFAULT_TIMEOUT}    run_on_failure=Capture Page Screenshot    screenshot_root_directory=${OUTPUT DIR}
Library     ../libraries/SmartUiLibrary.py
Library     ../libraries/AIAnalyzer.py

*** Keywords ***
Open Test Browser
    ${options}=    Build Browser Options    ${BROWSER}    ${HEADLESS}
    Open Browser    ${BASE_URL}    ${BROWSER}    options=${options}
    Set Selenium Timeout    ${DEFAULT_TIMEOUT}
    Set Window Size    1440    1000

Close Test Browser
    # capture a suite-level screenshot with a timestamp
    ${ts}=    Get Time    epoch
    ${safe_suite}=    Replace String    ${SUITE NAME}    ${SPACE}    _
    ${suite_file}=    Set Variable    ${OUTPUT DIR}/${safe_suite}_suite_${ts}.png
    Run Keyword And Ignore Error    Capture Page Screenshot    ${suite_file}
    IF    '${SUITE STATUS}' == 'PASS'
        Log    Successfully passed automation suite
        Log To Console    Successfully passed automation suite
    ELSE
        ${analysis}=    Analyze Failure    ${SUITE MESSAGE}
        Log To Console    \nAI Suite Failure Analyzer:
        Log To Console    ${analysis}
        Log    ${analysis}
    END
    Run Keyword And Ignore Error    Close Browser

Analyze Failure If Test Failed
    IF    '${TEST STATUS}' == 'FAIL'
        # capture a screenshot for debugging (filename includes test name and timestamp)
        ${ts}=    Get Time    epoch
        ${safe_name}=    Replace String    ${TEST NAME}    ${SPACE}    _
        ${file}=    Set Variable    ${OUTPUT DIR}/${safe_name}_${ts}.png
        Run Keyword And Ignore Error    Capture Page Screenshot    ${file}
        ${analysis}=    Analyze Failure    ${TEST MESSAGE}
        Log To Console    \nAI Failure Analyzer:
        Log To Console    ${analysis}
        Log    ${analysis}
    ELSE
        Log To Console    Successfully passed automation test: ${TEST NAME}
        Log    Successfully passed automation test
    END
