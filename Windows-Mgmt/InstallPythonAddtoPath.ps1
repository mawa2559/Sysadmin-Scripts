#This script function installs python 3.8.0 from the web, configures a few settings and adds it to the PATH in current session

function Install-Python {
    Write-Host "`nBeginning Python Installation..."
    if (Test-Path "C:\Program Files\Python38\python.exe") { #check if the install folder already exists and stop install if it does
        Write-Host "Python is already installed! Skipping installation" -ForegroundColor Green
    } else {
        $url = "https://www.python.org/ftp/python/3.8.0/python-3.8.0-amd64.exe" #URL for web download
        $output = "C:\temp\python-3.8.0-amd64.exe" #places the executable in C:\temp
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $url -OutFile $output 
        $installerPath = $output
        $installArguments = "/passive InstallAllUsers=1 PrependPath=1 Include_test=0" #some optional installer arguments, installs python for all users
        Start-Process -FilePath $installerPath -ArgumentList $installArguments -Wait #starts a process to keep track of the installation progress and waits for the install to complete before writing success message
        Write-Host "`nPython Successfully installed!" -ForegroundColor Green 
    }
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") #updates the evirnoment variables for the current session to include python
    Write-Host "`nPath updated!" -ForegroundColor Green
}

#to call this function simply run the "Install-Python" command
