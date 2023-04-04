<#
.Created by: @MFisher14
.Purpose: A quick script to enable RMS Templates on Legacy 365 Tenants
#>

# Pass in global admin email
Param([String]$Admin)

#Check if running elevated. If not, elevate.
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

# Define variables and check for installed modules
$Modules = @(
    # Required Packages and Modules
    "AzureAD"
    "AIPService"
    "PSWSMan"
    "ExchangeOnlineManagement"

)

foreach ($Module in $Modules) {
    $Module=Get-InstalledModule -Name $Module -ErrorAction SilentlyContinue
    if($Module.count -eq 0){
        Write-Host $Module module is not installed. Installing now...
        Install-Module -Name $Module
        Import-Module -Name $Module -ErrorAction SilentlyContinue
    }
    else{
        Write-Host $Module module is already installed
    }
}
#NuGet and AIP have a different install.
$NuGet=Get-InstalledModule -Name NuGet -ErrorAction SilentlyContinue
$AIPValue=Get-AipService -ErrorAction SilentlyContinue


# Check if NuGet is installed
if($NuGet.count -eq 0){
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
}
else{
    Write-Host NuGet Package is already installed
}

#Connect to Services
Connect-AzureAD -AccountId $Admin
Connect-AipService


if($AIPValue -eq "Enabled"){
    Write-Host The AipService is enabled
}
else{
    Write-Host The AipService is disabled. Enabling now...
    Enable-AipService
}

Connect-ExchangeOnline -UserPrincipalName $Admin

#Check if Azure RMS Licensing is enabled
$PullIRMValue=Get-IRMConfiguration

if($PullIRMValue.AzureRMSLicensingEnabled -eq $true){
    Write-Host Azure RMS Licensing is enabled!
}
else{
    Write-Host Enabling Azure RMS Licensing...
    Set-IRMConfiguration $true
}

Write-Host Testing the IRM Configuration...
Test-IRMConfiguration -Sender $Admin -Recipient $Admin


Set-ExecutionPolicy Restricted
Exit 0;