       ###############################################################################
        #                                                                             #
        # Name:         FS_CPS_Check .sh                                              #
        #                                                                             #
        # Description:  Script to Check the bounce time of SystemX Web servers        #
        #                                                                             #
        # Usage:        To check the file capacity of CPS Servers                     #
        #                                                                             #
        # Author:       Nadeem Khan(nk815q)                                           #
        #                                                                             #
        # Version:      1.0                                                           #
        #                                                                             #
        ###############################################################################


    sendmail="/usr/sbin/sendmail -t"
    mail_from="From: nk815q@att.com"
  # mail_to="To: DL-RPS@att.com mm726s@att.com nk815q@att.com"
    mail_to="To: nk815q@att.com ns830w@att.com"
    generatehtml1="/home/m69642/RPSScripts/nk815q/CPS_MGD.html"
    echo "MIME-Version: 1.0" >>$generatehtml1
    echo $mail_from >>$generatehtml1
    echo $mail_to >>$generatehtml1
    mail_subject="Subject: CPS Filesystem status"
    echo $mail_subject `date '+ %m/%d/%y - %H:%M:%S PDT'` >>$generatehtml1
    echo "Content-Type: text/html " >>$generatehtml1
        echo "<html><head>" >>$generatehtml1
        echo "<style type="text/css">" >>$generatehtml1

        echo ".tab1 { border:1px solid;width:200px ;color:#12c174;background-color:FFF5EE;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
        echo ".tab2 {  border:1px solid;width:200px ;color:Blue;background-color:FFF5EE;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
        echo ".tab3 { border:1px solid;width:200px ;color:Green;background-color:#FFDAB9;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
		echo ".tab4 { border:1px solid;width:200px ;color:red;background-color:#FFDAB9;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
		echo "************** This Script is for following Applications **************  "
		echo " Press "
		echo "1 for CPS (Snapshot)"
		echo "2 for OPUS "
		echo "3 for LMTv2"
		echo "4 for CSCR"
        echo "</style></head><body>" >>$generatehtml1
        echo "<p>Click here to get <a href="https://workspace.web.att.com/sites/ETM/RPS/Reference/Quick%20Links/CPS_Linux_QuickLinks_v1.0.mht"> CPS  QUICKLINK </p>" >>$generatehtml1
        echo "<table cellpadding="5" cellspacing="5" border="1" width="600px" align="left">" >>$generatehtml1
        echo "<th> CPS Server </th> <th> FS CAPACITY</th> <th>INODE CAPACITY</th>" >>$generatehtml1
        App="1"
		case "$App" in
		"1") echo "You have selected CPS (Snapshot)" 
		Serv=`cat CPS_Mgd.lst`
		;;
		"2") echo "You have selected OPUS" 
		vtier=`cat CPS_Mgd.lst`
		;;
		"3") echo "You have selected LMTv2" 
		Serv=`cat LMT_Serv.lst`
		;;
		"4") echo "You have selected CSCR" 
		Serv=`cat CSCR_Serv.lst`
		;;		
		
        for vtier in Serv
                do

                                #a=`df -kh .|tail -1| tr -s ' ' | cut -d' ' -f5`
                                #b=`df -i .|tail -1| tr -s " " | cut -d" " -f5`
                                        #PS_FS=`"$a"|tr -s ' '|cut -d' ' -f5 |tr ' ' '\t'|tail -1 `
                                                CPS_FS=`sshcmd -u ${vtier} -s ${vtier} "df -kh .|tail -1| tr -s ' ' | cut -d' ' -f5|sed 's/%//' "|tr ' ' '\t'|tail -1 `
                                                CPS_Inode=`sshcmd -u ${vtier} -s ${vtier} "df -i .|tail -1| tr -s ' ' | cut -d' ' -f5|sed 's/%//' "|tr ' ' '\t'|tail -1 `
                                                #CPS_Inode=`sshcmd -u ${vtier} -s ${vtier} "`df -kh .|tail -1| tr -s ' ' | cut -d' ' -f5`"|tr -s ' '|cut -d' ' -f5 |tr ' ' '\t'|tail -1 `
#sed 's/%//gi' $generatehtml1
#        [$CPS_FS -ge 80]
#                                               then
#                                               echo "<tr><td class="tab3">$vtier</td> <td class="tab4">$CPS_FS</td><td align="center" class="tab2">$CPS_Inode</td>"  >>$generatehtml1
#                     echo "</tr>" >> $generatehtml1
#fi
#                                               [$CPS_Inode -gt 90 ]
#                                               then
#                                                       echo "<tr><td class="tab3">$vtier</td> <td class="tab2">$CPS_FS</td><td align="center" class="tab4">$CPS_Inode</td>"  >>$generatehtml1
#                       echo "</tr>" >> $generatehtml1
#                                               else
                                                        echo "<tr><td align="center" class="tab3">$vtier</td> <td align="center" class="tab2">$CPS_FS</td><td align="center" class="tab2">$CPS_Inode</td>"  >>$generatehtml1
                                                echo "</tr>" >> $generatehtml1
#                                               fi

                done
        ### To Check the File capacity status of CPS servers :
#        for vtier in `cat CPS_Mgd.lst`
 #               do
                        #       sshcmd -u $vtier -s $vtier
                        #       a=`df -kh .|tail -1| tr -s " " | cut -d" " -f5`
                        #       b=`df -i .|tail -1| tr -s " " | cut -d" " -f5`
                        #           CPS_FS=`"$a"|tr -s ' '|cut -d' ' -f5 |tr ' ' '\t'|tail -1 `
                        #          CPS_Inode=`"$b"|tr -s ' '|cut -d' ' -f5 |tr ' ' '\t'|tail -1 `
    #                    echo "<tr><td class="tab3">$vtier</td> <td class="tab2">$CPS_FS</td><td class="tab2">$CPS_Inode</td>"  >>$generatehtml1
   #                     echo "</tr>" >> $generatehtml1
  #              done
    echo "</table>" >>$generatehtml1
    echo "</body>" >>$generatehtml1
    echo "</html>" >>$generatehtml1
    cat $generatehtml1 | $sendmail
    echo "script executed successfully !!!!"
    rm $generatehtml1
