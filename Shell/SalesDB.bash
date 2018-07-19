 sendmail="/usr/sbin/sendmail -t"
   mail_from="From:DL-RPS@att.com"
#   mail_to="To:nk815q@att.com"
   mail_to="To:DL-RPS@att.com"
   mail_cc="Cc:pv6748@att.com"
   generatehtml1="/home/m70632/RPSScripts/IdolCheck_HF/idols.html"
    echo "MIME-Version: 1.0" >>$generatehtml1
    echo $mail_from >>$generatehtml1
    echo $mail_to >>$generatehtml1
    echo $mail_cc >>$generatehtml1

    mail_subject="Subject: MyCSP Idol status"
    echo $mail_subject `date '+ %m/%d/%y - %H:%M:%S PDT'` >>$generatehtml1
    echo "Content-Type: text/html " >>$generatehtml1
        echo "<html><head>" >>$generatehtml1
        echo "<style type="text/css">" >>$generatehtml1
        ATTUID=`who am i | awk '{print $1}'`
        userName=`cat /etc/passwd | grep $ATTUID | cut -d':' -f5`
echo "Hello ,$userName !!"
 echo ".tab1 { border:1px solid;width:200px ;color:#12c174;background-color:FFF5EE;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
        echo ".tab2 {  border:1px solid;width:200px ;color:Blue;background-color:FFF5EE;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
        echo ".tab3 { border:1px solid;width:200px ;color:Green;background-color:#FFDAB9;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
        echo ".tab4 {  border:1px solid;width:200px ;color:Red;background-color:FFF5EE;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
        echo ".tab5 {  border:1px solid;width:200px ;color:White;background-color:Red;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
        echo ".tab6 {  border:1px solid;width:200px ;color:Green;background-color:Black;font-size:12;font-family: Verdana, Arial, Helvetica ;}" >>$generatehtml1
        echo "</style></head><body>" >>$generatehtml1
        echo "<h3>Hello , $userName</h3>">>$generatehtml1

        echo "<table cellpadding="5" cellspacing="5" border="1" width="600px" align="left">" >>$generatehtml1
        echo "<th> Process Name  </th> <th> Status </th>" >>$generatehtml1
echo -e "---------------------------------------------------"
echo -e "|      Handlers & Fetchers        |  Status   |"
echo -e "---------------------------------------------------"
while read vtier
do
echo "<tr><td align="center" class="tab6">SERVER</td> <td align="center" class="tab6">$vtier</td>"  >>$generatehtml1
                            echo "</tr>" >> $generatehtml1

echo $vtier
for i  in `cat idolprocess.lst`
do

        process_check=`sshcmd -u mycspapp -s ${vtier}  "ps -ef|grep -i $i|grep -v grep|awk {'print $8'}"  `



  if [[ $i=="IdxFileCollector" ]];then
                        if [[ -z "$process_check" ]];then
                                                        echo "<tr><td align="left" class="tab5">$i</td> <td align="center" class="tab5">Not Running</td>"  >>$generatehtml1
                            echo "</tr>" >> $generatehtml1
                            echo -e "| $i |NOT RUNNING |"

                        else
                                                                echo "<tr><td align="left" class="tab2">$i</td> <td align="center" class="tab2">Running</td>"  >>$generatehtml1
                                                                echo "</tr>" >> $generatehtml1
                                echo -e "| $i | RUNNING |"
                        fi
                else
                        if [[ -z "$process_check" ]]; then
                                                echo "<tr><td align="left" class="tab2">$i</td> <td align="center" class="tab5">Not Running</td>"  >>$generatehtml1
                                                echo "</tr>" >> $generatehtml1
                        echo -e "| $i | NOT RUNNING |"
                else
                                                echo "<tr><td align="left" class="tab2">$i</td> <td align="center" class="tab2">Running</td>"  >>$generatehtml1
                                                                echo "</tr>" >> $generatehtml1
                        echo -e "| $i | RUNNING |"
                fi
fi





done | column -t

echo -e "----------------------------------------------------"


done < ./idolserver.lst




    echo "</table>" >>$generatehtml1
    echo "</body>" >>$generatehtml1
    echo "</html>" >>$generatehtml1
    cat $generatehtml1 | $sendmail
    echo "script executed successfully !!!!"
    rm $generatehtml1
