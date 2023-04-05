<#
.
. Created By: MFisher14
. Purpose: Uninstall ThreatLocker. This script is meant to be run from PowerShell.
.          It requires tamper protection to be disabled from within ThreatLocker on the device or
.          devices threatlocker is being removed from.
.
#>

#Check if running elevated. If not, elevate.
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

net stop HealthTLService
net stop threatlockerservice
$downloadURL = "https://api.threatlocker.com/updates/installers/threatlockerstubx64.exe";
$localInstaller = "C:\Temp\ThreatLockerStub.exe";
Invoke-WebRequest -Uri $downloadURL -OutFile $localInstaller -UseBasicParsing;
C:\Temp\ThreatLockerStub.exe uninstall;