echo "Auditing CLI warning banners..."

cmd_check "message of the day banner configured properly ... " 'grep -Eis "(\\\v|\\\r|\\\m|\\\s|$(grep '\''^ID='\'' /etc/os-release | cut -d= -f2 | sed -e '\''s/"//g'\''))" /etc/motd 2>&1'
cmd_check "local login warning banner configured properly ... " 'grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '\''^ID='\'' /etc/os-release | cut -d= -f2 | sed -e '\''s/"//g'\''))" /etc/issue 2>&1'
cmd_check "remote login warning banner configured properly ... " 'grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '\''^ID='\'' /etc/os-release | cut -d= -f2 | sed -e '\''s/"//g'\''))" /etc/issue.net 2>&1'

echo -n "correct permissions for file /etc/motd ... "

    q1=`bash -c "stat -L /etc/motd 2>&1 | grep -o root | wc -l"`
    q2=`bash -c "stat -L /etc/motd 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E 0644"`

    if [[ "$q1" == "2" ]]  && [[ "$q2" != "" ]] || [[ ! -f "/etc/motd" ]] && [[ ! -d "/etc/motd" ]]; then
      echo $success
      score=$( expr $score + 1 )
    else
      echo $failure
      failed=$( expr $failed + 1 )
    fi

echo -n "correct permissions for file /etc/issue ... "

    q1=`bash -c "stat -L /etc/issue 2>&1 | grep -o root | wc -l"`
    q2=`bash -c "stat -L /etc/issue 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E 0644"`


    if [[ "$q1" == "2" ]]  && [[ "$q2" != "" ]]; then
      echo $success
      score=$( expr $score + 1 )
    else
      echo $failure
      failed=$( expr $failed + 1 )
    fi

echo -n "correct permissions for file /etc/issue.net ... "

    q1=`bash -c "stat -L /etc/issue.net 2>&1 | grep -o root | wc -l"`
    q2=`bash -c "stat -L /etc/issue.net 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E 0644"`


    if [[ "$q1" == "2" ]]  && [[ "$q2" != "" ]]; then
      echo $success
      score=$( expr $score + 1 )
    else
      echo $failure
      failed=$( expr $failed + 1 )
    fi