echo "Auditing cron..."

echo -n "cron is installed and running ... "

    q1=`bash -c "systemctl is-enabled cron 2>&1"`
    q2=`systemctl status cron 2>&1 | grep -o 'active (running) '`

      if [ "$q1" == "enabled" ] && [ "$q2" != "" ]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "correct permissions for /etc/crontab ... "

    q3=`stat /etc/crontab 2>&1 | grep -o root | wc -l`
    q4=`stat /etc/crontab 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E 0[0-7]00`

    if [[ "$q3" == "2" && "$q4" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "correct permissions for /etc/cron.hourly ... "

    q5=`stat /etc/cron.hourly/ 2>&1 | grep -o root | wc -l`
    q6=`stat /etc/cron.hourly/ 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E 0[0-7]00`

    if [[ "$q5" == "2" && "$q6" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "correct permissions for /etc/cron.daily ... "

    q7=`stat /etc/cron.daily/ 2>&1 | grep -o root | wc -l`
    q8=`stat /etc/cron.daily/ 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E 0[0-7]00`

    if [[ "$q7" == "2" && "$q8" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "correct permissions for /etc/cron.weekly ... "

    q9=`stat /etc/cron.weekly/ 2>&1 | grep -o root | wc -l`
    q10=`stat /etc/cron.weekly/ 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E 0[0-7]00`

    if [[ "$q9" == "2" && "$q10" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "correct permissions for /etc/cron.monthly ... "

    q11=`stat /etc/cron.monthly/ 2>&1 | grep -o root | wc -l`
    q12=`stat /etc/cron.monthly/ 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E 0[0-7]00`

    if [[ "$q11" == "2" && "$q12" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "correct permissions for /etc/cron.d ... "

    q13=`stat /etc/cron.d/ 2>&1 | grep -o root | wc -l`
    q14=`stat /etc/cron.d/ 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E 0[0-7]00`

    if [[ "$q13" == "2" && "$q14" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "cron only for authorized users ... "

    q15="/etc/cron.deny"
    q16="/etc/cron.allow"
    q17=`stat /etc/cron.allow 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E 0[0-7]40`

    if [[ ! -f "$q15" && -f "$q16" && "$q17" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "at only for authorized users ... "

    q15="/etc/at.deny"
    q16="/etc/at.allow"
    q17=`stat /etc/at.allow 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E 0[0-7]40`


    if [[ ! -f "$q15" && -f "$q16" && "$q17" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi


