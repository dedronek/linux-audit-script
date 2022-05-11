echo "Auditing NIS services..."

echo -n "NIS server and client not installed ... "

    q=`bash -c "dpkg -s nis 2>&1 >/dev/null | grep -o 'not installed'"`

      if [[ "$q" == "not installed" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
        return 0
      fi

echo -n "rsh client not installed ... "

    q=`bash -c "dpkg -s rsh-client 2>&1 >/dev/null | grep -o 'not installed'"`

      if [[ "$q" == "not installed" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
        return 0
      fi

echo -n "talk client not installed ... "

    q=`bash -c "dpkg -s talk 2>&1 >/dev/null | grep -o 'not installed'"`

      if [[ "$q" == "not installed" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
        return 0
      fi

echo -n "telnet client not installed ... "

    q=`bash -c "dpkg -s telnet 2>&1 >/dev/null | grep -o 'not installed'"`

      if [[ "$q" == "not installed" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
        return 0
      fi
