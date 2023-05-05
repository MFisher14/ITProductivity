<#
.Created by: @MFisher14
.Purpose: A quick script to create required 365 Security groups for Breach Secure Now / PII Protect
.         Automatically adds licensed users with the same domain as admin account to the groups
.         based on job title.
#>
## Connect to AzureAD
Connect-AzureAD

## Pull in the domain that will be used to select the users to be added to the BSN Platform
$ClientDomainName = Get-AzureADCurrentSessionInfo
$DomainFormat = '*@' + $ClientDomainName.TenantDomain

## Check if BSN Groups are already created. If not, create them.
$BSNGroupNames = @(
    "BSN-Employees"
    "BSN-Managers"
    "BSN-PartnerAdmins" ## This group does NOT get used in this script. Only created.
)

foreach ($BSNGroup in $BSNGroupNames) {

    ## First check if the groups already exist. Create the group if not.
    $FindBSNGroup = Get-AzureADGroup | Where DisplayName -eq $BSNGroup

    if ($FindBSNGroup.count -eq 0) {
        New-AzureADGroup -DisplayName $BSNGroup -MailEnabled $false -MailNickName $BSNGroup -SecurityEnabled $true
    }
}

## Add the Group descriptions
$FindBSNGroups = Get-AzureADGroup -SearchString 'BSN'

foreach ($BSNGroupFound in $FindBSNGroups) {

    if ($BSNGroupFound.DisplayName -eq 'BSN-Employees') {
        Set-AzureADGroup -ObjectId $BSNGroupFound.ObjectId -Description 'PII/PHI Protect Standard Users'
        $BSNEmployeesObjId = $BSNGroupFound.ObjectId
    }
    elseif ($BSNGroupFound.DisplayName -eq 'BSN-Managers') {
        Set-AzureADGroup -ObjectId $BSNGroupFound.ObjectId -Description 'PII/PHI Protect Manager Role'
        $BSNManagersObjId = $BSNGroupFound.ObjectId
    }
    elseif ($BSNGroupFound.DisplayName -eq 'BSN-PartnerAdmins') {
        Set-AzureADGroup -ObjectId $BSNGroupFound.ObjectId -Description 'PII/PHI Protect Partner Administrator Role'
        $BSNPAObjId = $BSNGroupFound.ObjectId
    }
}

## Get AzureAD users. Filtering out all commonly used scanning, copying, and faxing email addresses
$AzureUsers = Get-AzureADUser | Where UserPrincipalName -Like $DomainFormat | Where UserPrincipalName -NotLike 'scan*' | Where UserPrincipalName -NotLike 'copie*' | Where UserPrincipalName -NotLike 'fax*' | Where UserPrincipalName -NotLike 'zz*' | Where UserType -NotLike 'Guest'

## Set Job Titles that desgnate manager role in BSN
$JobTitles = @(
    ## You can add or remove Job Titles to customize this list for your organization
    "*CCO*"
    "*CDO*"
    "*CEO*"
    "*CFO*"
    "*Chief*"
    "*CHRO*"
    "*CIO*"
    "*COO*"
    "*CTO*"
    "*Director*"
    "*Executive*"
    "*Manager*"
    "*President*"
    "*VP*"
)

## Setup variables to verify the user is not already apart of one of the BSN groups
$CheckBSNEmployees = Get-AzureADGroup -ObjectId $BSNEmployeesObjId
$CheckBSNEmployeeMembers = $CheckBSNEmployees | Get-AzureADGroupMember -All $true
$CheckBSNManagers = Get-AzureADGroup -ObjectId $BSNManagersObjId
$CheckBSNManagerMembers = $CheckBSNManagers | Get-AzureADGroupMember -All $true
$CheckBSNPartnerAdmin = Get-AzureADGroup -ObjectId $BSNPAObjId
$CheckBSNPartnerAdminMembers = $CheckBSNPartnerAdmin | Get-AzureADGroupMember -All $true

## Verify all users are licensed and add user to required group
foreach ($User in $AzureUsers) {

    ## Initialize local variables
    $IsUserInGroup = $false
    $isManager = $false
    $isLicensedUser = $false

    ## Verify User is Licensed
    $getUserLicenseStatus = Get-AzureADUserLicenseDetail -ObjectId $User.ObjectId
    if ($getUserLicenseStatus.count -ne 0) {
        $isLicensedUser = $true
    }

    ## Verify the user is not apart of any BSN Group
    if (($CheckBSNEmployeeMembers.ObjectId -contains $User.ObjectId) -or ($CheckBSNManagerMembers.ObjectId -contains $User.ObjectId) -or ($CheckBSNPartnerAdminMembers.ObjectId -contains $User.ObjectId)) {
        $IsUserInGroup = $true
    }
    else {
        $IsUserInGroup = $false
    }

    ## Check if the user is a standard employee or a manager. Exit the check if one of the manager tags are satisfied
    :isJobTitleManagement foreach ($JobTitle in $JobTitles) {
        if ($User.JobTitle -like $JobTitle) {
            $isManager = $true
            Break isJobTitleManagement
#            Write-Output $User.DisplayName ' is a ' $User.JobTitle
        }
        else {
            $isManager = $false
 #           Write-Output $User.DisplayName ' is not a manager. They are a ' $User.JobTitle
        }
        }

    ## Place the user in the correct group
    if (($IsUserInGroup -eq $false) -and ($isManager -eq $true) -and ($isLicensedUser -eq $true)) {
        Add-AzureADGroupMember -ObjectId $BSNManagersObjId -RefObjectId $User.ObjectId
 #       Write-Output $User.DisplayName ' is an manager'
    }
    elseif (($IsUserInGroup -eq $false) -and ($isManager -eq $false) -and ($isLicensedUser -eq $true)) {
        Add-AzureADGroupMember -ObjectId $BSNEmployeesObjId -RefObjectId $User.ObjectId
 #       Write-Output $User.DisplayName ' is a employee'
    }
    else {
        Write-Output 'Something went wrong, or ' $User.DisplayName ' is not licensed.'
    }

}

## Set the execution policy back to restricted
Set-ExecutionPolicy Restricted

Exit