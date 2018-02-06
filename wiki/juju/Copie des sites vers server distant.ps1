$computerNameIP = "192.168.1.18"
$computerNameIP2 = "169.254.5.96"
$folderToSend = "C:\Shares\partageProjet\"
$remoteLocation = "/tmp/partageProjet/"
$keyFileLocation = "C:\Users\Administrateur\.ssh\ssh_host_rsa_key"
$secpasswd = ConvertTo-SecureString "Whatever" -AsPlainText -force
$credential = New-Object System.Management.Automation.PSCredential ("root", $secpasswd)

Set-SCPFolder -ComputerName $computerNameIP -Credential $credential -KeyFile $keyFileLocation -ConnectionTimeout 50 -LocalFolder $folderToSend -RemoteFolder $remoteLocation -Force
Set-SCPFolder -ComputerName $computerNameIP2 -Credential $credential -KeyFile $keyFileLocation -ConnectionTimeout 50 -LocalFolder $folderToSend -RemoteFolder $remoteLocation -Force
