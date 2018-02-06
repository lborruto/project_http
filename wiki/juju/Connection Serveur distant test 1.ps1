$secpasswd = ConvertTo-SecureString "Nope" -AsPlainText -force
$c = New-Object System.Management.Automation.PSCredential ("root", $secpasswd)
New-SSHSession -ComputerName "169.254.5.96" -Credential ($c) -KeyFile C:\Users\Administrateur\.ssh\ssh_host_rsa_key -ConnectionTimeout 50