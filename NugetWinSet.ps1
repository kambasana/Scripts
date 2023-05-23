# Desired NuGet API URL
$desiredNugetUrl = "https://api.nuget.org/v3/index.json"

# Path to NuGet
$nugetPath = "$env:LOCALAPPDATA\NuGet\nuget.exe"

# Check if NuGet is installed
if (!(Test-Path $nugetPath)) {
    Write-Host "NuGet is not installed. Installing now..." -ForegroundColor Yellow

    # Download NuGet
    Invoke-WebRequest "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile $nugetPath
}

# Test if NuGet is working
try {
    & $nugetPath help | Out-Null
    Write-Host "NuGet is working correctly." -ForegroundColor Green
} catch {
    Write-Host "There was an error running NuGet. Please check your installation." -ForegroundColor Red
    exit
}

# Get current NuGet sources
$currentSources = & $nugetPath sources

# Check if the desired NuGet API URL is already in the sources
if ($currentSources -like "*$desiredNugetUrl*") {
    Write-Host "NuGet API URL is already set to $desiredNugetUrl" -ForegroundColor Green
} else {
    # Remove all current NuGet sources
    foreach ($source in $currentSources) {
        $sourceName = $source -replace '.*Name: (\w+).*', '$1'
        & $nugetPath sources Remove -Name $sourceName
    }

    # Add the desired NuGet API URL
    & $nugetPath sources Add -Name "NuGet v3" -Source $desiredNugetUrl

    Write-Host "NuGet API URL has been set to $desiredNugetUrl" -ForegroundColor Green
}
