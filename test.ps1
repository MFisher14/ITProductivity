Write-Host "Hello World"
ipconfig
Get-LocalUser


Add-Type -AssemblyName System.Windows.Forms

# Customize the message and title
$message = "Please call the IT Helpdesk at 555-1234 for assistance."
$title = "Helpdesk Notification"

# Show the message box
[System.Windows.Forms.MessageBox]::Show($message, $title, 'OK', 'Information')
