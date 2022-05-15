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
