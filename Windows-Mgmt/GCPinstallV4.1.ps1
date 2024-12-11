<#This script completes the GCP setup for new center servers by performing the following actions:
----------------------------------------------
-Copies the required files/folders from UT-27
-Adds quantiphi account to local admin group if not already a member
-Adds full control permissions for quantiphi to codebase parent folder
-Installs: Python, Sublime Text, Chrome, and Google Cloud SDK (requires some interaction with installers)
-Collects user input to edit the python scripts and .bat files, file names 
-Checks the SQL version to set the correct driver version in the database.py file
-Install and upgrade various python packages
-Test all .bat files, then remove 'Pause' from file
-Creates and Registers the Scheduled tasks

Created by: mwalls
Version Date: 7/29/2024#>

#functions are defined here. When the script is run, the Function Call section initiates the associated function. 

#*******************Function Definitions******************************

#Function to copy files from UT27
function Copy-Template {
    Write-Host "
                Checking for ClearChoice_Codebase folder..."
    if (Test-Path "C:\ClearChoice_CodeBase") {
        Write-Host "
                Looks like the 'C:\ClearChoice_Codebase' folder already exists, skipping copy operation"
    } else {
        Write-Host "
                Copying Clearchoice_Codebase folder from UT27...`n"
        $MYSESSION = New-PSSession -ComputerName CMS-UT27.ccd.local
        Copy-Item -r -FromSession $MYSESSION 'C:\Temp\GCP (TEMPLATE)\ClearChoice_CodeBase' -Destination C:\ClearChoice_Codebase
        Remove-PSSession -Session $MYSESSION
        Write-Host "Copy to C drive complete complete!" -ForegroundColor Green
    }
}

#function to check/add CCD\quantiphi to local admin group
function Add-UserToLocalAdminGroup {
    $localadmins = get-localgroupmember -Group Administrators | Select-Object -ExpandProperty name
    if ($localadmins -contains 'CCD\quantiphi') {
        write-host 'Confirmed quantiphi is a local admin!' -ForegroundColor Green
    }Else {
        Write-Host "`n
                    Adding quantiphi to local admin group"
        Add-LocalGroupMember -Group "Administrators" -Member "CCD\quantiphi"
        Write-Host "`nCCD\quantiphi added to local admin group!" -ForegroundColor Green
    }
}

