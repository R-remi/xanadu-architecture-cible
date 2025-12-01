# Script: New-XanaduUser.ps1
# Usage: ./New-XanaduUser.ps1 -Nom "Doe" -Prenom "John" -Service "RH"
# Contextualisation : Permet aux correspondants informatiques de créer des comptes standardisés sans erreurs.
param(
    [Parameter(Mandatory=$true)][string]$Nom,
    [Parameter(Mandatory=$true)][string]$Prenom,
    [Parameter(Mandatory=$true)][ValidateSet("RH","COMPTA","BE","COMMERCIAL")][string]$Service
)

# Configuration des variables
$Domain = "xanadu.local"
$Password = ConvertTo-SecureString "ChangeMe123!" -AsPlainText -Force # Mdp temporaire
$OU_Base = "OU=$Service,OU=Utilisateurs,DC=xanadu,DC=local"
$SamAccount = ($Prenom.Substring(0,1) + $Nom).ToLower()

try {
    # Création de l'utilisateur
    New-ADUser -Name "$Prenom $Nom" `
               -SamAccountName $SamAccount `
               -UserPrincipalName "$SamAccount@$Domain" `
               -AccountPassword $Password `
               -ChangePasswordAtLogon $true `
               -Enabled $true `
               -Path $OU_Base `
               -Description "Utilisateur du service $Service"

    # Ajout au groupe du service (Gestion des droits fichiers)
    Add-ADGroupMember -Identity "GRP_$Service" -Members $SamAccount
    
    Write-Host "Utilisateur $SamAccount créé avec succès dans $Service." -ForegroundColor Green
}
catch {
    Write-Error "Erreur lors de la création : $_"
}

# ///////

#!/bin/bash
# Script: backup_erp_db.sh
# Cron: 0 23 * * * /scripts/backup_erp_db.sh
# Contextualisation : Remplace le script manuel actuel. S'exécute sur le serveur PostgreSQL.

BACKUP_DIR="/mnt/nas_backups/erp_dumps"
DATE=$(date +%Y%m%d_%H%M)
DB_NAME="prod"
FILENAME="erp_backup_$DATE.sql"

# Vérification du montage du NAS
if ! mountpoint -q /mnt/nas_backups; then
    echo "Erreur : Le NAS n'est pas monté." | mail -s "Alerte Backup ERP" admin@xanadu.local
    exit 1
fi

# Dump de la base
pg_dump $DB_NAME > $BACKUP_DIR/$FILENAME #Ici, on part du principe qu'on a la db a backup sur postgres

# Vérification du code de retour
if [ $? -eq 0 ]; then
    echo "Sauvegarde ERP réussie : $FILENAME"
    # Rétention : Supprimer les dumps de plus de 7 jours
    find $BACKUP_DIR -name "erp_backup_*.sql" -mtime +7 -delete
else
    echo "ECHEC de la sauvegarde ERP" | mail -s "URGENT: Echec Backup ERP" admin@xanadu.local
fi

# Script: Get-SoftwareInventory.ps1
# Contextualisation : Vérifie la présence de logiciels interdits ou non standardisés.
$Computer = $env:COMPUTERNAME
$Software = Get-WmiObject -Class Win32_Product | Select-Object Name, Version

# Export CSV pour analyse centrale
$Software | Export-Csv -Path "\\NAS\Inventaire\Softs_$Computer.csv" -NoTypeInformation

# ///////

# Script: Check-BackupStatus.ps1
# Contextualisation: Vérifie qu'un fichier a bien été créé sur le NAS aujourd'hui.
$BackupPath = "\\NAS\Backups\ERP"
$Threshold = (Get-Date).AddHours(-24)

$LatestFile = Get-ChildItem $BackupPath | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($LatestFile.LastWriteTime -lt $Threshold) {
    # Alerte critique
    Send-MailMessage -To "admin@xanadu.local" -Subject "ALERTE: Pas de sauvegarde ERP récente" -Body "Dernière sauvegarde date de $($LatestFile.LastWriteTime)" -SmtpServer "smtp.xanadu.local"
} else {
    Write-Host "Sauvegarde OK datant de $($LatestFile.LastWriteTime)"
}

# ///////

# Script: Disable-StaleUsers.ps1
# Contextualisation : Supprime les comptes innactif depuis 90 jours de l'ad
$DaysInactive = 90
$TimeLimit = (Get-Date).AddDays(-$DaysInactive)

# Recherche des comptes inactifs
$StaleUsers = Get-ADUser -Property LastLogonDate -Filter {LastLogonDate -lt $TimeLimit -and Enabled -eq $true}

ForEach ($User in $StaleUsers) {
    Disable-ADAccount -Identity $User
    Write-Host "Compte $($User.SamAccountName) désactivé (Inactif depuis $DaysInactive jours)" -ForegroundColor Yellow
    # Log de l'action
    Add-Content -Path "C:\Admin\Logs\StaleUsers.log" -Value "$(Get-Date) - Désactivation de $($User.SamAccountName)"
}

# ///////

# Script: Audit-LocalAdmins.ps1
# A déployer via GPO script de démarrage ou exécution à distance
# Contextualisation : Détecte si des utilisateurs se sont remis admin de leur poste.
$Computers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name

ForEach ($PC in $Computers) {
    Try {
        $Admins = Invoke-Command -ComputerName $PC -ScriptBlock {
            Get-LocalGroupMember -Group "Administrateurs" | Where-Object {$_.ObjectClass -eq "Utilisateur"}
        } -ErrorAction Stop
        
        If ($Admins) {
            Write-Host "ALERTE sur $PC : Utilisateurs dans le groupe Admin !" -ForegroundColor Red
            $Admins | ForEach-Object { Write-Host " - $($_.Name)" }
        }
    } Catch {
        Write-Host "Impossible de scanner $PC" -ForegroundColor Gray
    }
}

# ///////

# Contextualisation : Script de logon (GPO) pour monter les lecteurs selon le service.
# Script: Logon-DriveMaps.ps1
# Supprime les anciens mappages
Get-SmbMapping | Remove-SmbMapping -Force

# Lecteur Personnel (H:)
New-SmbMapping -LocalPath 'H:' -RemotePath "\\SRV-FICHIER\Homes\$env:USERNAME"

# Lecteur Service (S:) - Logique conditionnelle
$UserGroups = ([System.Security.Principal.WindowsIdentity]::GetCurrent()).Groups.Translate([System.Security.Principal.NTAccount])

if ($UserGroups.Value -contains "XANADU\GRP_RH") {
    New-SmbMapping -LocalPath 'S:' -RemotePath "\\SRV-FICHIER\Service_RH"
}
elseif ($UserGroups.Value -contains "XANADU\GRP_BE") {
    New-SmbMapping -LocalPath 'S:' -RemotePath "\\SRV-FICHIER\Service_BE"
}

# ///////

# Contextualisation : Durcissement des postes clients.
# Script: Secure-LocalFirewall.ps1
# Active le pare-feu sur tous les profils
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

# Bloque le partage de fichiers entrant sur les PC (protection latérale)
Disable-NetFirewallRule -DisplayGroup "Partage de fichiers et d'imprimantes"

Write-Host "Pare-feu local durci."

# ///////

# Contextualisation : Évite l'arrêt de production par disque plein.
# Script: Check-DiskSpace.ps1
$Disks = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3"

ForEach ($Disk in $Disks) {
    $FreeSpaceGB = [math]::Round($Disk.FreeSpace / 1GB, 2)
    $PercentFree = [math]::Round(($Disk.FreeSpace / $Disk.Size) * 100, 2)
    
    If ($PercentFree -lt 10) {
        Write-Host "CRITIQUE : Disque $($Disk.DeviceID) espace faible ($PercentFree %)" -ForegroundColor Red
        # Ici on pourrait appeler une API de monitoring ou envoyer un mail
    }
}

# ///////

#!/bin/bash
# Contextualisation : Recherche des tentatives de connexion SSH échouées sur les serveurs Linux du Labo.
# Script: check_ssh_auth.sh
LOG_FILE="/var/log/auth.log"
THRESHOLD=5

# Compte les échecs par IP
grep "Failed password" $LOG_FILE | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr > /tmp/bad_ips.txt

while read count ip; do
    if [ "$count" -gt "$THRESHOLD" ]; then
        echo "Alerte : IP $ip a échoué $count fois la connexion SSH."
        # Action possible : Bannir l'IP via iptables (décommenter la ligne suivante)
        # iptables -A INPUT -s $ip -j DROP
    fi
done < /tmp/bad_ips.txt
