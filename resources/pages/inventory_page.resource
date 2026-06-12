*** Settings ***
Resource    ../common.resource

*** Variables ***
${INVENTORY_LIST}             css=.inventory_list
${INVENTORY_ITEM}             css=.inventory_item
${SORT_DROPDOWN}              css=[data-test="product-sort-container"]
${CART_BADGE}                 css=.shopping_cart_badge
${CART_LINK}                  css=.shopping_cart_link
${BACKPACK_ADD_BUTTON}        id=add-to-cart-sauce-labs-backpack
${BACKPACK_REMOVE_BUTTON}     id=remove-sauce-labs-backpack
${FIRST_ITEM_PRICE}           css=.inventory_item:first-child .inventory_item_price
${FIRST_ITEM_NAME}            css=.inventory_item:first-child .inventory_item_name
${FIRST_ITEM_IMAGE}           css=.inventory_item:first-child .inventory_item_img
${DETAILS_NAME}               css=.inventory_details_name
${DETAILS_PRICE}              css=.inventory_details_price
${DETAILS_IMAGE}              css=.inventory_details_img

*** Keywords ***
Inventory Should Be Loaded
    Wait Until Element Is Visible    ${INVENTORY_LIST}
    ${count}=    Get Element Count    ${INVENTORY_ITEM}
    Should Be True    ${count} > 0

Sort Products By
    [Arguments]    ${label}
    Select From List By Label    ${SORT_DROPDOWN}    ${label}
    Wait Until Element Is Visible    ${FIRST_ITEM_PRICE}

First Product Price Should Be
    [Arguments]    ${price}
    Element Text Should Be    ${FIRST_ITEM_PRICE}    ${price}

Add Backpack To Cart
    Click Button    ${BACKPACK_ADD_BUTTON}
    Wait Until Element Is Visible    ${BACKPACK_REMOVE_BUTTON}

Remove Backpack From Cart
    Click Button    ${BACKPACK_REMOVE_BUTTON}
    Wait Until Element Is Visible    ${BACKPACK_ADD_BUTTON}

Cart Badge Should Show
    [Arguments]    ${count}
    Wait Until Element Is Visible    ${CART_BADGE}
    Element Text Should Be    ${CART_BADGE}    ${count}

Cart Badge Should Not Be Visible
    Wait Until Element Is Not Visible    ${CART_BADGE}

Open Cart
    Click Element    ${CART_LINK}
    Wait Until Location Contains    cart.html

Get First Product Name
    ${name}=    Get Text    ${FIRST_ITEM_NAME}
    RETURN    ${name}

First Product Name Should Be
    [Arguments]    ${name}
    Element Text Should Be    ${FIRST_ITEM_NAME}    ${name}

Open First Product Details
    Click Element    ${FIRST_ITEM_NAME}
    Wait Until Element Is Visible    ${DETAILS_NAME}

Product Details Should Show Name Price Image
    Element Should Be Visible    ${DETAILS_NAME}
    Element Should Be Visible    ${DETAILS_PRICE}
    Element Should Be Visible    ${DETAILS_IMAGE}

First Product Image Title Price Are Visible
    Element Should Be Visible    ${FIRST_ITEM_IMAGE}
    Element Should Be Visible    ${FIRST_ITEM_NAME}
    Element Should Be Visible    ${FIRST_ITEM_PRICE}

Add First Two Products To Cart
    Click Button    css=.inventory_item:nth-child(1) button
    Click Button    css=.inventory_item:nth-child(2) button
    Wait Until Element Is Visible    ${CART_BADGE}

