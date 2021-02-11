![FA Github Header](https://user-images.githubusercontent.com/2868/98735818-fabe8a80-2371-11eb-884a-e555e31aa348.png)


**Formulated Automation RPA Resources**

-   [Formulated Automation Podcast](https://www.formulatedautomation.com/category/podcast/)
-   [/r/ProcessAutomation](https://reddit.com/r/ProcessAutomation)
-   [Process Automation LinkedIn
    Group](https://www.linkedin.com/groups/12366622/)

# Using Hashicorp Vault with UiPath

While there are credential store options for UiPath, another popular and quite secure option is [Hashicorp's Vault](https://www.vaultproject.io/). If your company already uses Vault then you probably don't want to overcomplicate things by also having credentials stored in UiPath. Unfortunately it's not integrated into UiPath in any meaningful way. However, Vault provides an HTTP interface for retrieving secrets, so it's not a difficult task to simply write your own HTTP query.

The goal of this project is to demonstrate how that's accomplished.

## Quick guide to getting Hashicorp Vault on UiPath

### Install UiPath's Web Activities package

Pretty self-explanatory, but this lets us make HTTP requests and also parse the JSON response.

![Install Package dialog](https://github.com/FormulatedAutomation/StupidRobotTricks/blob/main/uipath-hashicorp-vault/add_web_activities.png?raw=true)

### Use the Web Request wizard to build your request

For this you'll need a couple items from your Vault admin.

1. A token from Vault with the correct permissions (This should be stored in UiPath's credential store)
2. The path of the secret you're attempting to retrieve.
3. The hostname of your vault server.

Let's say your Vault server is at https://vault.corp.com/ and the secret path is `/secret/salesforce/credentials`. This actually breaks down to:

- Mountpoint: 'secret'
- Path: 'salesforce/credentials'

The request you'll need to make is to 'https://vault.corp.com/v1/secret/data/salesforce/credentials` (from: https://[servername]/v1/[mountpoint]/data/[path])

And in order to authenticate you'll need to make sure the headers include your token in the form of:

`X-Vault-Token: [Token]`

You can see my setup below:

![Web Request wizard](https://github.com/FormulatedAutomation/StupidRobotTricks/blob/main/uipath-hashicorp-vault/WebRequest.png?raw=true)

### Demonstration

And finally, you'll want to parse the JSON response and save it to a variable. Accessing it with JObject would look something like `apiRespJSON.SelectToken("data.data")`

You can see the raw JSON response in the screenshot below (don't worry, this isn't my actual password)

![Web Request wizard](https://github.com/FormulatedAutomation/StupidRobotTricks/blob/main/uipath-hashicorp-vault/Output.png?raw=true)

You can open this project up in UiPath, but in order to run it you'll need to update the token, path and vault address to make it work.
