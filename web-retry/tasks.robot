*** Settings ***
Documentation   An example robot.
Library         RPA.Browser

Task Teardown    Teardown

*** Tasks ***
Stupid Robot Task
    Demonstrate Web Retry

*** Keyword ***
Demonstrate Web Retry
    Open Available Browser   https://google.com

    Run Keyword and Ignore Error
    ...   Go To And Wait With Retry   http://milk.com   //table[@class='doesntexist']   5   2

    # Will succeed
    Go To And Wait With Retry   http://milk.com   //table[@class="milk-header"]   5   2

Go To And Wait With Retry
    [Arguments]   ${url}   ${xpath}   ${retries}=5   ${timeout}=15
    FOR    ${i}     IN RANGE    1    ${${retries}+1}
        Go To   ${url}
        ${status}=   Run Keyword and Return Status
        ...   Wait Until Element Is Visible   ${xpath}   ${timeout}
        Return From Keyword If   ${status}   ${i}
        Log   Failed to find ${xpath} on ${url}   console=yes
        Run Keyword If   ${i} < ${retries}
        ...   Log   Retrying ${${i}+1} of ${retries}   console=yes
    END
    Fail   Unable to load ${xpath} on ${url} after ${retries} attempts

Teardown
    Close Browser