#function to add Full Control permissions to ClearChoice_Codebase folder for CCD\quantiphi
function Grant-PermissionsToQuantiphi {
    Write-Host "`n
                Giving CCD\quantiphi full control over ClearChoice_Codebase folder"
    $ACL = Get-ACL -Path C:\ClearChoice_CodeBase
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("quantiphi", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $ACL.SetAccessRule($AccessRule)
    $ACL | Set-Acl -Path C:\ClearChoice_CodeBase
    (Get-ACL -Path "C:\ClearChoice_CodeBase").Access | Format-Table IdentityReference, FileSystemRights, AccessControlType, IsInherited, InheritanceFlags -AutoSize
    Write-Host "`nPermission added!" -ForegroundColor Green
}

#Function to install python
function Install-Python {
    Write-Host "`nBeginning Python Installation..."
    if (Test-Path "C:\Program Files\Python38\python.exe") {
        Write-Host "Python is already installed! Skipping installation" -ForegroundColor Green
    } else {
        $url = "https://www.python.org/ftp/python/3.8.0/python-3.8.0-amd64.exe"
        $output = "C:\temp\python-3.8.0-amd64.exe"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $url -OutFile $output 
        $installerPath = $output
        $installArguments = "/passive InstallAllUsers=1 PrependPath=1 Include_test=0"
        Start-Process -FilePath $installerPath -ArgumentList $installArguments -Wait
        Write-Host "`nPython Successfully installed!" -ForegroundColor Green 
    }
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    Write-Host "`nPath updated!" -ForegroundColor Green
}


#function to install Sublime
function Install-SublimeText {
    Write-Host "`n
        Beginning Installation of Sublime Text...`n
        Installer will open: confirm install directory, check the box to add to context menu`n"
    Read-Host "Press Enter to start installation"
    if (Test-Path "C:\Program Files\Sublime Text\sublime_text.exe") {
        Write-Host "Sublime is already installed! Skipping installation" -ForegroundColor Green
    } else {
        #Path to the Sublime Text installer executable
        $installerPath = "C:\ClearChoice_CodeBase\GCS_QP_Prod\Install\3-sublime_text_build_4143_x64_setup.exe"

        #Start the installation process and wait for it to finish
        Start-Process -FilePath $installerPath -Wait

        Write-Host "`nSublime Text installation complete!" -ForegroundColor Green 
    }
}

#function to install chrome
function Install-Chrome {
    Read-Host "
            Beginning Chrome installation:`n
            Once Chrome opens, sign in with your Clearchoice account and
            set Chrome as the default browser.`n
            Press enter to begin installation"
    if (Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe") {
        Write-Host "
                    Chrome is already installed! Skipping installation.
                    Rememember to sign into your account and set chrome as the default browser!`n" -ForegroundColor Green
    } else {
        $installerPath = "C:\ClearChoice_CodeBase\GCS_QP_Prod\Install\1-ChromeSetup.exe"
        Start-Process -FilePath $installerPath -Wait
        Write-Host "Chrome installation complete!" -ForegroundColor Green 
        }
}

#function to prompt for info and save to variables
function Collect-VerifyInfo {
    $global:cloudSiteName = Read-Host "`nEnter cloud site name (format: IL-Schaumburg)"
    $global:threeLetterSiteName = Read-Host "Enter 3 Letter Site name (format: SCH)"
    $global:centerID = Read-Host "Enter the center ID pulled from GCP (format: a0S40000002P7MdEAK)"
    $answer = Read-Host "`nYou entered:`n$cloudSiteName`n$threeLetterSiteName`n$centerID`nIs this correct? (y/n)"
    if ($answer -eq 'n') {
        Collect-VerifyInfo
        }
}

#function to Edit the python files and file names
function Edit-FilesAndFileNames {
    param (
        [string]$ServerImagesPath,
        [string]$CloudSiteName,
        [string]$ThreeLetterSiteName,
        [string]$CenterID,
        [string]$DirPath
    )

    Write-Host "`nBeginning the edit of files and file names...`n"

    Get-ChildItem $DirPath -Recurse -Include *.json, *.py |
    ForEach-Object {
        (Get-Content $_) | ForEach-Object {
            $_.replace("cloudsitename", $CloudSiteName).replace("3LN", $ThreeLetterSiteName).replace("GCPCenterID", $CenterID)
        } | Set-Content $_
    }

    Write-Host "`nFiles edited successfully!`n" -ForegroundColor Green 

    Write-Host "`n
                Renaming files..."
    $newPatientListName = "C:\ClearChoice_CodeBase\GCS_QP_Prod\8_patient_cloud_gcs\"+$ThreeLetterSiteName +"_patient_list_form.txt"
    Rename-Item -Path C:\ClearChoice_CodeBase\GCS_QP_Prod\8_patient_cloud_gcs\3LN_patient_list_form.txt -NewName $newPatientListName -Force
    Write-Host "`nFiles Renamed!" -ForegroundColor Green 
}

#function to check SQL version and change driver used in script if SQL 22 present
Function Update-SQLdriver {
    Write-Host "
                Detecting SQL server version..."

    try {
        $sqlVersion = sqlcmd -S .\ROMEXIS -E -Q "SELECT @@VERSION" | Out-String
    } 
    catch {
        Write-host "
                    Having trouble checking the sql version...(might not be installed yet)`n"
        $answer = read-host "Is SQL Server 2022 installed (or will it be installed)? (y/n)"
        if ($answer -eq "y") {
            $sqlVersion = "Server 2022"
            } else {
            $sqlVersion = "Older version"
        }
    }

    finally {
        if ($sqlVersion.Contains("Server 2022")) {
            Write-Host "
                    SQL Server 2022 in use
                    Updating SQl Driver...`n"
            (Get-Content -Path "C:\ClearChoice_CodeBase\GCS_QP_Prod\2_mssql_bq\database.py") -replace("SQL Server Native Client 11.0","ODBC Driver 17 for SQL Server") |
            Set-Content -Path "C:\ClearChoice_CodeBase\GCS_QP_Prod\2_mssql_bq\database.py"
            Write-Host "SQL driver updated!" -ForegroundColor Green
            } Else {
            Write-Host "`nCompatible SQL driver already set, no changes made" -ForegroundColor Green
            }
    }
}


#function to add Pause to .bat files
function Add-Pause {
    Write-Host "`n
                Adding 'Pause' to all .bat files..."
    get-childitem "C:\ClearChoice_CodeBase\GCS_QP_Prod" -recurse -include *.bat |
    ForEach-Object {
        Add-Content $_ -Value "`nPause"
    }
    write-host "`n'Pause' added to all .bats!" -ForegroundColor Green 
}

#function to install gcloud SDK
function Install-CloudSDK {
    Write-host "`n
                Beginning Google Cloud SDK install`n
                Accept all installation Defaults
                Ensure it's installed for ALL users
                Installer will run gcloud init`n"
    Read-Host "
                Press Enter to begin installation - installer will continue to run while the rest of this script executes"
    $installerPath = "C:\ClearChoice_CodeBase\GCS_QP_Prod\Install\4-GoogleCloudSDKInstaller.exe"
    Start-Process -FilePath $installerPath #-Wait
    Write-Host "Cloud SDK Installation initiated - perform cloud init setup when installation completes!" -ForegroundColor Green 
}

#function for installing/upgrading python packages
function Install-PythonPackages {
    param (
        [string]$RequirementsFile,
        [string[]]$Packages
    )

    Write-Host "`n
                Installing Python packages...
                This will take a few minutes.`n"

    # Install packages from the requirements file
    pip3 install -r $RequirementsFile
    Write-Host "Packages from Requirements File installed successfully.
        ...ignore PyNaCL error" -ForegroundColor Green

    # Install and upgrade individual packages
    foreach ($package in $Packages) {
        Write-Host "
                    Installing and upgrading $package..."
        pip install --upgrade $package
        Write-Host "`n$package installed and upgraded successfully" -ForegroundColor Green
    }
}


