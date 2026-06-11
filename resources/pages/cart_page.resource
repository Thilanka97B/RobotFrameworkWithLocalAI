*** Settings ***
Resource    ../common.resource

*** Variables ***
${CART_ITEM}                  css=.cart_item
${CHECKOUT_BUTTON}            id=checkout

*** Keywords ***
Cart Should Contain Product
    [Arguments]    ${product_name}
    Wait Until Element Is Visible    ${CART_ITEM}
    Page Should Contain    ${product_name}

Proceed To Checkout
    Click Button    ${CHECKOUT_BUTTON}
    Wait Until Location Contains    checkout-step-one.html

