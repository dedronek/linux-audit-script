echo "Auditing AIDE..."

echo -n "AIDE is installed ... "

    q1=`dpkg -s aide | grep -E '(Status:|not installed)'`
    q2=`dpkg -s aide-common | grep -E '(Status:|not installed)'`

    integrity_query='grep -Ers '\''^([^#]+\s+)?(\/usr\/s?bin\/|^\s*)aide(\.wrapper)?\s(-- check|\$AIDEARGS)\b'\'' /etc/cron.* /etc/crontab /var/spool/cron/'
    q3=`bash -c "${integrity_query}"`

      if [ "$q1" == "Status: install ok installed" ] && [ "$q2" == "Status: install ok installed" ]; then
        echo $success
        score=$( expr $score + 1 )

        echo -n "Filesystem integrity checked regularly ... "
        if [ "$q3" != "" ]; then
          echo $success
          score=$( expr $score + 1 )
          return 1
        else
          echo $failure
          failed=$( expr $failed + 1 )
          return 0
        fi
      else
        echo $failure
        failed=$( expr $failed + 1 )
        return 0
      fi

