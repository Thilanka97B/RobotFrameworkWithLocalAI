*** Settings ***
Documentation       Login coverage for valid credentials, invalid credentials, and locked users.
Resource            ../../resources/pages/login_page.resource
Resource            ../../resources/pages/inventory_page.resource
Suite Setup         Open Test Browser
Suite Teardown      Close Test Browser
Test Setup          Go To    ${BASE_URL}

*** Test Cases ***
Standard User Can Log In
    [Tags]    smoke    login
    Login As    ${STANDARD_USER}
    Login Should Be Successful
    Inventory Should Be Loaded

Invalid Password Shows Helpful Error
    [Tags]    negative    login
    Login As    ${STANDARD_USER}    wrong-password
    Login Error Should Contain    Username and password do not match

Locked Out User Is Rejected
    [Tags]    negative    login
    Login As    ${LOCKED_OUT_USER}
    Login Error Should Contain    locked out
