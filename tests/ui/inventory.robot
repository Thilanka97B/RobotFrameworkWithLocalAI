*** Settings ***
Documentation       Inventory behaviors: sorting plus cart add/remove actions.
Resource            ../../resources/pages/login_page.resource
Resource            ../../resources/pages/inventory_page.resource
Suite Setup         Open Test Browser
Suite Teardown      Close Test Browser
Test Setup          Login To Inventory
Test Teardown       Analyze Failure If Test Failed

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

Sort Products Name Z To A
    [Tags]    inventory
    Inventory Should Be Loaded
    ${before}=    Get First Product Name
    Sort Products By    Name (Z to A)
    ${after}=    Get First Product Name
    Should Not Be Equal    ${before}    ${after}

Sort Products Price High To Low
    [Tags]    inventory
    Inventory Should Be Loaded
    Sort Products By    Price (low to high)
    ${low_first}=    Get Text    ${FIRST_ITEM_PRICE}
    Sort Products By    Price (high to low)
    ${high_first}=    Get Text    ${FIRST_ITEM_PRICE}
    ${low}=    Evaluate    float("${low_first}".replace('$',''))
    ${high}=   Evaluate    float("${high_first}".replace('$',''))
    Should Be True    ${high} >= ${low}

Product Details Page Opens Correctly
    [Tags]    inventory    details
    Inventory Should Be Loaded
    Open First Product Details
    Product Details Should Show Name Price Image

Product Image Title Price Are Visible
    [Tags]    inventory    ui
    Inventory Should Be Loaded
    First Product Image Title Price Are Visible

Multiple Products Can Be Added To Cart
    [Tags]    cart    inventory
    Inventory Should Be Loaded
    Add First Two Products To Cart
    Cart Badge Should Show    2
