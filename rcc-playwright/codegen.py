from playwright.sync_api import sync_playwright

def run(playwright):
    browser = playwright.chromium.launch(headless=False)
    context = browser.new_context()

    # Open new page
    page = context.new_page()

    # Go to https://www.bing.com/?toWww=1&redig=297CC9C15084435BBCC4F3DEE3D76F21
    page.goto("https://www.bing.com/?toWww=1&redig=297CC9C15084435BBCC4F3DEE3D76F21")

    # Click input[aria-label="Enter your search term"]
    page.click("input[aria-label=\"Enter your search term\"]")

    # Fill input[aria-label="Enter your search term"]
    page.fill("input[aria-label=\"Enter your search term\"]", "gme ")

    # Click text="348.9799"
    page.click("text=\"348.9799\"")
    # assert page.url == "https://www.bing.com/search?q=gme+stock&qs=FN&pq=gme+stock&sc=8-9&cvid=7E8B3EE0C11C4B0DA32C511A180C25C8&FORM=QBLH&sp=1&ghc=1"

    # Click div[id="Finance_Quote"] >> text="348.98"
    page.click("div[id=\"Finance_Quote\"] >> text=\"348.98\"")

    # Close page
    page.close()

    # ---------------------
    context.close()
    browser.close()

with sync_playwright() as playwright:
    run(playwright)