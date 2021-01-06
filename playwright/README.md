
If you've spent any time in RPA, you've undoubtedly been involved in browser automation. And if you've worked on the open source and python side, you've likely used Selenium to drive your browser automation. But while Selenium still works well for many projects, if you're jumping into the space today, or starting a new project, it's worth taking a look at some of the newer open source tooling. One of those tools is the [Playwright project from Microsoft](https://playwright.dev/).

## But first some history

Browser automation didn't start in the RPA space, but instead came out of the software testing and QA world. Selenium was created in 2004 by Thoughworks for the purpose of launching a browser and having it perform tasks to verify that a web application was working correctly.

Since then, Selenium has become the de facto standard for automating a browser programmatically. It's not the easiest library to use (as Stack Overflow can attest), but it gets the job done.

But there have been some challengers along the way. Most notably Puppeteer, a project from Google that allows developers to automate a Chrome browser using its JavaScript API. Puppeteer really kicked off this latest iteration of browser automation by updating the tooling and allowing developers more fine grained control of the browser using a modern API and stack. Most notably, they focused on easy to use and lightweight 'headless' testing, which sped up automations and gave developers more options with where to run it (You can do this with Selenium, but it's not trivial)

More recently, Microsoft entered the game with Playwright, which started as a fork of Puppeteer but focused on an improved automation API and better support across the different browsers. In fact, two leading Puppeteer contributors left to work on Playwright.

Fast forward to today and we have an actively developed and stable [Robot Framework plugin](https://marketsquare.github.io/robotframework-browser/Browser.html) allowing us to use Playwright for browser automation. And this week Robocorp included it as an option in their [RPA Framework plugin](https://rpaframework.org/libraries/browser_playwright/index.html#). We've seen fits and starts of projects seeking to add a modern browser automation stack to the RPA playbook, but this one looks like it may actually see meaningful adoption.

## So why should you choose Playwright for your next browser automation?

Anyone in the RPA space tends to be leery of new tools, and for good reason. When you spend all day working in legacy software you see the pain that comes from bad technical decisions. RPA tools are no different. Picking Playwright at this point may seem a bit early, but with the support of large players like Microsoft and RPA startups like Robocorp, I'm confident Playwright is likely to unseat Selenium in the RPA space.

That being said, here let's look at some of the features that make Playwright a compelling option.

### Actionability

By default, Playwright bakes in "actionability" to any automation task. In the Selenium world, before clicking on a button we'd need to wait until it's visible on the page. So we end up writing a check like "Wait until element is visible    my_button_xpath" before any click action. But there's more to it than that. What we really want to know is when the button is ready to perform an action, and its visibility isn't always the best indicator.
 
In the Playwright world, actionability is clearly defined for each action keyword and encompasses a variety of tests. For example, before clicking on a button Playwright would wait until the following is true:

- Is it visible?
- Is it stable? (Element has maintained the same bounding box for at least two consecutive animation frames)
- Is it enabled?
- Receiving Events (Element is the hit target of the pointer event at the action point. Playwright checks whether some other element (usually an overlay) will instead capture the click)
- Attached (Element is connected to a Document or a ShadowRoot)

I think this is likely one of the largest, if not THE largest sources of flaky, buggy behavior in Selenium today. Adding 'actionability' alone makes the switch to Playwright worth it in my opinion.

See: [Actionability](https://github.com/microsoft/playwright/blob/master/docs/actionability.md)


### Speed

Both Puppeteer and Playwright are faster than Selenium, but I think when you combine the above actionability checks, you'll end up with faster automation in the real world. I've come across countless automations that start drawing out the pause between actions in order to avoid hard detect actionability bugs, something that can likely be avoided with Playwright.

See: [Benchmarks](https://blog.checklyhq.com/puppeteer-vs-selenium-vs-playwright-speed-comparison)


### Better Selectors

You should already be using CSS selectors in Selenium, but in Playwright you get some added syntactical sugar.

```
Fill Text   [placeholder="Search GitHub"]
```

But the most useful feature they've added is the ability to chain selectors and reference the previous selector result using '>>':

```
Click   .class >> #login_btn
```

Along with chaining into an iFrame:

```
Click   id=iframe >>> id=btn
```

See: [Selectors](https://github.com/microsoft/playwright/blob/master/docs/selectors.md)


### Observing network requests and responses

Because we've got better control and visibility into the browser we can even target network events.

Let's say I have a button that, when clicked, makes several calls to an API and finishes by making a POST request to `/api/create_contact`. I want to click the button and then wait until that request happens.

```
${promise}=    Promise To    Wait For Response    matcher=https://example.com/api/create_contact    timeout=3s
Click    \#delayed_request
${body}=    Wait For    ${promise}
```

Not only have I waited for the request to fire before continuing, I've got access to the API's response in `${body}`

See: [Wait For Response](https://marketsquare.github.io/robotframework-browser/Browser.html#Wait%20For%20Response)


### Perform an HTTP Request from within the current browser context

While you can make HTTP requests directly from Robot Framework, Playwright lets you fire them off from within the browser's current context and get the response.

```
&{res}=             HTTP                       /api/endpoint
Should Be Equal     ${res.status}              200
Should Be Equal     ${res.body.some_field}     some value
```

This opens up a ton of possibilities, especially with attended automations.

See: [HTTP Requests](https://marketsquare.github.io/robotframework-browser/Browser.html#Http)


## Is this the end for Selenium?

We won't see the end of Selenium anytime soon. It's been widely adopted and has been around for more than 15 years, so you should expect to see if for another 15. That being said, if I were launching a new automation project today I'd have a hard time pulling the trigger on Selenium with Playwright being this far along. What you get in return for being an early adopter is more than made up for in features that will dramatically improve your automations.

Got questions? Hit me up in the comments and I'll do my best to answer them.
