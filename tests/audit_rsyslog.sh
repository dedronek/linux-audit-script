echo "Auditing rsyslog..."

echo -n "rsyslog is installed ... "

    q1=`bash -c "dpkg -s rsyslog 2>&1 | grep -o 'Status: install ok installed'"`

      if [[ "$q1" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "rsyslog service is enabled ... "

    q2=`bash -c "systemctl is-enabled rsyslog"`

      if [[ "$q2" == "enabled" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "correct permissions for default rsyslog file ... "

    q3=`bash -c "grep ^\s*\$FileCreateMode /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>&1"`

      if [[ "$q3" == *"0640"* ]] || [[ "$q3" == *"0600"* ]] || [[ "$q3" == *"0440"* ]] || [[ "$q3" == *"0400"* ]] ; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi
