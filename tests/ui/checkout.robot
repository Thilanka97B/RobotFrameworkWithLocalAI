*** Settings ***
Documentation       Checkout happy path and required-field validation.
Resource            ../../resources/pages/login_page.resource
Resource            ../../resources/pages/inventory_page.resource
Resource            ../../resources/pages/cart_page.resource
Resource            ../../resources/pages/checkout_page.resource
Suite Setup         Open Test Browser
Suite Teardown      Close Test Browser
Test Setup          Start Checkout With Backpack
Test Teardown       Analyze Failure If Test Failed

*** Keywords ***
Start Checkout With Backpack
    Go To    ${BASE_URL}
    Login As    ${STANDARD_USER}
    Login Should Be Successful
    Run Keyword And Ignore Error    Remove Backpack From Cart
    Go To    ${BASE_URL}/inventory.html
    Add Backpack To Cart
    Open Cart
    Cart Should Contain Product    Sauce Labs Backpack
    Proceed To Checkout

*** Test Cases ***
Customer Can Complete Checkout
    [Tags]    checkout    smoke
    Submit Checkout Information    Bhagya    QA    90210
    Overview Should Be Displayed
    Finish Checkout
    Order Confirmation Should Be Displayed

Checkout Requires First Name
    [Tags]    checkout    negative
    Continue Checkout Without Information
    Checkout Error Should Contain    First Name is required

Checkout Requires Last Name
    [Tags]    checkout    negative
    Submit Checkout Only First And Postal Code    Bhagya    90210
    Checkout Error Should Contain    Last Name is required

Checkout Requires Postal Code
    [Tags]    checkout    negative
    Submit Checkout Only First And Last Name    Bhagya    QA
    Checkout Error Should Contain    Postal Code is required

Checkout Overview Shows Correct Item
    [Tags]    checkout    validation
    Submit Checkout Information    Bhagya    QA    90210
    Overview Should Contain Product    Sauce Labs Backpack

Checkout Total Is Displayed
    [Tags]    checkout    validation
    Submit Checkout Information    Bhagya    QA    90210
    Checkout Total Should Be Displayed

Cancel Checkout Returns To Inventory
    [Tags]    checkout    navigation
    Submit Checkout Information    Bhagya    QA    90210
    Cancel Checkout
