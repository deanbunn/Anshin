<#
    Script: dark_bkup.ps1
    Author: Dean Bunn
    Last Edited: 2024-06-01
#>

#Add Compression Assembly to Instance
Add-Type -assembly "system.io.compression.filesystem";

#Array for Custom Backup Objects
$arrBackupSrcs = @();

#Load Custom Backup Objects
#$arrBackupSrcs += New-Object PSObject -Property (@{ ProfileFolderLoc="\.aws"; BackupFileName="_aws.zip"; });
$arrBackupSrcs += New-Object PSObject -Property (@{ ProfileFolderLoc="\.ssh"; BackupFileName="_nogler.zip"; });
$arrBackupSrcs += New-Object PSObject -Property (@{ ProfileFolderLoc="\Pictures"; BackupFileName="_pictures.zip"; });
$arrBackupSrcs += New-Object PSObject -Property (@{ ProfileFolderLoc="\DarkDocs"; BackupFileName="_documents.zip"; });
$arrBackupSrcs += New-Object PSObject -Property (@{ ProfileFolderLoc="\source"; BackupFileName="_source.zip"; });

#Var for Host
[string]$bckhost = $env:COMPUTERNAME;

#Var for Current User
[string]$bckuser = $env:USERNAME;

#Get Current Short Date
[string]$rptDate = (Get-Date).ToString("yyyyMMdd");

#Var for User Profile Location
[string]$bckUsrPrfldr = "C:\Users\" + $bckuser;

#Var Backup Location
[string]$bckfldr = $bckUsrPrfldr + "\DarkBackups\" + $bckhost + "_" + $rptDate;

#Create Backup Folder
New-Item $bckfldr -ItemType Directory;

#Check to See Local Backup Location Exists
if(Test-Path $bckfldr)
{

    foreach($bksl in $arrBackupSrcs)
    {

        #Var for Profile Folder to Backup
        [string]$bckPFTB = $bckUsrPrfldr + $bksl.ProfileFolderLoc;

        #Var for Backup Zip File Name
        [string]$bckBZFN = $bckfldr + "\" + $bckhost.ToLower() + "_" + $rptDate + $bksl.BackupFileName;

        #Check to See If Zip Backup File Exists Already. If Not Create It
        if((Test-Path $bckBZFN) -eq $false)
        {
            #Create Zip File of Folder in Backup Location
            [io.compression.zipfile]::CreateFromDirectory($bckPFTB, $bckBZFN);

        }#End of Backup File Exists Check

       
    }#End of $arrBackupSrcs Foreach

    #Var for Remove Backups Date
    [datetime]$rmvDate = (Get-Date).AddDays(-14);

    #Remove Old Backup Items
    Get-ChildItem -Path $bckfldr | Where-Object {$_.CreationTime -lt $rmvDate -and $_.Name.StartsWith($bckhost.ToLower()) } | Remove-Item -Force #-Recurse

}#End of Test Path on Backup Folder Location
