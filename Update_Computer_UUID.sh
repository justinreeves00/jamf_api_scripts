#!/bin/sh

#Created By Justin Reeves 2016
#This script was created to fix the "Device Signature Error" message 
#This script pulls the UUID and Serial from the machine it is being excecuted on and checks that the UUID is different from what JSS is reporting, if it is the script updates the record with the actual UUID
#
#
#User Defined Variables
##################################################

#only enter full domain name no https needed (Leave blank to be prompted during excecution)
url=
port=8443

#API user credintials (Leave blank to be prompted during excecution)
user=
pass=

##################################################


#Text Formatting for Results
bold=$(tput bold)
normal=$(tput sgr0)

#logic for User Defined Variables

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

#Commands below pull the executing computers UUID and Serial Number for use in updating the JSS Record
currentserial=$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $4}')
currentuuid=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F\" '/UUID/{print  $(NF-1)}')
#Information being pushed to JSS
apiData="<computer><general><udid>$currentuuid</udid></general></computer>"
#currently reported UUID in the JSS
reported_uuid=$(curl -H "Accept: application/xml" -sfku "${user}:${pass}" https://${url}:${port}/JSSResource/computers/serialnumber/${currentserial} | xpath /computer/general/udid 2>/dev/null | awk -F'>|<' '/udid/{print $3}')

if [[ $reported_uuid = $currentuuid ]]; then
	echo "Computer UUID and JSS Reported UUID Match"
	echo "Exiting Script"
else
	echo "JSS Record Does not Match Current UUID"
	echo "Updating Record UUID in the JSS"
    output=`curl -sS -k -i -u ${user}:${pass} -X PUT -H "Content-Type: text/xml" -d "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>${apiData}" https://${url}:${port}/JSSResource/computers/serialnumber/${currentserial}`
fi