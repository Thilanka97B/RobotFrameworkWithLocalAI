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
