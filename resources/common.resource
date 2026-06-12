*** Settings ***
Resource    ../config/environments.robot
Library     SeleniumLibrary    timeout=${DEFAULT_TIMEOUT}
Library     ../libraries/SmartUiLibrary.py
Library     ../libraries/AIAnalyzer.py

*** Keywords ***
Open Test Browser
    ${options}=    Build Browser Options    ${BROWSER}    ${HEADLESS}
    Open Browser    ${BASE_URL}    ${BROWSER}    options=${options}
    Set Selenium Timeout    ${DEFAULT_TIMEOUT}
    Set Window Size    1440    1000

Close Test Browser
    Run Keyword And Ignore Error    Capture Page Screenshot
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
        ${analysis}=    Analyze Failure    ${TEST MESSAGE}
        Log To Console    \nAI Failure Analyzer:
        Log To Console    ${analysis}
        Log    ${analysis}
    ELSE
        Log To Console    Successfully passed automation test: ${TEST NAME}
        Log    Successfully passed automation test
    END

*** Keywords ***
