echo "Auditing sudo..."

echo -n "sudo is installed  ... "


    sudo=""
    q1=`dpkg -s sudo 2>&1 | grep -o "install ok"`
    q2=`dpkg -s sudo-ldap 2>&1 | grep -o "install ok" `

      if [ "$q1" == "install ok" ] || [ "$q2" == "install ok" ]; then
        echo $success
        sudo=1
        score=$( expr $score + 1 )
      else
        echo $failure
        sudo=0
        failed=$( expr $failed + 1 )
      fi


#ROOT NEEDED
if [ $root -eq 1 ] && [[ "$sudo" == 1 ]]; then
cmd_check "sudo commands use pty ... " 'grep -Ei '\''^\s*Defaults\s+([^#]+,\s*)?use_pty(,\s+\S+\s*)*(\s+#.*)?$'\'' /etc/sudoers /etc/sudoers.d/* 2>&1' "output"
cmd_check "logging for sudo is configured ... " 'grep -Ei '\''^\s*Defaults\s+logfile=\S+'\'' /etc/sudoers /etc/sudoers.d/* 2>&1' "output"
fi