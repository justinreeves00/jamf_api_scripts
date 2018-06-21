#Created by Justin Reeves 2018
# Please test this script on a test device or in a test enviroment before using in production

# Read these instructions first!!!!!!!!
###################################################
# This script expects 2 arguments to be set after the script
# ie if the jss id was 1111 and you wanted the
# sh device_name.sh 11111 justin_ipad
# to hardcode the ID number and name of the device it can be changed at line #####
#
#User Defined Variables
##################################################

#only enter full domain name no https needed (Leave blank to be prompted during excecution)
url=
port=

#API user credintials (Leave blank to be prompted during excecution)
user=
pass=

#if you would rather hardcode the jssid and name to name the device you can enter it here (erase everything up to the equals sign to be prompted during exceution)
id=$1
name=$2


#Do not edit below this line unless you know what you are doing
################################################################


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

if [[ -z ${id} ]]; then
	echo "Please enter your jss ID of the device you wish to rename: "
	stty -echo
read id
	stty echo
echo ""

if [[ -z ${name} ]]; then
	echo "Please enter the name you would like to give the device: "
	stty -echo
read name
	stty echo
echo ""

renameipad=$(curl -H "Content-type: text/xml" -ksu ${user}:${pass} https://${url}:${port}/JSSResource/mobiledevicecommands/command/DeviceName/${name}/id/${id} -X POST)
