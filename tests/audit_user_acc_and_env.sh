echo "Auditing user accounts and envs..."

echo -n "minimum days between password changes not less than 1 ... "

    q1=`grep '^PASS_MIN_DAYS\s' /etc/login.defs 2>&1 | grep -Eo '[0-9]{1,4}'`

    if [[ $q1 -ge 1 ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "password expire in 365 days or less ... "

    q1=`grep '^PASS_MAX_DAYS\s' /etc/login.defs 2>&1 | grep -Eo '[0-9]{1,6}'`

    if [[ $q1 -le 365 ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "password expiration warning set on 7 days or more ... "

    q1=`grep '^PASS_WARN_AGE\s' /etc/login.defs 2>&1 | grep -Eo '[0-9]{1,6}'`

    if [[ $q1 -ge 7 ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "inactivate users lock set for 30 days or less ... "

    q1=`useradd -D 2>&1 | grep INACTIVE | grep -oP -- '-\d+'`
    q2=`useradd -D 2>&1 | grep INACTIVE | grep -Eo '[0-9]{1,6}'`

    if [[ "$q1" != "-1" && "$q2" -le 30 ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "root GID is 0 ... "

    q1=`grep "^root:" /etc/passwd 2>&1 | cut -f4 -d:`
    if [[ "$q1" == "0" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "default user umask is 027 or more restrictive ... "

    q1=`grep -Eiq '^\s*UMASK\s+(0[0-7][2-7]7|[0-7][2-7]7)\b' /etc/login.defs 2>&1`
    q2=`grep -Eqi '^\s*USERGROUPS_ENAB\s*"?no"?\b' /etc/login.defs 2>&1`
    q3=`grep -Eq '^\s*session\s+(optional|requisite|required)\s+pam_umask\.so\b' /etc/pam.d/common-session 2>&1`
    q4=`grep -REiq '^\s*UMASK\s+\s*(0[0-7][2-7]7|[0-7][2-7]7|u=(r?|w?|x?)(r?|w?|x?)(r?|w?|x?),g=(r?x?|x?r?),o=)\b' /etc/profile* /etc/bash.bashrc* 2>&1`
    q5=`grep -RPi '(^|^[^#]*)\s*umask\s+([0-7][0-7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b|[0-7][01][0-7]\b|[0-7][0-7][0-6]\b|(u=[rwx]{0,3},)?(g=[rwx]{0,3},)?o=[rwx]+\b|(u=[rwx]{1,3},)?g=[^rx]{1,3}( ,o=[rwx]{0,3})?\b)' /etc/login.defs /etc/profile* /etc/bash.bashrc* 2>&1`

    if [[ "$q1" != "" && "$q2" != "" && "$q3" != "" && "$q4" != "" && "$q5" == ""  ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "access for su command is restricted ... "

    q1=`grep pam_wheel.so /etc/pam.d/su 2>&1 | grep use_gid`

    if [[ "$q1" != "" ]]; then

      sudo_group=`grep pam_wheel.so /etc/pam.d/su 2>&1 | grep group | cut -d '=' -f 2`

      q2=`grep $sudo_group /etc/group 2>&1 | cut -d ":" -f 4`

      if [[ "$q2" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
        fi
    else
        echo $failure
        failed=$( expr $failed + 1 )
    fi


#ROOT NEEDED

if [[ $root -eq 1 ]]; then

  cmd_check "last password change date for all users was in past ... " 'awk -F : '\''/^[^:]+:[^!*]/{print $1}'\'' /etc/shadow 2>&1 | while read -r usr; do [ "$(date --date="$(chage --list "$usr" | grep '\''^Last password change'\'' | cut -d: -f2)" +%s)" -gt "$(date "+%s")" ] && echo "user: $usr password change date: $(chage --list "$usr" | grep '\''^Last password change'\'' | cut -d: -f2)"; done'

echo -n "system accounts are secured ... "

    q1=`awk -F: '$1!~/(root|sync|shutdown|halt|^\+)/ && $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"' && $7!~/((\/usr)?\/sbin\/nologin)/ && $7!~/(\/bin)?\/false/ {print}' /etc/passwd`
    q2=`awk -F: '($1!~/(root|^\+)/ && $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"') {print $1}' /etc/passwd | xargs -I '{}' passwd -S '{}' | awk '($2!~/LK?/) {print $1}'`

    if [[ "$q1" == "" && "$q2" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "default user shell timeout is 900 seconds or less ... "

    output1="" output2=""
    [ -f /etc/bash.bashrc ] && BRC="/etc/bash.bashrc"
    for f in "$BRC" /etc/profile /etc/profile.d/*.sh ; do grep -Pq '^\s*([^#]+\s+)?TMOUT=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9])\b' 2>&1 "$f" && grep -Pq '^\s*([^#]+;\s*)?readonly\s+TMOUT(\s+|\s*;|\s*$|=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9]))\b' "$f" && grep -Pq '^\s*([^#]+;\s*)?export\s+TMOUT(\s+|\s*;|\s*$|=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9]))\b' "$f" && output1="$f"; done

    grep -Pq '^\s*([^#]+\s+)?TMOUT=(9[0-9][1-9]|9[1-9][0-9]|0+|[1-9]\d{3,})\b' /etc/profile /etc/profile.d/*.sh "$BRC" \
    && output2=$(grep -Ps '^\s*([^#]+\s+)?TMOUT=(9[0-9][1-9]|9[1-9][0-9]|0+|[1-9]\d{3,})\b' /etc/profile /etc/profile.d/*.sh $BRC)

    if [ -n "$output1" ] && [ -z "$output2" ]; then
                echo $success
                score=$( expr $score + 1 )
    else
        [ -z "$output1" ] &&  echo $failure; failed=$( expr $failed + 1 )
        [ -n "$output2" ] &&  echo $failure; failed=$( expr $failed + 1 )
    fi

  fi



