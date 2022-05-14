echo "Auditing firewall..."

echo -n "ufw is installed ... "

    q1=`bash -c "dpkg -s ufw 2>&1 >/dev/null | grep -o 'not installed'"`

    if [ "$q1" != "not installed" ]; then
          echo $success
          score=$( expr $score + 1 )
        else
          echo $failure
          failed=$( expr $failed + 1 )
        fi

echo -n "nftables is installed ... "
    q2=`bash -c "dpkg-query -s nftables 2>&1 >/dev/null | grep -o 'not installed'"`

    if [ "$q2" != "not installed" ]; then
          echo $success
          score=$( expr $score + 1 )
        else
          echo $failure
          failed=$( expr $failed + 1 )
        fi

echo -n "iptables is installed ... "

    q3=`bash -c "apt list iptables iptables-persistent 2>&1 >/dev/null | grep installed"`

        if [ "$q2" != "installed" ]; then
              echo $success
              score=$( expr $score + 1 )
            else
              echo $failure
              failed=$( expr $failed + 1 )
            fi