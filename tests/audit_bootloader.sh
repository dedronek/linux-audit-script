echo "Auditing bootloader..."

 cmd_check "bootloader password for superuser is set ... " 'grep "^set superusers" /boot/grub/grub.cfg && grep "^password" /boot/grub/grub.cfg' "output"

echo -n "bootloader config overridden by update-grub to 400 ... "

    permission_by_update_grub='grep -E '\''^\s*chmod\s+[0-7][0-7][0-7]\s+\$\{grub_cfg\}\.new'\'' -A 1 -B1 /usr/sbin/grub-mkconfig'
    bootloader_permission="stat /boot/grub/grub.cfg"

    q1=`bash -c "${permission_by_update_grub}"`

    q2=`bash -c "${bootloader_permission}"`

    correct_permission_update_grub='400'
    correct_permission_grub='0400'

      if [[ "$q1" == *"$correct_permission_update_grub"* ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "bootloader config permission is 400 ... "

      if [[ "$q2" == *"$correct_permission_grub"* ]]; then
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