#function to Test all of the .bat files one at a time, and remove pause
function Test-AndRemovePauseFromBats {
    param (
        [string]$BatPath
    )

    #Create an array of .bat file paths
    $batFiles = @(
        "$BatPath\1_upload_cloud_gcs\upload.bat",
        "$BatPath\3_download_cloud_gcs\download.bat",
        "$BatPath\2_mssql_bq\database.bat",
        "$BatPath\6_download_gdrive_cloud_gcs\gdrive_download.bat",
        "$BatPath\8_patient_cloud_gcs\patient_list.bat",
        "$BatPath\9_free_disk_space\free_disk_space.bat"
    )

    # Test each .bat file one at a time
    foreach ($batFile in $batFiles) {
        $Choice = Read-Host "`nTest '$batfile'? (y/n)"
        if ($Choice -eq 'y') {
            Start-Process -FilePath $batFile -Wait
        } else {
            Write-Host "`nSkipping $batFile test"
        }
    }

    $finalChoice = Read-Host "`nIf all tests were successful, Press 'y' to Remove 'Pause' from all .bat files, or 'n' to skip"
    if ($finalChoice -eq 'y') {
        Write-Host "`nRemoving 'Pause' from all .bat files"
        Get-ChildItem $BatPath -Recurse -Include *.bat |
        ForEach-Object {
            (Get-Content $_).replace("Pause", "") | Set-Content $_
        }
    } else {
        Write-Host "'Pause' NOT removed from .bat files." -ForegroundColor Red 
    }
}

