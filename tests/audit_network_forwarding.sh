#ROOT NEEDED
if [ $root -eq 1 ]; then

echo "Auditing network forwarding..."

q1=`sysctl net.ipv4.conf.all.send_redirects | grep -E '0'`
q2=`sysctl net.ipv4.conf.default.send_redirects | grep -E '0'`
q3=`grep -E "^\s*net\.ipv4\.conf\.all\.send_redirects" /etc/sysctl.conf /etc/sysctl.d/* | grep -E '0'`
q4=`grep -E "^\s*net\.ipv4\.conf\.default\.send_redirects" /etc/sysctl.conf /etc/sysctl.d/* | grep -E '0'`

echo -n "packet redirect sending is disabled ... "

  if [[ "$q1" != "" && "$q2" != "" && "$q3" != "" && "$q4" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

q5=`sysctl net.ipv4.ip_forward | grep -E '0'`
q6=`grep -E -s "^\s*net\.ipv4\.ip_forward\s*=\s*1" /etc/sysctl.conf /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf | grep -E '0'`

echo -n "ip forwarding is disabled ... "

  if [[ "$q5" != "" && "$q6" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

 fi
