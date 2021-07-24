<#
    Script: dark_bkup.ps1
    Last Edited: 2021-05-17
#>

#Add Compression Assembly to Instance
Add-Type -assembly "system.io.compression.filesystem";

#Array for Custom Backup Objects
$arrBackupSrcs = @();

#Load Custom Backup Objects
$arrBackupSrcs += New-Object PSObject -Property (@{ ProfileFolderLoc="\Documents\Repos"; BackupFileName="_repos.zip"; });
$arrBackupSrcs += New-Object PSObject -Property (@{ ProfileFolderLoc="\Documents\DevOps"; BackupFileName="_devops.zip"; });
$arrBackupSrcs += New-Object PSObject -Property (@{ ProfileFolderLoc="\Documents\RDPHosts"; BackupFileName="_rdphosts.zip"; });
$arrBackupSrcs += New-Object PSObject -Property (@{ ProfileFolderLoc="\Documents\UCDTermReports"; BackupFileName="_ucdtermreports.zip"; });
$arrBackupSrcs += New-Object PSObject -Property (@{ ProfileFolderLoc="\Pictures"; BackupFileName="_pictures.zip"; });

#Var for Host
[string]$bckhost = $env:COMPUTERNAME;

#Var for Current User
[string]$bckuser = $env:USERNAME;

#Get Current Short Date
[string]$rptDate = (Get-Date).ToString("yyyyMMdd");

#Var for User Profile Location
[string]$bckUsrPrfldr = "C:\Users\" + $bckuser;

#Var Backup Location (Sync'd with Insync)
[string]$bckfldr = $bckUsrPrfldr + "\Insync\deanbunn@gmail.com\Dark_Backups";


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
    [datetime]$rmvDate = (Get-Date).AddDays(-5);

    #Remove Old Backup Items
    Get-ChildItem -Path $bckfldr | Where {$_.CreationTime -lt $rmvDate -and $_.Name.StartsWith($bckhost.ToLower()) } | Remove-Item -Force #-Recurse


}#End of Test Path on Backup Folder Location
