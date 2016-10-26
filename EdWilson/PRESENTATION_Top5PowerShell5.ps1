# PRESENTATION_Top5PowerShell5.ps1
# ed wilson, msft
# Tampa_PowerShell_Saturday_2016
#
# syntax to add a script to ISE: $psise.CurrentPowerShellTab.Files.Add("C:\fso\myscript.ps1")
#
# NOW READY FOR THE SCRIPT LAUNCHER. Launch each demo script individually
# press F8 after highlighting the single line command, or use the small green
# triangle. I generally use the small green triangle, because I generally use the
# mouse to select the command line.  
#
#
 $scriptPath =  "C:\Presentation\TopFiveThingsAboutPosh5"
#
## Feature number 1 in Posh 5 ... Clipboard cmdlets
## DEMO Using the clipboard cmdlets
#
"This is a string" | Set-Clipboard
#
Get-Clipboard
#
Dir c:\fso | Set-Clipboard
#
Get-Clipboard
#
Get-Clipboard -Format FileDropList
#
Get-Clipboard -Format FileDropList | Get-Member
#
(Get-Clipboard -Format FileDropList)[0] | Get-Member
#
Dir c:\fso | Set-Clipboard
#
(Get-Clipboard -Format FileDropList).basename  
#
Dir c:\fso | Set-Clipboard
#
Get-Clipboard -Format FileDropList | FT basename, LastAccessTime
#
 cls
#
## Number two feature ... clearing the recycle bin
## DEMO Using PowerShell 5 to clear the recycle bin
#
# first create a folder and a few files
1..25 | % {New-TemporaryFile }
#
# dir $([io.path]::GetTempPath())
explorer.exe $([io.path]::GetTempPath())
#
#dir $([io.path]::GetTempPath()) | Remove-Item -Recurse
#
# Check to see what files exist in the recycle bin
#
(New-Object -ComObject Shell.Application).NameSpace(0x0a).Items() |
Select-Object Name,Size,Path
#
# Now clear the recyle bin. 
Clear-RecycleBin -Force
#
# verify of course
(New-Object -ComObject Shell.Application).NameSpace(0x0a).Items() |
Select-Object Name,Size,Path
#
#
## Top item number three ... temp files
## DEMO Creating and using temporary files in Posh 5
#
# 
# in the old days, could use .NET to create temp files
#
dir $([io.path]::GetTempPath()) 
[io.path]::GetTempFileName()
# but was a bit confusing due to method name etc. 
# and so got unexplained errors
New-Item -ItemType File -Path $([io.path]::GetTempFileName())
#
# now it is a simple cmdlet
New-TemporaryFile
#
# but this is a random named file in an obscure location
# remember to save into a variable
$tmp = New-TemporaryFile
$tmp | fl *
#
# most likely, want the fullname property
$tmp.FullName
#
# I can use this via redirection or out-file. 
# This makes for great system hygine. I can write to temp file
# and then delete when am done
# This appears here:
# 
Get-Process | Out-File $tmp.FullName
notepad $tmp.FullName
#
# here i create temp file, then i open in notepad. when done, i delete file
#
Get-Service >> $tmp.FullName
#
notepad $tmp.FullName
#
Remove-Item $tmp.FullName -Force
#
# can even do all at once, using out-null trick
#
Get-Service >> $tmp.FullName
notepad $tmp.FullName | Out-Null
Remove-Item $tmp.FullName -Force
Test-Path $tmp.FullName
#
## Top item number four ... zip and unzip -- called archive
## DEMO Creating and using the zip and unzip cmdlets
#
# 
# in the old days, could use .NET to create an archive
# it was painful.
#
if(Test-Path C:\fso\ATextFile.zip) {Remove-Item C:\fso\ATextFile.zip}
Compress-Archive -Path C:\fso\ATextFile.txt `
  -DestinationPath C:\fso\ATextFile.zip
#
get-item C:\fso\ATextFile.zip
#
explorer C:\fso\ATextFile.zip
#
## compress multiple files into a single archive
#
if(Test-Path C:\fso\myarchive.zip) {Remove-Item C:\fso\myarchive.zip}
Get-ChildItem c:\fso\*.txt | 
    Compress-Archive -DestinationPath c:\fso\myarchive.zip
#
# what do i have in the archive? Use .NET...
#
Add-Type -AssemblyName “system.io.compression.filesystem”
[io.compression.zipfile]::OpenRead(“c:\fso\myarchive.zip”).entries.name
#
## Expand a zip file with Posh 5
# Cool thing is that it will expand to a folder that does not exist
Test-path c:\expandedzip
Expand-Archive C:\fso\myarchive.zip `
    -DestinationPath c:\expandedZip
dir c:\expandedzip
#
Remove-Item c:\expandedzip -Recurse
#
## Top item number five ... converting strings on the fly...
## DEMO Using Convert-String ...
#
# changing first and last name to lastname first initial ...
# using an example for a pattern ... no really, it works ...
#
"Mu Han", "Jim Hance", "David Ahs", "Kim Akers" | 
    Convert-String -Example "Ed Wilson=Wilson, E."
#
Get-Content C:\DataIn\Names_IN.txt |
    Convert-String -Example "Ed Wilson=Wilson, E."
#
## But, if i have variable length names then i need to test for it an assign a new example. 
#
$psise.CurrentPowerShellTab.Files.Add("C:\Data\Presentation\TopFiveThingsAboutPosh5\ParseVariableNames.ps1") |
Out-Null
## Extras
## DEMO extras
#
New-Guid
Format-Hex C:\fso\AMoreComplete.txt | gm
## PowerShell 5.1 additions
# 
# Get information about computer. 
# 
# can take a long time to run. Output depends on machine
#
Get-ComputerInfo
#
# local user and group management
## REQUIRES ADMIN RIGHTS
#
Get-Module -ListAvailable *local*
#
Get-Module -ListAvailable *local* | ipmo
#
Get-Command -Module Microsoft.PowerShell.LocalAccounts
# 
New-LocalUser -Name demouser -NoPassword -Disabled                                                                    
New-LocalGroup -Name demogroup                                                                                        
Add-LocalGroupMember -Group demogroup -Member demouser                                                                
Get-LocalGroup -Name demogroup                                                                                        
Get-LocalGroupMember -Group demogroup                                                                                 
Remove-LocalUser demouser                                                                                             
Remove-LocalGroup demogroup      