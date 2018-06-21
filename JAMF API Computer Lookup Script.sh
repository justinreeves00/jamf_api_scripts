#!/bin/bash

#Created By Justin Reeves 2016
#JAMF API script that will search by Serial, UDID, Computer Name, or MAC address and return information from the JSS
#This script does not make any changes to the JSS it only pulls information but please test in a test enviroment before running in your production enviroment.
#
#
#User Defined Variables
##################################################

#only enter full domain name no https needed (Leave blank to be prompted during excecution)
url=
port=

#API user credintials (Leave blank to be prompted during excecution)
user=
pass=


#criteria can be set as serialnumber , udid , name , or macaddress (Leave blank for menu selection during excecution)
criteria=



#Do not edit below this line unless you know what you are doing
################################################################



#Text Formatting for Results
bold=$(tput bold)
normal=$(tput sgr0)

#logic for User Defined Variables
###########################################
if [[ -z ${url} ]]; then
	echo "Please enter your JSS URL (without port number or slashes): "
read url
echo ""
fi

if [[ -z ${port} ]]; then
	echo "Please enter your JSS Port Number (Default is 8443): "
read port
echo ""
fi

if [[ -z ${user} ]]; then
	echo "Please enter your API Username: "
read user
echo ""
fi

if [[ -z ${pass} ]]; then
	echo "Please enter your API Password: "
	stty -echo
read pass
	stty echo
echo ""
fi

if [[ -z ${criteria} ]]; then
echo ""
	selection=0
	until [ "$selection" != 0 ]; do
    	echo ""
    	echo "${bold}Please Select what criteria to search${normal}"
    	echo "1 - Serial Number"
    	echo "2 - UDID"
    	echo "3 - Computer Name"
    	echo "4 - MAC Address"
    	echo ""
    	echo "Enter selection: "
    	read selection
    	echo ""
    	case $selection in
        	1 ) criteria=serialnumber ;;
        	2 ) criteria=udid ;;
        	3 ) criteria=name ;;
			4 ) criteria=macaddress;;
        	* ) echo "Please enter 1, 2, 3, or 4."
    	esac
	done

fi




#Logic for Serial , udid , Name , or Mac Address
##################################################
if [ $criteria = serialnumber ]
then
  #Ask for User input Serial Number
echo ""
echo "Please enter Computer's Serial Number: "
read input
echo ""
echo ""
fi

if [ $criteria = udid ]
then

  #Ask for User input udid
echo ""
echo "Please enter Computer's udid: "
read input
echo ""
echo ""
fi

if [ $criteria = name ]
then

  #Ask for User input Computer Name
echo ""
echo "Please enter the Full Computer Name: "
read input
echo ""
echo ""
fi

if [ $criteria = macaddress ]
then
 
  #Ask for User input mac address
echo ""
echo "Please enter Computer's MAC Address: "
read input
echo ""
echo ""
fi

#search JAMF API for information and parse the XML
username=$(curl -H "Accept: application/xml" -sfku "${user}:${pass}" https://${url}:${port}/JSSResource/computers/$criteria/${input} | xpath /computer/location/username[1] 2>/dev/null | awk -F'>|<' '/username/{print $3}' )
name=$(curl -H "Accept: application/xml" -sfku "${user}:${pass}" https://${url}:${port}/JSSResource/computers/$criteria/${input} | xpath /computer/general/name[1] 2>/dev/null | awk -F'>|<' '/name/{print $3}')
last_checkin=$(curl -H "Accept: application/xml" -sfku "${user}:${pass}" https://${url}:${port}/JSSResource/computers/$criteria/${input} | xpath /computer/general/last_contact_time 2>/dev/null | awk -F'>|<' '/last_contact_time/{print $3}')
email=$(curl -H "Accept: application/xml" -sfku "${user}:${pass}" https://${url}:${port}/JSSResource/computers/$criteria/${input} | xpath /computer/location/email_address 2>/dev/null | awk -F'>|<' '/email_address/{print $3}')
ip_address=$(curl -H "Accept: application/xml" -sfku "${user}:${pass}" https://${url}:${port}/JSSResource/computers/$criteria/${input} | xpath /computer/general/ip_address 2>/dev/null | awk -F'>|<' '/ip_address/{print $3}')
serial=$(curl -H "Accept: application/xml" -sfku "${user}:${pass}" https://${url}:${port}/JSSResource/computers/$criteria/${input} | xpath /computer/general/serial_number 2>/dev/null | awk -F'>|<' '/serial_number/{print $3}')


#check for errors and output information

if [[ -z "${serial}" ]]; then
	echo "${bold}An Error has occurred please Check your input and re-run the script${normal}"
	else
echo ""	
echo "${bold}Results Below:${normal}"
echo "-------------------------------"	
echo ""
echo "Computer Name:"
echo $name
echo ""
echo "Username:"
echo $username
echo ""
echo "Email Address:"
echo $email
echo ""
echo "Serial:"
echo $serial
echo ""
echo "IP Address:"
echo $ip_address
echo ""
echo "Last Check-in:"
echo $last_checkin
echo ""
fi
