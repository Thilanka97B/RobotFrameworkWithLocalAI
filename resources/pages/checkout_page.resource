*** Settings ***
Resource    ../common.resource

*** Variables ***
${FIRST_NAME_INPUT}           id=first-name
${LAST_NAME_INPUT}            id=last-name
${POSTAL_CODE_INPUT}          id=postal-code
${CONTINUE_BUTTON}            id=continue
${FINISH_BUTTON}              id=finish
${CHECKOUT_ERROR}             css=[data-test="error"]
${SUMMARY_TOTAL}              css=.summary_total_label
${COMPLETE_HEADER}            css=.complete-header
${CANCEL_BUTTON}              id=cancel
${OVERVIEW_ITEM_NAME}          css=.cart_item_label

*** Keywords ***
Submit Checkout Information
    [Arguments]    ${first_name}    ${last_name}    ${postal_code}
    Input Text    ${FIRST_NAME_INPUT}    ${first_name}
    Input Text    ${LAST_NAME_INPUT}    ${last_name}
    Input Text    ${POSTAL_CODE_INPUT}    ${postal_code}
    Click Button    ${CONTINUE_BUTTON}

Continue Checkout Without Information
    Click Button    ${CONTINUE_BUTTON}

Checkout Error Should Contain
    [Arguments]    ${message}
    Wait Until Element Is Visible    ${CHECKOUT_ERROR}
    Element Should Contain    ${CHECKOUT_ERROR}    ${message}

Overview Should Be Displayed
    Wait Until Location Contains    checkout-step-two.html
    Wait Until Element Is Visible    ${SUMMARY_TOTAL}

Finish Checkout
    Click Button    ${FINISH_BUTTON}
    Wait Until Location Contains    checkout-complete.html

Order Confirmation Should Be Displayed
    Element Text Should Be    ${COMPLETE_HEADER}    Thank you for your order!

Submit Checkout Only First And Last Name
    [Arguments]    ${first_name}    ${last_name}
    Input Text    ${FIRST_NAME_INPUT}    ${first_name}
    Input Text    ${LAST_NAME_INPUT}    ${last_name}
    Click Button    ${CONTINUE_BUTTON}

Submit Checkout Only First And Postal Code
    [Arguments]    ${first_name}    ${postal_code}
    Input Text    ${FIRST_NAME_INPUT}    ${first_name}
    Input Text    ${POSTAL_CODE_INPUT}    ${postal_code}
    Click Button    ${CONTINUE_BUTTON}

Overview Should Contain Product
    [Arguments]    ${product_name}
    Wait Until Location Contains    checkout-step-two.html
    Page Should Contain    ${product_name}

Checkout Total Should Be Displayed
    Wait Until Element Is Visible    ${SUMMARY_TOTAL}
    ${total_text}=    Get Text    ${SUMMARY_TOTAL}
    Should Contain    ${total_text}    Total

Cancel Checkout
    Click Button    ${CANCEL_BUTTON}
    Wait Until Location Contains    inventory.html

