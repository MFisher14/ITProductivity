$sharePath = "E:\SharedFolder" ## Change this to your shared folder path
$yearToCheck = 2025 ## Change this to the year you want to check
# Get current date and date 2 months ago
$now = Get-Date
$twoMonthsAgo = $now.AddMonths(-2) ## Change this to adjust the recent activity window

# Get all files recursively
$files = Get-ChildItem -Path $sharePath -Recurse -File

# Count files with any activity in 2025
$activity2025Count = ($files | Where-Object {
    $_.LastWriteTime.Year -eq $yearToCheck -or
    $_.CreationTime.Year -eq $yearToCheck -or
    $_.LastAccessTime.Year -eq $yearToCheck
}).Count

# Filter files with activity in the past 2 months
$recentFiles = $files | Where-Object {
    $_.LastWriteTime -ge $twoMonthsAgo -or
    $_.CreationTime -ge $twoMonthsAgo -or
    $_.LastAccessTime -ge $twoMonthsAgo
}

# Count recent files
$recentCount = $recentFiles.Count

# Sort recent files by LastWriteTime descending
$sortedRecentFiles = $recentFiles | Sort-Object LastWriteTime -Descending

# Output counts
Write-Host "Files with activity in 2025: $activity2025Count"
Write-Host "Files with activity in the past 2 months: $recentCount"
$sortedRecentFiles | Select-Object FullName, CreationTime, LastAccessTime, LastWriteTime | Export-Csv -Path "C:\recent_activity.csv" -NoTypeInformation
