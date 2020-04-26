#!/bin/bash

#Var for Host 
bckhost=$(uname -n)

#Var for User
bckuser=$(id -u -n)

#Var for Backup Directory
bckfldr="/home/$bckuser/Insync/Dark_Backups/"

#Var for Backup File for Documents Folder Daily
bckfiledoc=$bckfldr$bckhost"_documents_$(date +'%Y%m%d').zip"

#Var for Backup File for Remmina Settings
bckfileremmina=$bckfldr$bckhost"_remminas_$(date +'%Y%m%d').zip"

#Var for Backup File for Pictures 
bckfilepics=$bckfldr$bckhost"_pictures_$(date +'%Y%m%d').zip"

#Check for Daily Already Taken
if [ ! -f $bckfiledoc ]; then

	#Zip Command to Backup Documents Folder
	zip -r $bckfiledoc /home/$bckuser/Documents

	#Zip Command to Backup Remmina Settings
	zip -r $bckfileremmina /home/$bckuser/.local/share/remmina

	#Zip Command to Backup Pictures Folder
	zip -r $bckfilepics /home/$bckuser/Pictures

fi

#Remove Backup Files Older than 14 Days for this System
find $bckfldr -mtime +14 -name $bckhost* -type f -delete
