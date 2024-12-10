gwmi -Query 'select * from Win32_ComputerSystem where Name = "7FY24J3" or Name = "5NH8YD3" or Name = "ARD68" or Name = "RCH-TR02"'

gwmi -Query 'Select VideoProcessor From  Win32_VideoController where Name LIKE "%NVIDIA%"'

get-gporeport -Name "NVIDIA Settings test" -ReportType HTML -Path "C:\Temp\NVIDIATestGPO.html"