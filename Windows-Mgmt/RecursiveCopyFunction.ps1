#This script recursively copies a directory from a remote computer
#It's packaged as a function to make it more portable

function Copy-Folder {
    $localDirDest = "C:\localDestination" #folder on the local computer where files need to be copied to
    $remoteDirSource = "C:\temp\remoteDir" #remote folder
    $remoteServer = "SRV01.domain.local"
    if (Test-Path $localDirDest) { # IF statement checks to see if the intended local destination for the copied file already exists, folder won't be copied if it does
        Write-Host "
                Looks like the '$localDirDest' folder already exists, not performing copy operation"
    } else {
        Write-Host "
                Copying Clearchoice_Codebase folder from $remoteServer...`n"
        $MYSESSION = New-PSSession -ComputerName $remoteServer
        Copy-Item -r -FromSession $MYSESSION $remoteDirSource -Destination $localDirDest
        Remove-PSSession -Session $MYSESSION
        Write-Host "Copy complete!" -ForegroundColor Green
    }
}

# to call this function simply run "Copy-Folder"
