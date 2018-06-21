# jamf API scripts
Some scripts I created to interact with the jamf api in various senarios

# Scripts
- **Device_Name.sh**

    Uses the jss id to push a name to a device. 
      
      - By default this script will expect 2 arguments (the first being the jssid then the name you wish to use)
          
          i.e. device_rename.sh 1828 test_name
      
      - Set variables at the top of the script before running (the script will prompt for all variable information when ran if nothing is specified)
    
 - **JAMF API Computer Lookup Script.sh**
    
    - My first jamf API Script "jamf API Computer Lookup" asks for jamf API info (if not supplied in the user defined variables), then asks to search via Serial Number, UDID , Mac Address, or Computer name. The script then asks for the criteria you selected and searches jamf returning the following info for that machine. More fields can be added by editing after line 141 and adding the echo at the end.
   -  Computer Name, Username, Email Address, Serial Number, IP Address, Last Check-in
