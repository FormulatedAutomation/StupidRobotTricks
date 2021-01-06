*** Settings ***
Documentation   An example robot.
Library         RPA.Browser

Task Teardown    Teardown


*** Variables ***
${UploadFileLocator}           xpath=//input[@id="fileField"]
${AddFile}          example.jpg
${URL}         https://filebin.net


*** Tasks ***
Stupid Robot Task
    Open Available Browser   ${URL}
    Upload file

*** Keywords ***
Upload file
    Wait Until Page Contains Element     ${UploadFileLocator}    60s
    Choose File  ${UploadFileLocator}   ${CURDIR}${/}${AddFile}
    Wait Until Page Contains Element     //table[@class="sortable table"]   60s
    Sleep   10s

Teardown
    Close Browser