#!/bin/bash

#Var for Host 
bckhost=$(uname -n)

#Var for User
bckuser=$(id -u -n)

#Var for Backup Directory
bckfldr="/home/$bckuser/Insync/deanbunn@gmail.com/Dark_Backups/"

#Var for Backup File for Documents Folder Daily
bckfiledoc=$bckfldr$bckhost"_$(date +'%Y%m%d')_documents.zip"

#Var for Backup File for Remmina Settings
bckfileremmina=$bckfldr$bckhost"_$(date +'%Y%m%d')_remminas.zip"

#Var for Backup File for Pictures 
bckfilepics=$bckfldr$bckhost"_$(date +'%Y%m%d')_pictures.zip"

#Var for Backup File for Background Pics
bckfilebackgrounds=$bckfldr$bckhost"_$(date +'%Y%m%d')_backgrounds.zip"

#Var for Backup File for SSH 
bckfilessh=$bckfldr$bckhost"_$(date +'%Y%m%d')_ssh.zip"

#Var for Backup File for Vim
bckfilevim=$bckfldr$bckhost"_$(date +'%Y%m%d')_vim.txt"

#Check for Daily Already Taken
if [ ! -f $bckfiledoc ]; then

	#Zip Command to Backup Documents Folder
	zip -r $bckfiledoc /home/$bckuser/Documents

	#Zip Command to Backup Remmina Settings
	zip -r $bckfileremmina /home/$bckuser/.local/share/remmina

	#Zip Command to Backup Pictures Folder
	zip -r $bckfilepics /home/$bckuser/Pictures

	#Zip Command to Backup Backgrounds
	zip -r $bckfilebackgrounds /home/$bckuser/.local/share/backgrounds

	#Zip Command to Backup SSH
	zip -r $bckfilessh /home/$bckuser/.ssh 

	#Copy Command to Backup VIM Config
	cp /home/$bckuser/.vimrc $bckfilevim

fi

#Remove Backup Files Older than 5 Days for this System
find $bckfldr -mtime +5 -name $bckhost* -type f -delete
