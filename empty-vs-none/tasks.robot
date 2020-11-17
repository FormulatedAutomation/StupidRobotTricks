*** Settings ***
Documentation   An example robot.

Task Teardown    Teardown

*** Tasks ***
Stupid Robot Task
    Demonstrate Empty Vs None

*** Keyword ***
Demonstrate Empty Vs None

    # ${None} equates to the `None` object in Python, therefore it can be compared directly without quotes
    Log    \n"`${None} == ${None}` is valid Python"    console=yes
    # Should output `None == None` which is valid Python
    Run Keyword If    ${None} == ${None}    Log  `$\{None\} == $\{None\}` is True    console=yes

    # ${Empty} on the other hand is really just '', which resuls in the invalid python expression " == "
    Log    `${Empty} == ${Empty}` is not valid Python    console=yes
    # Wrapping it in single quotes makes it valid python
    Log    "'${Empty}' == '${Empty}' is valid Python"    console=yes
    Run Keyword If    '${Empty}' == '${Empty}'    Log    '$\{Empty\}' == '$\{Empty\}' is True    console=yes

    # And finally to demonstrate that the if statement argument is evaluated in python, take the following
    Log  \n\nDemonstate python evaluation  console=yes
    ${TwoPlusTwo}=      Set Variable    2+2
    Run Keyword If    ${TwoPlusTwo} == 4    Log    ${TwoPlusTwo} == 4 is True   console=yes


    Log  \n\nCompare None to None  console=yes
    # Never use None in an if statement comparison, it won't work the way you think it will
    ${CouldBeNone}=      Set Variable   ${None}
    # The following line will work only if ${CouldBeNone} is actually None
    Run Keyword If    ${CouldBeNone} == ${None}    Log    Was None  console=yes

    Log  \n\nCompare String to None  console=yes
    # This for example will fail with a syntax error
    ${CouldBeNone}=      Set Variable   Some random string
    ${status}  ${error}=  Run Keyword And Ignore Error    Run Keyword If  ${CouldBeNone} == ${None}
    ...  Log    Was Not None  console=yes
    Log   ${status}: ${error}    console=yes  # `FAIL: Evaluating expression 'Some random string == None' failed`


    Log  \n\nUse `Should Be Equal` to make the comparison  console=yes
    # The only way to handle checking for None is using `Should Be Equal` and checking the status
    ${CouldBeNone}=      Set Variable   Some random string
    ${isNone}=  Run Keyword And Return Status  Should Be Equal  ${CouldBeNone}  ${None}
    Run Keyword If    ${isNone}    FAIL    Was None when it should have been a string  console=yes
    ...  ELSE    Log  Was Not None, was: '${CouldBeNone}'  console=yes

    ${CouldBeNone}=      Set Variable   ${None}
    ${isNone}=  Run Keyword And Return Status  Should Be Equal  ${CouldBeNone}  ${None}
    Run Keyword If    ${isNone}    Log    Was None  console=yes
    ...  ELSE    FAIL  Should have been none


Teardown
    Log     Teardown Task