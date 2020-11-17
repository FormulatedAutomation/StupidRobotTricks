*** Settings ***
Documentation   An example robot.

Task Teardown    Teardown

*** Tasks ***
Stupid Robot Task
    Demonstrate Empty Vs None

*** Keyword ***
Demonstrate Empty Vs None

    # ${None} equates to the `None` object in Python, therefore it can be compared directly without quotes
    Log    "`${None} == ${None}` is valid Python"    console=yes
    # Should output `None == None` which is valid Python
    Run Keyword If    ${None} == ${None}    Log  `$\{None\} == $\{None\}` is True    console=yes

    # ${Empty} on the other hand is really just '', which resuls in the invalid python expression " == "
    Log    `${Empty} == ${Empty}` is not valid Python    console=yes
    # Wrapping it in single quotes makes it valid python
    Log    "'${Empty}' == '${Empty}' is valid Python"    console=yes
    Run Keyword If    '${Empty}' == '${Empty}'    Log    '$\{Empty\}' == '$\{Empty\}' is True    console=yes

    # And finally to demonstrate that the if statement argument is evaluated in python, take the following
    ${TwoPlusTwo}=      Set Variable    2+2
    Run Keyword If    ${TwoPlusTwo} == 4    Log    ${TwoPlusTwo} == 4    console=yes


Teardown
    Log     Teardown Task