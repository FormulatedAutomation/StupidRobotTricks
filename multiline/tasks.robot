*** Settings ***
Documentation   An example robot.

Task Teardown    Teardown

*** Variables ***
${multiline_seperator_newline}  SEPARATOR=\n
...  Line One       Line Two
...  Line Three
...  Line Four

${multiline_seperator_space}
...  Line One       Line Two 
...  Line Three
...  Line Four

@{array_of_phrases}     Line One       Line Two 
...  Line Three
...  Line Four

*** Tasks ***
Stupid Robot Task
    Demonstrate Multiline Variables

*** Keyword ***
Demonstrate Multiline Variables
    # In this case, we output multiline string with newlines seperating them
    Log     ${multiline_seperator_newline}    console=yes
    Log     ${multiline_seperator_space}    console=yes
    ${concatenated}=     Catenate    @{array_of_phrases}
    Log     ${concatenated}  console=yes
    ${concatenated2}=     Catenate    SEPARATOR=.    @{array_of_phrases}
    Log     ${concatenated2}  console=yes


Teardown
    Log     Teardown Task