#################################################################################
#                                                                               #
# Name:         defaultGatewayCheck_Menu.sh                                     #
#                                                                               #
# Description:  This is a Menu-Driven script to give Default gateway vaule for  #
#               the options specified in the menu and send O/P                  #
#                                                                               #
# Usage:        To Validate Default gateway for OPUS Servers                    #
#                                                                               #
# Author:       Amit Bisht (ab285w)                                             #
#                                                                               #
# Date:         05/07/16                                                        #
#                                                                               #
# Last Modifed: Prachi Mishra (pm228x)                                          #
#                                                                               #
# Comment:      mm726s : Making it more Generic and adding required mail DLs    #
#               ab285w : added html formating                                   #
#               pm228x : Script will now accept POD name as argument and will   #
#                        provide Default gateway vaule accordingly for OPUS     #
#                        Servers                                                #
#               pm228x : Menu-Driven Script with options for Single,multiple    #
#                        pods and Server list to provide Default gateway vaule  #
#                        accordingly for OPUS Servers in one single go          #
#                                                                               #
# Date:         08/15/2017                                                      #
#                                                                               #
#################################################################################

#!/bin/bash
# A menu driven shell script for checking default gateway.
## ----------------------------------
# Step #1: Define variables
# ----------------------------------

POD_DIR=/opt/app/opusshare/Podium/PODs/
HOST_DIR=host_lists
#HOME_DIR=/home/pm228x/pm228x/scripts
HOME_DIR=/home/m69642/OPUS_FilesystemTest
TEMP_FILE=$HOME_DIR/tempfile_`date +"%m%d%Y"`


##### Intializing Required Temp Files #####

LIST=$HOME_DIR/List1.txt
SERVER_LIST=$HOME_DIR/Server1.txt
> $LIST
> $SERVER_LIST



# ----------------------------------
# Step #2: User defined function
# ----------------------------------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

