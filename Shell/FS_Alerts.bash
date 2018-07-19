###############################################################################
#                                                                             #
# Name:         InodeZip.sh                                                   #
#                                                                             #
# Description:  This script is to zip log files ................              #
#                                                                             #
# Usage:        To determine inode,File capacity and reduce it                #
#                                                                             #
# Author:       Nadeem khan (nk815q)                                          #
#                                                                             #
# Date:         11/06/2017                                                    #
#                                                                             #
###############################################################################

#!/bin/bash
CPS_FS =`sshcmd -u $1 -s $1 "df -kh .|tail -1| tr -s ' ' | cut -d' ' -f5|sed 's/%//' "|tr ' ' '\t'|tail -1 `
CPS_Inode =`sshcmd -u $1 -s $1 "df -i .|tail -1| tr -s ' ' | cut -d' ' -f5|sed 's/%//' "|tr ' ' '\t'|tail -1 `
sshconnect -s $i -u $i
cd logs
files = `sshcmd -u $1 -s $1 "du -sh *|sort -rn|tail -15|cut -d' ' -f2"|tr ' ' '\t'|tail -1 ` > vtier.txt
for dir in `cat vtier.txt`
do
    if [ -d "$dir" ]; then
        cd "$dir"
        gzip csi.xml
        cd ..
    fi
done







LOC="$HOME/logs"
    for LOC in $LOC
        do
        cd $LOC
        tarfile=`tar -tvf tarfile.tar | grep some_file | grep "$date"`
		
		Inode_per="df -i .|tail -1| tr -s " " | cut -d" " -f5"
		Disk_per="df -kh .|tail -1| tr -s " " | cut -d" " -f5"
		
		if["$inode_per" ge 95%]
			for Dir in loc; do
			if [ -d "$Dir" ]; then
				cd "$Dir"
					log=find . -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort -n
					echo "$log"
					echo "Enter file/directory to be deleted : "
					
				cd ..
			fi
			done
		fi
		if["$Disk_per" ge 85%]
			for Dir in loc; do
			if [ -d "$Dir" ]; then
				cd "$Dir"
					if [ -f "$tarfile" ]; then
					zip csi_xml.tar
					fi
				cd ..
			fi
			done
	done

    