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
  fi