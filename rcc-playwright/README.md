# RCC, Playwright and the 'codegen' tool

In this tutorial we're going to take a look at not only getting Playwright up and running with RCC, but using Playwright's excellent 'codegen' tool to quickly build the start of a web automation script.

'codegen' launches an interactive browser and records the actions you take while within the session. When you're done, just close the browser and it will output a Python script duplicating your actions in the browser.

It's generated code, so it's not perfect, but if you're starting a new web automation project it's a quick way to get up and running with a basic script. Let's walk through the setup process and at the end we'll demonstrate using 'codegen' to look up a stock quote.

## Prerequisites

This assumes you have RCC installed and available on your command line/terminal. You can find more information on installing RCC [here](https://github.com/robocorp/rcc).


RCC means you don't need to worry about installing Python or any of the project dependencies. This is especially useful if you want to share your automation code around your organization.


## Creating the project

Let's start by creating the initial project with RCC. We can do this with one command, as seen below:

```
rcc create rcc-playwright
```

It will ask you a couple questions, in our case we'll pick a 'python' project when asked.

Now enter the 'rcc-playwright' directory with `cd rcc-playwright` in terminal or PowerShell. This is where we'll be running the tasks via RCC.

### Adding Playwright to conda.yaml

RCC will handle installing the necessary Python packages via miniconda, so all we need to do is modify `conda.yml` to add 'playwright' and a post-install script to install the browsers.

Your conda.yaml file should look like this:

```
...
  - python=3.7.5
  - pip=20.1
  - pip:
    # Define pip packages here. 
    - rpaframework==7.1.1 # https://rpaframework.org/releasenotes.html
    - playwright==1.8.0a1
rccPostInstall:
  - playwright install
```

At this point we have the required python packages and now need to setup a task to run `codegen`

Open up `robot.yaml` and add the following task:

```
  codegen:
    command:
      - python
      - -m
      - playwright
      - codegen
      - -o
      - codegen.py
      - https://bing.com
```

In the above task we'll be running Playwright 'codegen' tool and telling it to output the program to codegen.py

### Running codegen

Now the only thing left to do is to run it. RCC will automatically download the requirements (python version, pip, packages) and start the 'codegen' task. Playwrights 'codegen' will open a Chrome browser by default and navigate to Bing. At this point it's up to us to drive the browser and create out automation. In the video below I'll do a quick stock search and save the code generated.

[![Video Demo](https://img.youtube.com/vi/Xubn62GTkDk/0.jpg)](https://www.youtube.com/watch?v=Xubn62GTkDk)

Lets look at what we got. Remember, this is generated code so it's going to be messy, but it will hopefully give an idea of what 'codegen' does and provide you with a good starting point.

```
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
```

Now it's up to you to clean this up and do something with the stock quote information, but with 'codegen' you've got a great template to start from.