readValidate()
{
        #### Reading the Argument Passed ####
#FILE="$1"
echo -n "Enter a Pod name > "
read input

#### Check if the Argument is passed or not ####
if [[ $input -eq 0 ]] ; then
    echo "No arguments supplied. Please provide a valid POD name. E.g:linux-ssk-ww-pod-22"
        echo "The POD name exist at $POD_DIR"
        echo "Exiting from the script"
    exit
fi

cd $POD_DIR

#### Reading the Host File ###

if [ -d "$input" ];
then
           echo "$input Located"

           if [ -d $POD_DIR/$input/$HOST_DIR ];
           then
                echo "Extracting Host list from $HOST_DIR"
                cd $POD_DIR/$input/$HOST_DIR

                ######## Extracting VTIER from Host list #################

                find . -type f -exec cat {} \;|grep vci.att.com| cut -d '@' -f 1 >> $LIST

                find . -type f -exec cat {} \;|grep vci.att.com| cut -d '@' -f2|cut -d '\' -f1 >> $SERVER_LIST


          else
                echo "$HOST_DIR does not exist in $input."
                                echo "Exiting from the script"
             exit
           fi

else
           echo "$input does not exist. Please provide a valid POD name. e.g.: linux-ssk-ww-pod-22"
                   echo "Exiting from the script. "
           exit
fi

APPLICATION="$input"
SERVER_LIST=$SERVER_LIST
USER=$LIST


        checkDG $APPLICATION $USER $SERVER_LIST
#        pause
}
checkDG()
{
#        pause
        ##### Generating Default Gateway Check Report ######

SENDMAIL="/usr/sbin/sendmail -t";
MAIL_FROM="From: DL-RPS@att.com"
MAIL_TO="To:pm228x@att.com , mm726s@att.com"
#MAIL_TO="To:DL-RPS@att.com, ab285w@att.com, mm726s@att.com"
MAIL_SUBJECT="Subject: Default Gateway Check - $1"

echo "MIME-Version: 1.0" >>$TEMP_FILE
echo $MAIL_FROM >> $TEMP_FILE
echo $MAIL_TO >> $TEMP_FILE
echo $MAIL_SUBJECT >> $TEMP_FILE
echo "Content-Type: text/html " >> $TEMP_FILE

echo "<html><head> " >> $TEMP_FILE
echo "<style type="text/css">" >> $TEMP_FILE
echo ".tab {width:350px ;font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; border: 1px solid #000000;}" >> $TEMP_FILE
echo ".tab1 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; border: 1px solid #000000;width:150px ;}" >> $TEMP_FILE
echo "</style></head><body>" >> $TEMP_FILE
echo "<table><tr><th class="tab1">Server</th><th class="tab">Default Gateway</th><th class="tab">IP ADDRESS</th></tr>" >> $TEMP_FILE

##### Checking the Default Gateway and IP ADDRESS #####

echo "Checking Default Gateway for $1"
for server in `cat $2`
do
        DG=`sshcmd -u ${server} -s ${server} "/sbin/ip route " | tail -1 | awk '/default/ { print $3 }'`
        IP=`/usr/sbin/nslookup $server | tail -2 | head -1 | cut -f2 -d ":"`
        echo "<tr><td class="tab1">$server</td><td class="tab">$DG</td><td class="tab">$IP</td></tr>" >> $TEMP_FILE
done
echo "</table></body></html>" >> $TEMP_FILE
##### Sending Mail Report #####

echo "Check Complete dispatching the report to $MAIL_TO"
cat $TEMP_FILE | $SENDMAIL

#### Removing Temp File ####

if [[ $# -eq 3 ]]; then

        rm $TEMP_FILE $2 $3
else
        rm $TEMP_FILE
#exit
fi
}

multiplePods()
{
        echo -n "Enter number of pods to run Default Gateway for: >"
        read podnum

#       for i in '$podnum'
        for ((i=1; i <= $podnum; i++))
        do
                readValidate
        done

}
pods(){
#       echo "pods() called"
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~"
        echo " S U B - M E N U"
        echo "~~~~~~~~~~~~~~~~~~~~~"
        echo "1. Default Gateway for Single Pod"
        echo "2. Default Gateway for Multiple Pods"
        echo "3. Go back to Main Menu"

        read -p "Enter choice [ 1 - 3] " choice
        case $choice in
                1) readValidate ;;
#                       checkDG  ;;
                2) multiplePods ;;
                3) exitone ;;
                *) echo -e "Invalid Choice.Please enter choice [ 1 - 3]..." && sleep 2
        esac
        pause
}

list(){
#        pause

APPLICATION="OPUS/SSK-Default-Gateway-for-Server-List"

echo -n "Enter the absolute path of the File :E.g. /home/m69642/OPUS_FilesystemTest/DG_list.lst> "
read filepath

if [ -f "$filepath" ];
then
           echo "$filepath Located"
                SERVER1_LIST=$filepath

else
        echo "$filepath does not exist.Please provide valid path: E.g. /home/m69642/OPUS_FilesystemTest/DG_list.lst"
        echo "Exiting from the script"
    exit
fi

checkDG $APPLICATION $SERVER1_LIST

}

exitone()
{
        show_main_menu
}

# function to display menus
show_main_menu() {
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~"
        echo " M A I N - M E N U"
        echo "~~~~~~~~~~~~~~~~~~~~~"
        echo "1. Default Gateway for Pods"
        echo "2. Default Gateway for List"
        echo "3. Exit"
}
# read input from the keyboard and take a action
# invoke the pods() when the user select 1 from the main menu option.
# invoke the list() when the user select 2 from the main menu option.
# Exit when the user select 3 form the main menu option.
read_options(){
        local choice
        read -p "Enter choice [ 1 - 3] " choice
        case $choice in
                1) pods ;;
                2) list ;;
                3) exit 0;;
                *) echo -e "Invalid Choice.Please enter choice [ 1 - 3]..." && sleep 2
        esac
}

# -----------------------------------
# Step #3: Main logic
# ------------------------------------
while true
do

        show_main_menu
        read_options
done

