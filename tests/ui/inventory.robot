*** Settings ***
Documentation       Inventory behaviors: sorting plus cart add/remove actions.
Resource            ../../resources/pages/login_page.resource
Resource            ../../resources/pages/inventory_page.resource
Suite Setup         Open Test Browser
Suite Teardown      Close Test Browser
Test Setup          Login To Inventory

*** Keywords ***
Login To Inventory
    Go To    ${BASE_URL}
    Login As    ${STANDARD_USER}
    Login Should Be Successful

*** Test Cases ***
Products Can Be Sorted By Lowest Price
    [Tags]    inventory
    Inventory Should Be Loaded
    Sort Products By    Price (low to high)
    First Product Price Should Be    $7.99

Cart Badge Updates When Product Is Added And Removed
    [Tags]    cart    smoke
    Add Backpack To Cart
    Cart Badge Should Show    1
    Remove Backpack From Cart
    Cart Badge Should Not Be Visible

