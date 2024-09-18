Write-Host "
                        *******************************
                        *******************************
                        **********           **********
                        ********               ********
                        ******                   ******
                        ****                       ****
                        ****       **     **       ****
                        ****  *******************  ****
                        *******************************
                        ****  *******************  ****
                        ****      ***     ***      ****
                        ****                       ****
                        ******                   ******
                        ********                *******
                        **********           **********
                        *******************************
                        *******************************

" -ForegroundColor Cyan
Write-Host "
_______                        _                          ______ _               
|__   __|                      (_)                        |  ____(_)              
   | | ___  __ _ _ __ _____   ___  _____      _____ _ __  | |__   ___  _____ _ __ 
   | |/ _ \/ _` | '_ ` _ \ \ / / |/ _ \ \ /\ / / _ \ '__| |  __| | \ \/ / _ \ '__|
   | |  __/ (_| | | | | | \ V /| |  __/\ V  V /  __/ |    | |    | |>  <  __/ |   
   |_|\___|\__,_|_| |_| |_|\_/ |_|\___| \_/\_/ \___|_|    |_|    |_/_/\_\___|_|   
                                                                                                                                                     
" -ForegroundColor DarkBlue
Start-Sleep 2
Clear-Host

# Clear previous variables
$computerName = $null

do {
    # Assign remote computer name
$computerName = Read-Host "Enter the name of the remote computer or press Q to quit."

# Create the session to the remote computer
Write-Host "Attempting to connect to $computerName..." -ForegroundColor Cyan
try {
    $session = New-PSSession -ComputerName $computerName
    Write-Host "Connected!" -ForegroundColor Green
}
catch {
    Write-Host "Could not connect to $computerName. Please ensure the device is connected to the network."
}

# Define the Directory - Change as needed
$sourceDirectory = "changeme"

# Define the remote file path (where you want to copy the file on the remote computer) - Change as needed
$destinationDirectory = "changeme"

# Copy the file from local to remote 
Write-host "Copying $sourceDirectory to $destinationDirectory on $computername..."
Copy-Item -Path $sourceDirectory -Destination $destinationDirectory -ToSession $session -Recurse

# Execute uninstall Teamviwer - change the directory to match the name of your .ad account
Write-Host "Attempting TeamViewer uninstall... This will take a few minutes. Be patient!" -ForegroundColor Magenta
Invoke-Command -Session $session -ScriptBlock {
    $destinationDirectory = "changeme"
    Set-Location $destinationDirectory
    .\Uninstall.bat
}

Write-Host "Done!" -ForegroundColor Green

# Execute reinstall proper Teamviewer - change the directory to match the name of your .ad account
Write-Host "Attempting TeamViewer reinstall... This will take a few minutes. Be patient!" -ForegroundColor Cyan
Invoke-Command -Session $session -ScriptBlock {
    $destinationDirectory = "changeme"
    Set-Location $destinationDirectory
    .\Reinstall.bat
}

Write-Host "Done!" -ForegroundColor Green

# Delete the Teamviewer folder - change the directory to match the name of your .ad account
Write-Host "Deleting Teamviewer folder..." -ForegroundColor Yellow
Invoke-Command -Session $session -ScriptBlock {
    $destinationDirectory = "changeme"
    Set-Location $destinationDirectory
    Remove-Item .\Teamviewer\ -Force -Recurse
}
Write-Host "Done! Closing session." -ForegroundColor Green

# Closes the session
Exit-PSSession

} until (
    $computerName = "q"
)
