import json
from playwright.sync_api import sync_playwright

def run(playwright):
    browser = playwright.chromium.launch(headless=False)
    context = browser.new_context()

    # Open new page
    page = context.new_page()

    # Go to https://www.marketwatch.com/investing/stock/gme
    page.goto("https://www.marketwatch.com/investing/stock/gme")

    el = page.query_selector("h3.intraday__price")
    quote_text = el.text_content()
    quote_text = "".join(quote_text.split())
    print(quote_text)


    # Close page
    page.close()

    # ---------------------
    context.close()
    browser.close()

    data = {
        'gme': quote_text
    }

    with open('quote.json', 'w') as outfile:
        json.dump(data, outfile)

with sync_playwright() as playwright:
    run(playwright)