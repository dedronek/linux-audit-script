echo "Auditing AppArmor..."

echo -n "AppArmor is installed ... "

    q1=`dpkg -s apparmor | grep -E '(Status:|not installed)'`

      if [ "$q1" == "Status: install ok installed" ]; then
        echo $success
        score=$( expr $score + 1 )

        cmd_check "AppArmor is enabled in bootloader configuration ... " 'grep "^\s*linux" /boot/grub/grub.cfg | grep -v "apparmor=1" && grep "^\s*linux" /boot/grub/grub.cfg | grep -v "security=apparmor"'
      #todo: add 1.6.1.3(4?)
      else
        echo $failure
        failed=$( expr $failed + 1 )
        return 0
      fi

