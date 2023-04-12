This script is used to setup the groups and add the users for the Breach Secure Now / PII Protect Platform. It is an unsigned script, so don't forget to run the:
    
    Set-ExecutionPolicy Unrestricted

before running the script. The easiest way to download and run the file is by following the instructions below:

Click on this link

<a href="https://raw.githubusercontent.com/MFisher14/ITProductivity/main/PowerShell%20Scripts/Breach%20Secure%20Now%20and%20PII%20Protect%20Setup%20Scripts/BreachSecureNowAzureADSetup.ps1">Click on this link</a>

Right-Click on the page
Click Save-As
Save the file as a .ps1 (or file type 'all files') file in a directory that you want to run it from. (I typically do the C: drive for convenience)
Open Powershell as an administrator and type (in my case) 

    cd /
    
Press ENTER and type 

    Set-ExecutionPolicy Unrestricted
    
Press ENTER and approve all prompts. Then type

    ./BreachSecureNowAzureADSetup.ps1

Press ENTER and you will be prompted to sign-in as an administrator on Office 365.

Please reach out with any comments, questions, or concerns.
