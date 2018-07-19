        ###############################################################################
        #                                                                             #
        # Name:          DataBrokerLogCheck.sh                                                  #
        #                                                                             #
        # Description:  Script to Check the bounce time of SystemX Web servers        #
        #                                                                             #
        # Usage:        To check the datbroker logs	                          #
        #                                                                             #
        # Author:       Nadeem Khan(nk815q)                                           #
        #                                                                             #
        # Version:      1.0                                                           #
        #                                                                             #
        ###############################################################################

	dom=/opt/app/workload/jboss/domain/log
	serv=/opt/app/workload/jboss/domain/servers/server-one/log
    sendmail="/usr/sbin/sendmail -t"
    mail_from="From: nk815q@att.com"
   # mail_to="To: mm726s@att.com nk815q@att.com "
   #mail_to="To:'DL-RPS-Offshore@list.att.com'"i
    mail_to="To:mm726s@att.com  nk815q@att.com"
    #mail_to="Cc:mm726s@att.com nk815q@att.com "
    generatehtml1="/home/m69642/RPSScripts/TEAM/nk815q/logs/CPS_MGD.html"
    echo "MIME-Version: 1.0" >>$generatehtml1
    echo $mail_from >>$generatehtml1
    echo $mail_to >>$generatehtml1
    mail_subject="Subject: Databroker log check zlp09098 server"
    echo $mail_subject `date '+ %m/%d/%y - %H:%M:%S PDT'` >>$generatehtml1
    echo "Content-Type: text/html " >>$generatehtml1
        echo "<html><head>" >>$generatehtml1
        echo "<style type="text/css">" >>$generatehtml1

 echo ".tab1 { border:1px solid;width:200px ;color:#12c174;background-color:FFF5EE;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
        echo ".tab2 {  border:1px solid;width:200px ;color:Blue;background-color:FFF5EE;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
        echo ".tab3 { border:1px solid;width:200px ;color:Green;background-color:#FFDAB9;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
        echo ".tab4 {  border:1px solid;width:200px ;color:Red;background-color:FFF5EE;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
#        echo "<p> Check here for the  <a href="https://workspace.web.att.com/sites/ETM/RPS/Reference/Troubleshooting_Alert%20Handling/Interface_Alerts_Impacts_Defination_For_Retail_Application.xlsx"> Solution </p>" >>$generatehtml1

        echo "</style></head><body>" >>$generatehtml1
        echo "<p> Click here to get <a href="https://workspace.web.att.com/sites/ETM/RPS/Reference/Quick%20Links/CPS_Linux_QuickLinks_v1.0.mht"> CPS  QUICKLINK </p>" >>$generatehtml1
        echo "*****************************************************************************************************"
		echo "<h1 align ="center"> Domain logs </h1>"
		echo "*****************************************************************************************************"
		cd $dom
		ls-lrt
		time2="cd $serv ; ls -lrt|grep server.log" 

        for vtier in `cat CPS_Mgd.lst`
                        do
                                                CPS_FS=`sshcmd -u ${vtier} -s ${vtier} "df -kh .|tail -1| tr -s ' ' | cut -d' ' -f5|sed 's/%//' "|tr ' ' '\t'|tail -1 `
                                                CPS_Inode=`sshcmd -u ${vtier} -s ${vtier} "df -i .|tail -1| tr -s ' ' | cut -d' ' -f5|sed 's/%//' "|tr ' ' '\t'|tail -1 `
                                                Hostname=`sshcmd -u ${vtier} -s ${vtier} "hostname"|tr ' ' '\t'|tail -1 `
                                                if [[ $CPS_FS -ge 85 && $CPS_Inode -ge 95 ]] ; then
                                                echo "<tr><td align="center" class="tab3">$vtier ( $Hostname )</td> <td align="center" class="tab2"><b><p><a href="https://workspace.web.att.com/sites/ETM/RPS/Reference/Day%20-%20Day%20Miscellaneous/FS_CPS.txt"> <FONT COLOR=#ff0000> $CPS_FS </a></p></b></td><td align="center" class="tab2"><b><p><a href="https://workspace.web.att.com/sites/ETM/RPS/Reference/Day%20-%20Day%20Miscellaneous/Inode_CPS.txt"> <FONT COLOR=#ff0000> $CPS_Inode </a></p></b></td>"  >>$generatehtml1
                     echo "</tr>" >> $generatehtml1


                                                elif [[ $CPS_FS -ge 85 ]] ; then
                                                echo "<tr><td align="center" class="tab3">$vtier ( $Hostname )</td> <td align="center" class="tab2"><b><a href="https://workspace.web.att.com/sites/ETM/RPS/Reference/Day%20-%20Day%20Miscellaneous/FS_CPS.txt"> <FONT COLOR=#ff0000> $CPS_FS </a></b></td><td align="center" class="tab2">$CPS_Inode</td>"  >>$generatehtml1
                     echo "</tr>" >> $generatehtml1


                                                elif [[ $CPS_Inode -ge 95 ]] ; then
                                                echo "<tr><td  align="center" class="tab3">$vtier ( $Hostname )</td> <td align="center" class="tab2">$CPS_FS</td><td align="center" class="tab2"><b><a href="https://workspace.web.att.com/sites/ETM/RPS/Reference/Day%20-%20Day%20Miscellaneous/Inode_CPS.txt"> <FONT COLOR=#ff0000> $CPS_Inode </a></b></td>"  >>$generatehtml1
                     echo "</tr>" >> $generatehtml1

                                                else
                                                echo "<tr><td align="center" class="tab3">$vtier ( $Hostname )</td> <td align="center" class="tab2">$CPS_FS</td><td align="center" class="tab2">$CPS_Inode</td>"  >>$generatehtml1
                     echo "</tr>" >> $generatehtml1

                                                fi
                       done
    echo "</table>" >>$generatehtml1
    echo "</body>" >>$generatehtml1
    echo "</html>" >>$generatehtml1
    cat $generatehtml1 | $sendmail
    echo "script executed successfully !!!!"
    rm $generatehtml1
