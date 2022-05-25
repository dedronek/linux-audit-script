echo "Auditing bootloader..."

 cmd_check "bootloader password for superuser is set ... " 'grep "^set superusers" /boot/grub/grub.cfg 2>&1 && grep "^password" /boot/grub/grub.cfg 2>&1' "output"

echo -n "bootloader config permission are correct ... "

      q1=`stat /boot/grub/grub.cfg 2>&1 | grep -o root | wc -l`
      q2=`stat /boot/grub/grub.cfg 2>&1 | grep -oP '\(\K[^\)]+' | head -1 | grep -E 0[0-4]00`

      if [[ "$q1" == "2" ]] && [[ "$q2" != "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi



echo -n "bootloader config overridden by update-grub to 400 ... "

    permission_by_update_grub='grep -E '\''^\s*chmod\s+[0-7][0-7][0-7]\s+\$\{grub_cfg\}\.new'\'' -A 1 -B1 /usr/sxbin/grub-mkconfig 2>&1'

    q1=`bash -c "${permission_by_update_grub}"`

      if [[ "$q1" == *"400"* ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

#ROOT NEEDED
if [ $root -eq 1 ]; then
 cmd_check "authentication required for single user mode ... " 'grep -Eq '\''^root:\$[0-9]'\'' /etc/shadow || echo "root is locked"'
 fi