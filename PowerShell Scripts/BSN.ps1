Connect-AzureAD
New-AzureADGroup -DisplayName 'BSN-Employees' -MailEnabled $false -MailNickName 'BSN-Employees' -SecurityEnabled $true
New-AzureADGroup -DisplayName 'BSN-Managers' -MailEnabled $false -MailNickName 'BSN-Managers' -SecurityEnabled $true


$AzureUsers = Get-AzureADUser
$NumberOfUsers = $AzureUsers.count + 1
$CountingVariable = 0
while ($CountingVariable -ne $NumberOfUsers) {
