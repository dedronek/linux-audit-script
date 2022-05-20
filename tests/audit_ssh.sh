echo "Auditing ssh..."

echo -n "correct permissions for /etc/ssh/sshd_config ... "

    q1=`stat /etc/ssh/sshd_config 2>&1 | grep -o root | wc -l`
    q2=`stat /etc/ssh/sshd_config 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E 0[0-7]00`

    if [[ "$q1" == "2" && "$q2" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "correct permissions for private host key files ... "

    count=`find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec stat {} \; 2>&1 | grep -o File | wc -l`

    q1=`find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec stat {} \; 2>&1 | grep -o root | wc -l`
    q2=`find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec stat {} \;  2>&1 | grep -oP 'Access: \(\K[^\)]+' | grep -E 0[0-7]00 | wc -l`

    root_count=`expr $count \* 2`

    if [[ "$q1" == "$root_count" && "$q2" == "$count" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "correct permissions for public host key files ... "

    count=`find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec stat {} \; 2>&1 | grep -o File | wc -l`

    q1=`find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec stat {} \; 2>&1 | grep -o root | wc -l`
    q2=`find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec stat {} \; 2>&1  | grep -oP 'Access: \(\K[^\)]+' | grep -E 0[0-7][4-6]4 | wc -l`

    root_count=`expr $count \* 2`

    if [[ "$q1" == "$root_count" && "$q2" == "$count" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

#ROOT NEEDED

if [[ "$root" -eq 1 ]]; then
  cmd_check "SSH access is limited ... " 'sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '\''{print $1}'\'')" | grep -Ei '\''^\s*(allow|deny)(users|groups)\s+\S+'\''' "output"
  cmd_check "SSH usage is logging ... " 'grep -is '\''loglevel'\'' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf | grep -Evi '\''(VERBOSE|INFO)'\'''

  q1=`sshd -T -C user=root -C host=\"$(hostname)\" -C addr=\"$(grep $(hostname) /etc/hosts | awk '{print $1}')\" | grep -E 'maxauthtries [0-4]'`
  q2=`grep -Eis '^\s*maxauthtries\s+([5-9]|[1-9][0-9]+)' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf`

  echo -n "MaxAuthTries set to 4 or less ... "
  if [[ "$q1" != "" && "$q2" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

  q1=`sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep 'hostbasedauthentication no'`
  q2=`grep -Eis '^\s*HostbasedAuthentication\s+yes' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf`

  echo -n "HostbasedAuthentication is disabled ... "

  if [[ "$q1" != "" && "$q2" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

  q1=`sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep 'permitrootlogin no'`
  q2=`grep -Eis '^\s*PermitRootLogin\s+yes' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf`

  echo -n "PermitRootLogin is disabled ... "

  if [[ "$q1" != "" && "$q2" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

  q1=`sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep 'permitemptypasswords no'`
  q2=`grep -Eis '^\s*PermitEmptyPasswords\s+yes' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf`

  echo -n "PermitEmptyPasswords is disabled ... "

  if [[ "$q1" != "" && "$q2" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

  q1=`sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep 'permituserenvironment no'`
  q2=`grep -Eis '^\s*PermitUserEnvironment\s+yes' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf`

  echo -n "PermitUserEnvironment is disabled ... "

  if [[ "$q1" != "" && "$q2" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

  q1=`sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -Ei '^\s*ciphers\s+([^#]+,)?(3des- cbc|aes128-cbc|aes192-cbc|aes256-cbc|arcfour|arcfour128|arcfour256|blowfish- cbc|cast128-cbc|rijndael-cbc@lysator.liu.se)\b'`
  q2=`grep -Eis '^\s*ciphers\s+([^#]+,)?(3des-cbc|aes128-cbc|aes192-cbc|aes256-cbc|arcfour|arcfour128|arcfour256|blowfish-cbc|cast128-cbc|rijndael- cbc@lysator.liu.se)\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf`

  echo -n "only strong ciphers are used in communication ... "

  if [[ "$q1" == "" && "$q2" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

  q1=`sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -Ei '^\s*macs\s+([^#]+,)?(hmac- md5|hmac-md5-96|hmac-ripemd160|hmac-sha1|hmac-sha1-96|umac- 64@openssh\.com|hmac-md5-etm@openssh\.com|hmac-md5-96-etm@openssh\.com|hmac- ripemd160-etm@openssh\.com|hmac-sha1-etm@openssh\.com|hmac-sha1-96- etm@openssh\.com|umac-64-etm@openssh\.com|umac-128-etm@openssh\.com)\b'`
  q2=`grep -Eis '^\s*macs\s+([^#]+,)?(hmac-md5|hmac-md5-96|hmac-ripemd160|hmac- sha1|hmac-sha1-96|umac-64@openssh\.com|hmac-md5-etm@openssh\.com|hmac-md5-96- etm@openssh\.com|hmac-ripemd160-etm@openssh\.com|hmac-sha1- etm@openssh\.com|hmac-sha1-96-etm@openssh\.com|umac-64-etm@openssh\.com|umac- 128-etm@openssh\.com)\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf`

  echo -n "only strong MAC algorithms are used ... "

  if [[ "$q1" == "" && "$q2" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

    q1=`sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep clientaliveinterval | cut -d ' ' -f 2`
    q2=`sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep clientalivecountmax | cut -d ' ' -f 2`
    q3=`grep -Eis '^\s*clientaliveinterval\s+(0|3[0-9][1-9]|[4-9][0-9][0-9]|[1-9][0-9][0-9][0-9]+|[6-9]m|[1-9][0-9]+m)\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf`
    q4=`grep -Eis '^\s*ClientAliveCountMax\s+(0|[4-9]|[1-9][0-9]+)\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf`

    echo -n "idle timeout interval is configured ... "

    if [[ $q1 -le 300 && $q1 -ge 1 && $q2 -le 3 && $q2 -ge 1 && "$q3" == "" && "$q4" == "" ]]; then
          echo $success
          score=$( expr $score + 1 )
        else
          echo $failure
          failed=$( expr $failed + 1 )
        fi

    q1=`sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep logingracetime | cut -d ' ' -f 2`
    q2=`grep -Eis '^\s*LoginGraceTime\s+(0|6[1-9]|[7-9][0-9]|[1-9][0-9][0-9]+|[^1]m)' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf`

    echo -n "LoginGraceTime is one minute or less ... "

    if [[ $q1 -le 60 && $q1 -ge 1 && "$q2" == "" ]]; then
          echo $success
          score=$( expr $score + 1 )
        else
          echo $failure
          failed=$( expr $failed + 1 )
        fi

    q1=`sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -o 'banner none'`
    q2=`grep -Eis '^\s*Banner\s+"?none\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf`

    echo -n "SSH warning banner is configured ... "

    if [[ "$q1" != "banner none" && "$q2" == "" ]]; then
          echo $success
          score=$( expr $score + 1 )
        else
          echo $failure
          failed=$( expr $failed + 1 )
        fi

    q1=`sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i usepam | cut -d ' ' -f 2`
    q2=`grep -Eis '^\s*UsePAM\s+no' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf`

    echo -n "SSH PAM is enabled ... "

    if [[ "$q1" == "yes" && "$q2" == "" ]]; then
          echo $success
          score=$( expr $score + 1 )
        else
          echo $failure
          failed=$( expr $failed + 1 )
        fi

    q1=`sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i maxstartups | cut -d ' ' -f 2 | awk -F ':' '$1 <= 10 && $2 <= 30 && $3 <= 60 {print "ok"}'`
    q2=`grep -Eis '^\s*maxstartups\s+(((1[1-9]|[1-9][0-9][0-9]+):([0-9]+):([0-9]+))|(([0-9]+):(3[1-9]|[4-9][0-9]|[1-9][0-9][0-9]+):([0-9]+))|(([0-9]+):([0-9]+):(6[1-9]|[7-9][0-9]|[1-9][0-9][0-9]+)))' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf`

    echo -n "MaxStartups is configured ... "

    if [[ "$q1" == "ok" && "$q2" == "" ]]; then
          echo $success
          score=$( expr $score + 1 )
        else
          echo $failure
          failed=$( expr $failed + 1 )
        fi

    q1=`sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i maxsessions | cut -d ' ' -f 2 `
    q2=`grep -Eis '^\s*MaxSessions\s+(1[1-9]|[2-9][0-9]|[1-9][0-9][0-9]+)' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf`
    echo -n "MaxSessions is limited ... "

    if [[ $q1 -le 10 && $q1 -ge 1 && "$q2" == "" ]]; then
          echo $success
          score=$( expr $score + 1 )
        else
          echo $failure
          failed=$( expr $failed + 1 )
        fi

  fi
