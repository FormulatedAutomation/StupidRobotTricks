*** Settings ***
Documentation   An example robot.

Task Teardown    Teardown

*** Tasks ***
Stupid Robot Task
    Demonstrate Run Keyword and Return Status VS Ignore Error

*** Keyword ***
Demonstrate Run Keyword and Return Status VS Ignore Error

    ${some_text}=   Set Variable   What does the fox say?

    ${status}=  Run Keyword And Return Status  Should Not Contain   ${some_text}   fox
    Run Keyword If  not ${status}   Log    \nReturned an error   console=yes
    # Outputs `Returned an Error`


    # You can also get the error along with the status by using `Run Keywork and Ignore Error`
    ${status}  ${value}=  Run Keyword And Ignore Error  Should Not Contain   ${some_text}   fox
    Log     ${status}    console=yes  # Outputs `FAIL`
    Log     ${value}    console=yes   # Outputs `'What does the fox say?' contains 'fox'`

    ${status}  ${value}=  Run Keyword And Ignore Error  Should Not Contain   ${some_text}   fox     msg=Custom Error
    Log     ${status}    console=yes  # Outputs `FAIL`
    Log     ${value}    console=yes   # Outputs `Custom Error: 'What does the fox say?' contains 'fox'`

Teardown
    Log     Teardown Task