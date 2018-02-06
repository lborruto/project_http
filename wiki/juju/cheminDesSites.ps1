
$date = (get-Date).date
echo $date


foreach ($File.LastWriteTime.date)


$File=Get-ChildItem "C:\shares\partageProjet"
$File.LastWriteTime
# compresser le fichier
function Compress-ToZip
{
    param([string]$zipfilename)

    if(-not (test-path($zipfilename)))
    {
        set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
        (Get-ChildItem $zipfilename).IsReadOnly = $false    
    }
        
    $shellApplication = new-object -com shell.application
    $zipPackage = $shellApplication.NameSpace($zipfilename)
        
    foreach($file in $input) 
    { 
         $zipPackage.CopyHere($file.FullName)
         Start-sleep -milliseconds 500
    }
}
