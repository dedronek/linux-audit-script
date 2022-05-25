echo "Auditing journald..."

echo -n "journald is configured to send logs to rsyslog ... "

    q1=`bash -c "grep -e ForwardToSyslog /etc/systemd/journald.conf 2>&1 | grep -o yes"`

      if [[ "$q1" == "yes" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "journald compressing large log files ... "

    q2=`bash -c "grep -e Compress /etc/systemd/journald.conf 2>&1| grep -o yes"`

      if [[ "$q2" == "yes" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "journald writes logfiles to persistent disk ... "

    q2=`bash -c "grep -e Storage /etc/systemd/journald.conf 2>&1 | grep -o persistent"`

      if [[ "$q2" == "persistent" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi