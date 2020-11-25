# Web Automation: Retries

In a perfect world we wouldn't need to retry loading a webpage, but if you're working with RPA you don't live in a perfect world. And if you've spent any time working with Selenium to automate a web integration, you've most likely fallen into a rhythm of:

1. Click a link or go to a URL
2. Wait for an element on the page to render (thereby letting you know the page has loaded)
3. Take some action on that page.

While step #2 seems pretty trivial, it's also a common place to experience breaks in an automation flow.

Two common breakages occur here:

1. The element has changed and your script times out and fails.
2. The page does load before the timeout and your script breaks.

While the first issue will likely require intervention and a change to the script, when working with legacy systems it's not uncommon to see slow page loads or rendering hangs prevent the script from working. In these cases it's easier to retry page load. 

Why not lengthen the timeout? Because many times these hangs can be indefinite with older legacy web apps. Instead of using a 2 minute timeout, it might be faster to retry loading the page after 15 seconds.

Doing this with robot framework is actually pretty simple:

```robotframework
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
```

This code should be pretty self-explanatory, but lets go over it.

- First we attempt to load the URL and wait for a xpath locator. But we enclose it with "Run Keyword and Return Status" to ensure that it's failure doesn't cause the entire automation to fail.
- We then check the status (whether it ran successfully or timed out)
  - If it was successful we return from the keyword and our automation continues
  - If it fails, the for loop will ensure that it is tried again.
- If the for loop completes and we still don't have a success, we will throw a "Fail" and cause the entire automation to fail. This is optional, and depending on your business requirements, you may want to deal with this another way (For instance, if it's not critical data, maybe the occasional failure is acceptable)
