# This script creates and registers a scheduled task based on a pre-defined xml file. This is helpful for mass deploying or repeated task creations
#The predefined xml is created as is, so it should have it's settings pre-defined, but can me modified afterwards as needed
#the start date and time and trigger is set in the xml below, but can also be set separately with New-ScheduledTaskTrigger and Set-ScheduledTaskTrigger commands
#Tasks have many parameters and the XML can be modified to suit

$TaskFile = "C:\Path\To\upload_task.xml" # path to the xml file with the task definitions
$TaskName = "upload_task" #the name for the task as it will appear in Scheudled Task manager
$AccountPass = "PASSWORD" #the password of the account that will be running the task
$DomainUser = "domain\Admin1" #domain\username of the account that will be running the task

Register-ScheduledTask -Xml (get-content $TaskFile | out-string) -TaskName $taskName -User $DomainUser -Password $AccountPass -force

#Task File XML example:
#<?xml version="1.0" encoding="UTF-16"?>
#<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
# <RegistrationInfo>
#    <Date>2022-12-12T11:53:05.9598798</Date>
#    <Author>domain\Admin1</Author>            ---------------------> EDIT THIS LINE TO BE THE CORRECT ACCOUNT
#    <URI>\upload</URI>
#  </RegistrationInfo>
#  <Triggers>
#    <CalendarTrigger>
#      <StartBoundary>2022-12-12T20:00:00</StartBoundary> ----------> TASK START DATE
#      <Enabled>true</Enabled>
#      <ScheduleByWeek>
#        <DaysOfWeek>
#          <Monday />
#          <Tuesday />
#        <Wednesday />
#          <Thursday />
#          <Friday />
#        </DaysOfWeek>
#        <WeeksInterval>1</WeeksInterval>
#      </ScheduleByWeek>
#    </CalendarTrigger>
#  </Triggers>
#  <Principals>
#    <Principal id="Author">
#      <RunLevel>HighestAvailable</RunLevel>  ----------------------> RUN LEVEL PARAMETER
#      <UserId>domain\admin1</UserId>         ----------------------> RUNAS PARAMETER
#      <LogonType>Password</LogonType>        ----------------------> LOGON PARAMETER
#    </Principal>
#  </Principals>
#  <Settings>
#    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
#    <DisallowStartIfOnBatteries>true</DisallowStartIfOnBatteries>
#    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
#    <AllowHardTerminate>true</AllowHardTerminate>
#    <StartWhenAvailable>false</StartWhenAvailable>
#    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
#    <IdleSettings>
#      <StopOnIdleEnd>true</StopOnIdleEnd>
#      <RestartOnIdle>false</RestartOnIdle>
#    </IdleSettings>
#    <AllowStartOnDemand>true</AllowStartOnDemand>
#    <Enabled>true</Enabled>
#    <Hidden>false</Hidden>
#    <RunOnlyIfIdle>false</RunOnlyIfIdle>
#    <WakeToRun>false</WakeToRun>
#    <ExecutionTimeLimit>P3D</ExecutionTimeLimit>
#    <Priority>7</Priority>
#  </Settings>
#  <Actions Context="Author">
#    <Exec>
#      <Command>C:\Path\To\upload.bat</Command> -------------> COMMAND TO BE RUN by the task
#    </Exec>
#  </Actions>
#</Task>
#>
