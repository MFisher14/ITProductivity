#Set-ExecutionPolicy Unrestricted
#$AdminEmailAddress $EmailAddress $Email2 needs to be user inputted variable


$AzureAD=Get-InstalledModule -Name AzureAD
$AIPService=Get-InstalledModule -Name AIPService
$PSWSMan=Get-InstalledModule -Name PSWSMan
$ExchangeOnlineManagement=Get-InstalledModule -Name PSWSMan
$AIPValue=Get-AipService
Param($AdminEmailAddress)
Param($Addr1)
Param($Addr2)



if($AzureAD.count -eq 0){
    Install-Module -Name AzureAD
    Import-Module -Name AzureAD
}
else{
    Write-Host AzureAD Module is already installed
}

if($AIPService.count -eq 0){
    Install-Module -Name AIPService
    Import-Module -Name AIPService
}
else{
    Write-Host AIPService Module is already installed
}

if($PSWSMan.count -eq 0){
    Install-Module -Name PSWSMan
    Import-Module -Name PSWSMan
}
else{
    Write-Host PSWSMan Module is already installed
}

if($ExchangeOnlineManagement.count -eq 0){
    Install-Module -Name ExchangeOnlineManagement
    Update-Module -Name ExchangeOnlineManagement
    Import-Module -Name ExchangeOnlineManagement
}
else{
    Write-Host ExchangeOnlineManagement Module is already installed
}


Connect-AzureAD -AccountId $AdminEmailAddress
Connect-AipService


if($AIPValue -eq "Enabled"){
    Write-Host The AipService is enabled
}
else{
    Write-Host The AipService is disabled. Enabling now...
    Enable-AipService
}

Connect-ExchangeOnline -UserPrincipalName $AdminEmailAddress

$PullIRMValue=Get-IRMConfiguration

if($PullIRMValue.AzureRMSLicensingEnabled -eq $true){
    Write-Host Azure RMS Licensing is enabled!
}
else{
    Write-Host Enabling Azure RMS Licensing...
    Set-IRMConfiguration $true
}

Write-Host Testing the IRM Configuration...
Test-IRMConfiguration -Sender $Addr1 -Recipient $Addr2



#Disconnect-AzureAD
#Set-ExecutionPolicy Restricted
Exit 0;
