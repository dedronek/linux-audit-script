#ROOT NEEDED
if [ $root -eq 1 ]; then

echo "Auditing network packages..."

q1=`sysctl net.ipv4.conf.default.accept_source_route | grep -E '0'`
q2=`sysctl net.ipv4.conf.all.accept_source_route | grep -E '0'`
q3=`grep "net\.ipv4\.conf\.all\.accept_source_route" /etc/sysctl.conf /etc/sysctl.d/* | grep -E '0'`
q4=`grep "net\.ipv4\.conf\.default\.accept_source_route" /etc/sysctl.conf /etc/sysctl.d/* | grep -E '0'`

echo -n "source routed packets not accepted ... "

  if [[ "$q1" != "" && "$q2" != "" && "$q3" != "" && "$q4" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

q5=`sysctl net.ipv4.conf.all.accept_redirects | grep -E '0'`
q6=`sysctl net.ipv4.conf.default.accept_redirects | grep -E '0'`
q7=`grep "net\.ipv4\.conf\.all\.accept_redirects" /etc/sysctl.conf /etc/sysctl.d/* | grep -E '0'`
q8=`grep "net\.ipv4\.conf\.default\.accept_redirects" /etc/sysctl.conf /etc/sysctl.d/* | grep -E '0'`

echo -n "ICMP packets redirect not accepted ... "

  if [[ "$q5" != "" && "$q6" != "" && "$q7" != "" && "$q8" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

q9=`sysctl net.ipv4.conf.all.secure_redirects | grep -E '0'`
q10=`sysctl net.ipv4.conf.default.secure_redirects | grep -E '0'`
q11=`grep "net\.ipv4\.conf\.all\.secure_redirects" /etc/sysctl.conf /etc/sysctl.d/* | grep -E '0'`
q12=`grep "net\.ipv4\.conf\.default\.secure_redirects" /etc/sysctl.conf /etc/sysctl.d/* | grep -E '0'`

echo -n "secure ICMP packets redirect not accepted ... "

  if [[ "$q9" != "" && "$q10" != "" && "$q11" != "" && "$q12" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

q13=`sysctl net.ipv4.conf.all.log_martians | grep -E '1'`
q14=`sysctl net.ipv4.conf.default.log_martians | grep -E '1'`
q15=`grep "net\.ipv4\.conf\.all\.log_martians" /etc/sysctl.conf /etc/sysctl.d/* | grep -E '1'`
q16=`grep "net\.ipv4\.conf\.default\.log_martians" /etc/sysctl.conf /etc/sysctl.d/* | grep -E '1'`

echo -n "suspicious packets are logged ... "

  if [[ "$q13" != "" && "$q14" != "" && "$q15" != "" && "$q16" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

q17=`sysctl net.ipv4.icmp_echo_ignore_broadcasts | grep -E '1'`
q18=`grep "net\.ipv4\.icmp_echo_ignore_broadcasts" /etc/sysctl.conf /etc/sysctl.d/* | grep -E '1'`

echo -n "broadcast ICMP packets are ignored ... "

  if [[ "$q17" != "" && "$q18" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

q19=`sysctl net.ipv4.icmp_ignore_bogus_error_responses | grep -E '1'`
q20=`grep "net.ipv4.icmp_ignore_bogus_error_responses" /etc/sysctl.conf /etc/sysctl.d/* | grep -E '1'`

echo -n "suspicious ICMP packets are ignored ... "

  if [[ "$q19" != "" && "$q20" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

q21=`sysctl net.ipv4.conf.all.rp_filter | grep -E '1'`
q22=`sysctl net.ipv4.conf.default.rp_filter | grep -E '1'`
q23=`grep "net\.ipv4\.conf\.all\.rp_filter" /etc/sysctl.conf /etc/sysctl.d/* | grep -E '1'`
q24=`grep "net\.ipv4\.conf\.default\.rp_filter" /etc/sysctl.conf /etc/sysctl.d/* | grep -E '1'`

echo -n "reverse path filter enabled ... "

  if [[ "$q21" != "" && "$q22" != "" && "$q23" != "" && "$q24" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

q25=`sysctl net.ipv4.tcp_syncookies | grep -E '1'`
q26=`grep "net\.ipv4\.tcp_syncookies" /etc/sysctl.conf /etc/sysctl.d/* | grep -E '1'`

echo -n "TCP SYN cookies enabled ... "

  if [[ "$q25" != "" && "$q26" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

fi
