*** Settings ***
Resource    ../config/environments.robot
Library     SeleniumLibrary    timeout=${DEFAULT_TIMEOUT}
Library     ../libraries/SmartUiLibrary.py

*** Keywords ***
Open Test Browser
    ${options}=    Build Browser Options    ${BROWSER}    ${HEADLESS}
    Open Browser    ${BASE_URL}    ${BROWSER}    options=${options}
    Set Selenium Timeout    ${DEFAULT_TIMEOUT}
    Set Window Size    1440    1000

Close Test Browser
    Capture Page Screenshot
    Close Browser
