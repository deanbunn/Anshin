#!/bin/bash

#Var for Uptime Wait Seconds Before Creating Backups
bckwaitseconds=1800

#Var for Host 
bckhost=$(uname -n)

#Var for User
bckuser=$(id -u -n)

#Var for Backup Directory
bckfldr="/home/$bckuser/DarkBackups/$bckhost""_$(date +'%Y%m%d')/"

#Check for Backup Folder
if [ ! -e $bckfldr ]; then

    mkdir $bckfldr

fi

#Var for Backup File for DarkDocs Folder Daily
bckfiledarkdocs=$bckfldr$bckhost"_$(date +'%Y%m%d')_darkdocs.zip"

#Var for Backup File for DarkRepos Folder Daily
bckfiledarkrepos=$bckfldr$bckhost"_$(date +'%Y%m%d')_darkrepos.zip"

#Var for Backup File for Documents Folder Daily
bckfiledoc=$bckfldr$bckhost"_$(date +'%Y%m%d')_documents.zip"

#Var for Backup File for Remmina Settings
#bckfileremmina=$bckfldr$bckhost"_$(date +'%Y%m%d')_remminas.zip"

#Var for Backup File for Pictures 
bckfilepics=$bckfldr$bckhost"_$(date +'%Y%m%d')_pictures.zip"

#Var for Backup File for Background Pics
bckfilebackgrounds=$bckfldr$bckhost"_$(date +'%Y%m%d')_backgrounds.zip"

#Var for Backup File for SSH 
bckfilessh=$bckfldr$bckhost"_$(date +'%Y%m%d')_ssh.zip"

#Var for Backup File for Vim
bckfilevim=$bckfldr$bckhost"_$(date +'%Y%m%d')_vim.txt"

#Check for Daily Already Taken
if [ $(awk '{print int($1)}' /proc/uptime) -gt $bckwaitseconds ] && [ ! -f $bckfiledoc ]; then

	#Zip Command to Backup DarkDocs Folder
	zip -r $bckfiledarkdocs /home/$bckuser/DarkDocs

	#Zip Command to Backup DarkRepos Folder
	zip -r $bckfiledarkrepos /home/$bckuser/DarkRepos

	#Zip Command to Backup Documents Folder
	zip -r $bckfiledoc /home/$bckuser/Documents

	#Zip Command to Backup Remmina Settings
	#zip -r $bckfileremmina /home/$bckuser/.local/share/remmina

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
#find $bckfldr -mtime +5 -name $bckhost* -type f -delete
