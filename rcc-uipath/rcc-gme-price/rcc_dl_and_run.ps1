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