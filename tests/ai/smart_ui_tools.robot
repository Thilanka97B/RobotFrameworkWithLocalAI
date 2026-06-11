*** Settings ***
Documentation       Demonstrates AI-style custom tooling for test design and locator assistance.
Library             ../../libraries/SmartUiLibrary.py

*** Test Cases ***
Generate Test Ideas From Natural Language Requirement
    ${ideas}=    Generate Test Ideas From Requirement
    ...    Checkout requires first name, last name, and postal code before payment.
    Log    ${ideas}
    Should Contain    ${ideas}    positive
    Should Contain    ${ideas}    negative
    Should Contain    ${ideas}    edge

Suggest Locator From Dom Snapshot
    ${html}=    Catenate
    ...    <form>
    ...    <input data-test="firstName" placeholder="First Name">
    ...    <input data-test="postalCode" placeholder="Zip/Postal Code">
    ...    <button id="continue">Continue</button>
    ...    </form>
    ${locator}=    Suggest Locator From Dom Snapshot    ${html}    first name
    Log    ${locator}
    Should Be Equal    ${locator}    css=[data-test="firstName"]