#function to register scheduled tasks
function Create-ScheduledTasks {
    $TaskFiles = @(
        "C:\ClearChoice_CodeBase\GCS_QP_Prod\Install\Tasks\GCPupload.xml",
        "C:\ClearChoice_CodeBase\GCS_QP_Prod\Install\Tasks\GCPdownload.xml",
        "C:\ClearChoice_CodeBase\GCS_QP_Prod\Install\Tasks\GCPdatabase.xml",
        "C:\ClearChoice_CodeBase\GCS_QP_Prod\Install\Tasks\GCPgdrive_download.xml",
        "C:\ClearChoice_CodeBase\GCS_QP_Prod\Install\Tasks\GCPpatient_list.xml",
        "C:\ClearChoice_CodeBase\GCS_QP_Prod\Install\Tasks\GCPFree_Disk_Space.xml"
    )
    Write-Host "
                Beginning Scheduled Task creation...`n"

    $qpwd = Read-Host "Enter quantiphi account password"

    foreach ($task in $TaskFiles) {
        $taskName = $task.replace('C:\ClearChoice_CodeBase\GCS_QP_Prod\Install\Tasks', '').replace('.xml','')
        Register-ScheduledTask -Xml (get-content $task | out-string) -TaskName $taskName -User ccd\quantiphi -Password $qpwd -force
        Write-Host $taskName scheduled task created -ForegroundColor Green
    }
    Write-Host "Task creation complete!`n" -ForegroundColor Green
    Write-Host "You must edit the tasks to set the task start dates correctly!!!" -ForegroundColor Red
}

#**********************Function Calls************************************

Write-Host "`n
            Welcome to the GCP component installer`n
            Make sure you have the following info ready before you run this script:`n
            Cloud site name (format: IL-Schaumburg)`n
            3 Letter site name (format: NNN)`n
            Center ID pulled from GCP (format: a0S40000002P7MdEAK)`n
            The CCD\quantiphi AD account password`n"

Read-Host "`nIf you're ready to begin, press Enter"

#Copy Files from CMS-UT27 to the local server
Copy-Template

#add quantiphi to local admin group
Add-UserToLocalAdminGroup

#Give quantiphi full control permissions over ClearChoice_Codebase
Grant-PermissionsToQuantiphi

#install CloudSDK
Install-CloudSDK

#Install Python
Install-Python

#Install Sublime
Install-SublimeText

#Install Chrome
Install-Chrome
Read-Host "Press Enter to continue after signing into Chrome and setting chrome as the default browser"

#Collect user input for file editing/renaming. Have user verify info is correct
Collect-VerifyInfo

#Edit files and filenames with user input
Edit-FilesAndFileNames -ServerImagesPath "C:" -CloudSiteName $cloudSiteName -ThreeLetterSiteName $threeLetterSiteName -CenterID $centerID -DirPath "C:\ClearChoice_CodeBase\GCS_QP_Prod"

#SQL version check and update if version is 2022
Update-SQLdriver

#add pause to all .bat files
Add-Pause

#install requirements.txt, install and upgrade packages
$requirementsFile = "C:\ClearChoice_CodeBase\GCS_QP_Prod\Install\requirements.txt"
$packagesToInstall = @(
    "pandas",
    "pyodbc",
    "pypyodbc",
    "pandas-gbq",
    "google-cloud",
    "google-cloud-bigquery",
    "google-cloud-storage"
)

Install-PythonPackages -RequirementsFile $requirementsFile -Packages $packagesToInstall

Read-Host "
        `n Once Google Cloud SDK Install is complete and you've
        completed the gcloud init configuration, press ENTER to continue to .bat file testing"

#Test .bats and remove pause
$batPath = "C:\ClearChoice_CodeBase\GCS_QP_Prod"
Test-AndRemovePauseFromBats -BatPath $batPath

#Create and Register Scheduled tasks
Create-ScheduledTasks

#notification of script end
Write-Host "`nInstallation Complete!!`n" -ForegroundColor Green 