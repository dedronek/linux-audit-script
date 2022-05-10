echo "Auditing CLI warning banners..."

cmd_check "message of the day banner configured properly ... " 'grep -Eis "(\\\v|\\\r|\\\m|\\\s|$(grep '\''^ID='\'' /etc/os-release | cut -d= -f2 | sed -e '\''s/"//g'\''))" /etc/motd'
cmd_check "local login warning banner configured properly ... " 'grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '\''^ID='\'' /etc/os-release | cut -d= -f2 | sed -e '\''s/"//g'\''))" /etc/issue'
cmd_check "remote login warning banner configured properly ... " 'grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '\''^ID='\'' /etc/os-release | cut -d= -f2 | sed -e '\''s/"//g'\''))" /etc/issue.net'

echo -n "correct permissions for file /etc/motd ... "

    q=`bash -c "stat -L /etc/motd"`

    if [[ "$q" == *"Access: (0644/-rw-r--r--)"* ]]  && [[ "$q" == *"Uid: (    0/    root)"* ]] && [[ "$q" == *"Gid: (    0/    root)"* ]] ; then
      echo $success
      score=$( expr $score + 1 )
    else
      echo $failure
      failed=$( expr $failed + 1 )
    fi

echo -n "correct permissions for file /etc/issue ... "

    q=`bash -c "stat -L /etc/issue"`

    if [[ "$q" == *"Access: (0644/-rw-r--r--)"* ]]  && [[ "$q" == *"Uid: (    0/    root)"* ]] && [[ "$q" == *"Gid: (    0/    root)"* ]] ; then
      echo $success
      score=$( expr $score + 1 )
    else
      echo $failure
      failed=$( expr $failed + 1 )
    fi

echo -n "correct permissions for file /etc/issue.net ... "

    q=`bash -c "stat -L /etc/issue.net"`

    if [[ "$q" == *"Access: (0644/-rw-r--r--)"* ]]  && [[ "$q" == *"Uid: (    0/    root)"* ]] && [[ "$q" == *"Gid: (    0/    root)"* ]] ; then
      echo $success
      score=$( expr $score + 1 )
    else
      echo $failure
      failed=$( expr $failed + 1 )
    fi