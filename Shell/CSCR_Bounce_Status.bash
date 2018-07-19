		###############################################################################
        #                                                                             #
        # Name:          Bouncestatus.sh                                              #
        #                                                                             #
        # Description:  Script to Check the bounce time of CSCR servers               #
        #                                                                             #
        # Usage:        To check the Bounce status of CSCR Servers                    #
        #                                                                             #
        # Author:       Nadeem Khan(nk815q)                                           #
        #                                                                             #
        # Version:      1.0                                                           #
        #                                                                             #
        ###############################################################################
	
	sendmail="/usr/sbin/sendmail -t"
    mail_from="From: nk815q@att.com"
    mail_to="To:nk815q@att.com "
    generatehtml1="/home/m93151/RPSScripts/nk815q/CSCR_serv.html"
    echo "MIME-Version: 1.0" >>$generatehtml1
    echo $mail_from >>$generatehtml1
    echo $mail_to >>$generatehtml1
    mail_subject="Subject: CSCR Bounce Status"
    echo $mail_subject `date '+ %m/%d/%y - %H:%M:%S PDT'` >>$generatehtml1
    echo "Content-Type: text/html " >>$generatehtml1
        echo "<html><head>" >>$generatehtml1
        echo "<style type="text/css">" >>$generatehtml1

        echo ".tab1 { border:1px solid;width:200px ;color:#12c174;background-color:FFF5EE;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
        echo ".tab2 {  border:1px solid;width:200px ;color:Blue;background-color:FFF5EE;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
        echo ".tab3 { border:1px solid;width:200px ;color:Green;background-color:#FFDAB9;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
         echo ".tab4 { border:1px solid;width:200px ;color:Red;background-color:#FFDAB9;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1


        echo "</style></head><body>" >>$generatehtml1
        echo "<table cellpadding="5" cellspacing="5" border="1" width="600px" align="left">" >>$generatehtml1
        echo "<th> CSCR Server </th> <th> Bounce Time status</th> <th> Process ID</th> " >>$generatehtml1
          for vtier in `cat ServList.lst`
                do
                     CSCR=`sshcmd -u ${vtier} -s ${vtier} "ps -ef|grep java|grep $vtier|tail -1|tr -s ' '|cut -d' ' -f5 "|tr ' ' '\t'|tail -1 `
                        prc=`sshcmd -u ${vtier} -s ${vtier} "ps -ef|grep java|grep $vtier|tail -1|tr -s ' '|cut -d' ' -f2 "|tr ' ' '\t'|tail -1 `
                        Cur_Date=`sshcmd -u ${vtier} -s ${vtier} "date +%b%e|tail -1|tr -s ' '"|tr ' ' '\t'|tail -1 `
                        if [[ $CSCR -ne $Cur_Date ]] ; then
                                echo "<tr><td class="tab3">$vtier</td> <td class="tab2">$CSCR</td><td class="tab2">$prc</td>"  >>$generatehtml1
                                echo "</tr>" >> $generatehtml
                        else
                                echo "<tr><td class="tab4">$vtier</td> <td class="tab4">$CSCR (check for the server bounce)</td><td class="tab4">$prc</td>"  >>$generatehtml1
                                echo "</tr>" >> $generatehtml
                        fi

                 done
        echo "</table>" >>$generatehtml1
    echo "</body>" >>$generatehtml1
    echo "</html>" >>$generatehtml1
cat $generatehtml1 | $sendmail
echo "script executed successfully !!!!"

rm $generatehtml1