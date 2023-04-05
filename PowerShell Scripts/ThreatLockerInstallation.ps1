<#
.Created By:
.Purpose: Install ThreatLocker. If the Main Organization has Grandchildren in Datto RMM, add as
.         Groups under the main organization.
#>

Param([String]$CompanyName, [String]$UniqueIdentifier, [String]$GroupID) ## Parameters are defined first.


[Net.ServicePointManager]::SecurityProtocol = "Tls12"  ## Verify TLS 1.2

## Inital Log File
$LogFilePath = 'C:\.TLInstallLogFile.txt'
New-Item $LogFilePath ## Start the ThreatLocker Log File
Write-Output ThreatLocker Installation is starting... >> $LogFilePath
Write-Output The value of CompanyName is: $CompanyName >> $LogFilePath
Write-Output The value of UniqueIdentifier is: $UniqueIdentifier >> $LogFilePath
Write-Output The value of GroupID is: $GroupID >> $LogFilePath

$ThreatLockerParameters = @(
    "CompanyName"
    "UniqueIdentifier"
    "GroupID"
)
foreach ($ThreatLockerParameter in $ThreatLockerParameters) {
    if ($ThreatLockerParameter -eq "") {
        Write-Output The variable $ThreatLockerParameter is empty >> $LogFilePath
    }
    else {
        Write-Output The variable $ThreatLockerParameter has a value! >> $LogFilePath
    }
}


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
if ($groupID -eq ""){
    try {
        & C:\Temp\ThreatLockerStub.exe Key=$UniqueID Company=$CompanyName;
    }
    catch {
        Write-Output "Installation Failed on Standard Install" >> $LogFilePath;
        Exit 1;
    }
}
else {
# This install is used to setup Grandchildren in Threatlocker
try {
    & C:\Temp\ThreatLockerStub.exe InstallKey=$GroupID;
}
catch {
    Write-Output "Installation Failed on GrandChild Install" >> $LogFilePath;
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