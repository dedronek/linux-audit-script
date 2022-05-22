echo "Auditing system files permissions..."

echo -n "correct permissions for /etc/passwd ... "

    q1=`stat /etc/passwd 2>&1 | grep -o root | wc -l`
    q2=`stat /etc/passwd 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E 0644`

    if [[ "$q1" == "2" && "$q2" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "correct permissions for /etc/passwd- ... "

    q1=`stat /etc/passwd- 2>&1 | grep -o root | wc -l`
    q2=`stat /etc/passwd- 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E '0[0246][04][04]'`

    if [[ "$q1" == "2" && "$q2" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "correct permissions for /etc/group ... "

    q1=`stat /etc/group 2>&1 | grep -o root | wc -l`
    q2=`stat /etc/group 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E 0644`

    if [[ "$q1" == "2" && "$q2" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "correct permissions for /etc/group- ... "

    q1=`stat /etc/group- 2>&1 | grep -o root | wc -l`
    q2=`stat /etc/group- 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E '0[0246][04][04]'`

    if [[ "$q1" == "2" && "$q2" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "correct permissions for /etc/shadow ... "

    q1=`stat /etc/shadow 2>&1 | grep Access | grep  -o root | wc -l`
    q2=`stat /etc/shadow 2>&1 | grep Access | grep -o shadow | wc -l`
    q3=`stat /etc/shadow 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E '0[0246][04][0]'`

    if [[ "$q1" == "2" || "$q1" == "1" && "$q2" == "1" && "$q3" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "correct permissions for /etc/shadow- ... "

    q1=`stat /etc/shadow- 2>&1 | grep Access | grep  -o root | wc -l`
    q2=`stat /etc/shadow- 2>&1 | grep Access | grep -o shadow | wc -l`
    q3=`stat /etc/shadow- 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E '0[0246][04][0]'`

    if [[ "$q1" == "2" || "$q1" == "1" && "$q2" == "1" && "$q3" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "correct permissions for /etc/gshadow ... "

    q1=`stat /etc/gshadow 2>&1 | grep Access | grep  -o root | wc -l`
    q2=`stat /etc/gshadow 2>&1 | grep Access | grep -o shadow | wc -l`
    q3=`stat /etc/gshadow 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E '0[0246][04][0]'`

    if [[ "$q1" == "2" || "$q1" == "1" && "$q2" == "1" && "$q3" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "correct permissions for /etc/gshadow- ... "

    q1=`stat /etc/gshadow- 2>&1 | grep Access | grep  -o root | wc -l`
    q2=`stat /etc/gshadow- 2>&1 | grep Access | grep -o shadow | wc -l`
    q3=`stat /etc/gshadow- 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E '0[0246][04][0]'`

    if [[ "$q1" == "2" || "$q1" == "1" && "$q2" == "1" && "$q3" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

#ROOT NEEDED
if [[ $root -eq 1 ]]; then

  cmd_check "no word writable files exists ... " 'df --local -P | awk '\''{if (NR!=1) print $6}'\'' | xargs -I '{}' find '{}' -xdev -type f -perm -0002 2>&1'
  cmd_check "no unowned files/directories exists ... " 'df --local -P | awk {'\''if (NR!=1) print $6'\''} | xargs -I '{}' find '{}' -xdev -nouser 2>&1'
  cmd_check "no ungrouped files/directories exists ... " 'df --local -P | awk '\''{if (NR!=1) print $6}'\'' | xargs -I '{}' find '{}' -xdev -nogroup 2>&1'

  fi