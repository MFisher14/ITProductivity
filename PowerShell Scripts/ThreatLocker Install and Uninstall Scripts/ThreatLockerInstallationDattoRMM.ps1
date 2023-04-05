<#
.
. Created by: @MFisher14
.
. Purpose:   This is a script that will install ThreatLocker in two possible ways. It is meant to
.            be a default install script for Datto RMM Orgs that have grandchild sites. It requires
.            a global variable named GroupID to be defined with a value of 0. On grandchild sites,
.            you must define a local variable GroupID with the GroupID pulled from ThreatLocker. On
.            line 15 you will need to add your OrganizationID from ThreatLocker.
.
#>

## Define Variables
$CompanyName = (Get-Item ENV:CS_PROFILE_NAME).value
$UniqueID = ''; ## Insert your UniqueID here
$GroupID = $env:GroupID

## Verify TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = "Tls12"

## Check if C:\Temp directory exists and create if not
if (!(Test-Path "C:\Temp")) {
    mkdir "C:\Temp";
}

## Check the OS architecture and download the correct installer
try {
    if ([Environment]::Is64BitOperatingSystem) {
        $downloadURL = "https://api.threatlocker.com/updates/installers/threatlockerstubx64.exe";
    }
    else {
        $downloadURL = "https://api.threatlocker.com/updates/installers/threatlockerstubx86.exe";
    }

    $localInstaller = "C:\Temp\ThreatLockerStub.exe";

    Invoke-WebRequest -Uri $downloadURL -OutFile $localInstaller -UseBasicParsing;
    
}
catch {
    Write-Output "Failed to get download the installer";
    Exit 1;
}

## Attempt install
if ($groupID -eq "0"){
    try {
        & C:\Temp\ThreatLockerStub.exe Key=$UniqueID Company=$CompanyName;
    }
    catch {
        Exit 1;
    }
}
else {
## This install is used to setup Grandchildren in Threatlocker
    try {
        & C:\Temp\ThreatLockerStub.exe InstallKey=$GroupID;
    }
    catch {
        Exit 1;
    }
}

## Verify install
$service = Get-Service -Name ThreatLockerService -ErrorAction SilentlyContinue;

if ($service.Name -eq "ThreatLockerService" -and $service.Status -eq "Running") {
    Write-Output "Installation successful";
    Remove-Item "C:\Temp\ThreatLockerStub.exe";
    Exit 0;
}
else {
    Write-Output "Installation Failed";
    Remove-Item "C:\Temp\ThreatLockerStub.exe";
    Exit 1;
}