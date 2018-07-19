#################################################


	Script to reduce file size 
	
	
	
	
	#####################################333

	
	
	#!/bin/bash

##### Directories to search (also include in the for loop below) ######
LOC="$HOME/logs"



##### Archive logs older than 7 days, gzip older than 30 days and delete them if older than 90days ######
    for LOC in $LOC
        do
        cd $LOC
        ####Searching for archive directory , also creating it if its not present.
        echo "Searching for logs with lagest no . of inodes ."
		inode = "df -i ."
    if [ inode ge 85 ]
     then
        inode1= "find . -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort -n"
		echo "$inode1"
		echo "Choose which file/Directory  needs to be deleted"
     else
      echo "archive directory is already created to move logs files older than 30 days"
    fi

    ####Moving logs older than 7 days to archive directory

    if [ -d "archive" ]
     then
     echo "Moving logs older than 7 days to archive directory"
      ls -F .|grep -v /| xargs -I {} find ./{} -mtime +7 -exec mv {} archive \;
    fi
    cd $LOC/archive
        ####Zipping logs older than 30 days and deleting logs older than 90 days
    if [ "$?" == "0" ]
     then
        echo "Zipping logs older than 30 days and deleting logs older than 90 days"
      ls -F .|grep -v /| xargs -I {} find ./{} -mtime +30 -exec gzip {} \;
      #ls -F .|grep -v /| xargs -I {} find ./{} -mtime +120 -exec rm {} \;
    fi
	echo $X

        done





