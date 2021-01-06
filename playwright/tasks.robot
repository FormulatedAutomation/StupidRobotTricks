*** Settings ***
Library   RPA.Browser.Playwright

*** Test Cases ***
Example Test
    Open Browser    https://playwright.dev  headless=False
    Get Text    h1    ==    🎭 Playwright