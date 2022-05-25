echo "Auditing PAM..."

echo -n "password length >=14, password complexity (minclass = 4) ... "

    q1=`grep '^\s*minlen\s*' /etc/security/pwquality.conf 2>&1 | grep -Eo '[0-9]{1,4}'`
    q2=`bash -c "grep '^\s*minclass\s*' /etc/security/pwquality.conf 2>&1"`
    q3=`grep -E '^\s*[duol]credit\s*' /etc/security/pwquality.conf 2>&1 | grep -o "\-1" | wc -l`

    if [[ $q1 -ge 14 ]] && [[ $q2 -ge 4  ]] || [[ "$q3" == "4" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "failed password attempts lockout is configured ... "

    q1=`grep "pam_tally2" /etc/pam.d/common-auth`
    q2=`grep -E "pam_(tally2|deny)\.so" /etc/pam.d/common-account | wc -l`

    if [[ $q1 != "" && $q2 == "2" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

cmd_check "reusing password is limited (5 or more old password remembered) ... " 'grep -E '\''^\s*password\s+required\s+pam_pwhistory\.so\s+([^#]+\s+)?remember=([5-9]|[1-9][0-9]+)\b'\'' /etc/pam.d/common-password' "output"

cmd_check "password hashing algorithm sha512 ... " 'grep -E '\''^\s*password\s+(\[success=1\s+default=ignore\]|required)\s+pam_unix\.so\s+([ ^#]+\s+)?sha512\b'\'' /etc/pam.d/common-password' "output"
