$basebackupfolder="C:\Projects\Historique"
$basesourcefolder="C:\Projects\Sites"
$logfile="C:\Projects\sauvegarde.log.txt"
$maxlivebackup=14

$backupFolder= $basebackupfolder+"\"+(date -format "\sauv-dd-MM-yyyy")
Add-Content $logfile "===================="
Add-Content $logfile (date)
Write-Output "Sauvegarde des sites de $basesourcefolder dans $backupFolder"
Add-Content $logfile "Sauvegarde des sites de $basesourcefolder dans $backupFolder"

if(Test-Path $backupFolder){
    write-output "Le dossier de sauvegarde existe déjà"
    Add-Content $logfile "Le dossier de sauvegarde existe déjà"
} else {
    New-Item -ItemType directory -Path $backupFolder
    $sites=(Get-ChildItem -Path $basesourcefolder)
    foreach($site in $sites){
        Copy-Item $site.FullName -Destination $backupFolder
        Write-Output "Fichier $site copié"
        Add-Content $logfile "Fichier $site copié"
    }
}

$sauvegardes=(Get-ChildItem -Path $basebackupfolder)
foreach($sauvegarde in $sauvegardes){
    $sauvegardedate=(date $sauvegarde.BaseName.Substring($sauvegarde.BaseName.IndexOf("-")+1))
    $sauvegardespan=((date)-$sauvegardedate)
    if($sauvegardespan.Days -cgt $maxlivebackup){
        Write-Output "Suppression de la sauvegarde $sauvegarde vielle de plus de $maxlivebackup jours"
        Add-Content $logfile "Suppression de la sauvegarde $sauvegarde vielle de plus de $maxlivebackup jours"
        Remove-Item $sauvegarde.FullName -Recurse
    }
}