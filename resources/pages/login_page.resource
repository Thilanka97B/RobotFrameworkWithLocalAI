*** Settings ***
Resource    ../common.resource

*** Variables ***
${LOGIN_USERNAME_INPUT}       id=user-name
${LOGIN_PASSWORD_INPUT}       id=password
${LOGIN_BUTTON}               id=login-button
${LOGIN_ERROR_MESSAGE}        css=[data-test="error"]
${APP_LOGO}                   css=.app_logo

*** Keywords ***
Login As
    [Arguments]    ${username}    ${password}=${PASSWORD}
    Wait Until Element Is Visible    ${LOGIN_USERNAME_INPUT}
    Input Text    ${LOGIN_USERNAME_INPUT}    ${username}
    Input Password    ${LOGIN_PASSWORD_INPUT}    ${password}
    Click Button    ${LOGIN_BUTTON}

Login Should Be Successful
    Wait Until Location Contains    inventory.html
    Wait Until Element Is Visible    ${APP_LOGO}
    Element Text Should Be    ${APP_LOGO}    Swag Labs

Login Error Should Contain
    [Arguments]    ${message}
    Wait Until Element Is Visible    ${LOGIN_ERROR_MESSAGE}
    Element Should Contain    ${LOGIN_ERROR_MESSAGE}    ${message}

Attempt Login With Only Password
    [Arguments]    ${password}=${PASSWORD}
    Wait Until Element Is Visible    ${LOGIN_USERNAME_INPUT}
    Input Password    ${LOGIN_PASSWORD_INPUT}    ${password}
    Click Button    ${LOGIN_BUTTON}

Attempt Login With Only Username
    [Arguments]    ${username}
    Wait Until Element Is Visible    ${LOGIN_USERNAME_INPUT}
    Input Text    ${LOGIN_USERNAME_INPUT}    ${username}
    Click Button    ${LOGIN_BUTTON}

