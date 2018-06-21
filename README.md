# jamf API scripts
Some scripts I created to interact with the jamf api in various senarios

# Scripts
- **Device_Name.sh**

    Uses the jss id to push a name to a device. 
      
      - By default this script will expect 2 arguments (the first being the jssid then the name you wish to use)
          
          i.e. device_rename.sh 1828 test_name
      
      - Set variables at the top of the script before running (the script will prompt for all variable information when ran if nothing is specified)
