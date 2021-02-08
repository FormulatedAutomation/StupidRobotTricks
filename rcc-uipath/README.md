# Using RCC within UiPath

UiPath is a great automation tool, but if you come from the Python world it can be a bit difficult to drop back into the scripting tool you know and love. UiPath does have the ability to run Python, but it doesn't include any way to specify the version of Python nor the dependencies.

While playing with Robocorp's RCC tool, I realized that it might be trivial to write a Powershell script that downloads RCC and then runs a python project via the tool.

In this example we have a UiPath bot that runs a Powershell script, which in turn takes care of running our python project via RCC. The Python project has several dependencies and includes browser automation. The automation runs, gets the price of a stock and then writes that out to a local JSON file, which UiPath in turn reads back into its flow.

This is a convoluted example, but it's designed to show that even a complex Python automation can be run from within UiPath. In the real world I could imagine someone wanting to script a complex interaction with an API using Python and then pull some data back into UiPath.

## The process in detail

### Powershell side

Use a custom Powershell script that performs the following tasks:

1. Checks to see if RCC is installed already
1. If so, checks to see if it's the latest version
1. Installs the latest version if necessary
1. Runs the default automation script via RCC

Here's the script:

```powershell
$RCCProjectLocation = "$(Get-Location)\rcc-gme-price"
$RCCLatestUrl = "https://downloads.robocorp.com/rcc/releases/latest/windows64/rcc.exe"
$RCCLatestVersionUrl = "https://downloads.robocorp.com/rcc/releases/latest/version.txt"
$exePath = $env:LOCALAPPDATA
$exeDestination = "$exePath\rcc.exe"

function Sync-RCC {
  if (Test-Path $exeDestination) {
    $Response = Invoke-WebRequest -Uri $RCCLatestVersionUrl
    $LatestRCCVersion = $Response.Content.Trim()
    $CurrentInstalledRCCVersion = (Invoke-Expression "rcc.exe version").Trim()
    if ($LatestRCCVersion -eq $CurrentInstalledRCCVersion) {
      Write-Output "Running the latest version of RCC - $CurrentInstalledRCCVersion"
    } else {
      Write-Host "Older version of RCC found, $CurrentInstalledRCCVersion. Installing $LatestRCCVersion"
      Update-RCC
    }
  } else {
    Write-Host "RCC not found. Installing..."
    Update-RCC
  }
}

function Update-RCC {
  Invoke-WebRequest -Uri $RCCLatestUrl -OutFile $exeDestination
  Write-Host "RCC Download complete"
}

Sync-RCC
Try {
  Write-Output $RCCProjectLocation
  Set-Location $RCCProjectLocation
  $Expr = "$exeDestination run -t Default"
  $er = (invoke-expression $Expr) 2>&1
  Write-Output $er
} Catch {
  Write-Output $_
}
```

### Python side

Now that RCC has installed the dependecies, `task.py` is run. This automation uses Playwright to open a browser and get a stock price. It thens writes this data to a local JSON file called `quote.json`

### From the UiPath side

Back in UiPath, after the Powershell script completes (which means our Python automation has run), UiPath then reads in and deserializes the JSON file we output from Python. There's no easy way to transfer data between a Powershell process and UiPath so we use a JSON file as the transport for now.

What it looks like:

![image](https://user-images.githubusercontent.com/2868/107256029-f5bbb680-6a06-11eb-835a-ada393956676.png)