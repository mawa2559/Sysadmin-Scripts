#Sets the Page File size to 1.5x the total amount of RAM installed on the system, with a max size of 2x the amount of installed RAM

$pagefile = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
$pagefile.AutomaticManagedPagefile = $false
$pagefile.put() | Out-Null

$ram = Get-CimInstance win32_ComputerSystem | foreach {[math]::round($_.TotalPhysicalMemory /1GB)}
$initialfilesize = ($ram * 1.5) * 1024
$maxfilesize = $initialfilesize * 2

$pagefileset = Get-WmiObject Win32_pagefilesetting
$pagefileset.InitialSize = $initialfilesize
$pagefileset.MaximumSize = $maxfilesize
$pagefileset.Put() | Out-Null
