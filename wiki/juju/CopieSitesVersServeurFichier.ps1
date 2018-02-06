$Date = (Get-Date).Date

$File = Get-ChildItem "C:\Projects\"

foreach($element in $File){
    if($element.LastWriteTime.Date -eq $Date){
        Copy-Item -Path $element.FullName -Destination "\\WIN-LVR78K5NQBE\partageProjet\"
    }
}

