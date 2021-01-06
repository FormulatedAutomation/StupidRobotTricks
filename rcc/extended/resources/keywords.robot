*** Settings ***
Library     ExampleLibrary
Variables   variables.py

*** Keywords ***
Process greeting for today
    ${current_date}=    Current date
    ${day_name}=        Get week day name
    Log                 Hello! Today is ${day_name}. The date is ${current_date}.  console=True

Get week day name
    [Return]    ${WEEK_DAY_NAME}
