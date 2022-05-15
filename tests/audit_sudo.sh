echo "Auditing sudo..."

echo -n "sudo is installed  ... "

    q1=`dpkg -s sudo | grep -o "install ok"`
    q2=`dpkg -s sudo-ldap 2>&1 | grep -o "install ok" `

      if [ "$q1" == "install ok" ] || [ "$q2" == "install ok" ]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

#ROOT NEEDED
if [ $root -eq 1 ]; then
cmd_check "sudo commands use pty ... " 'grep -Ei '\''^\s*Defaults\s+([^#]+,\s*)?use_pty(,\s+\S+\s*)*(\s+#.*)?$'\'' /etc/sudoers /etc/sudoers.d/*' "output"
cmd_check "logging for sudo is configured ... " 'grep -Ei '\''^\s*Defaults\s+logfile=\S+'\'' /etc/sudoers /etc/sudoers.d/*' "output"
fi