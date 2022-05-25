echo "Auditing AppArmor..."

echo -n "AppArmor is installed ... "

    q1=`dpkg -s apparmor 2>&1 | grep -E '(Status:|not installed)'`

      if [ "$q1" == "Status: install ok installed" ]; then
        echo $success
        score=$( expr $score + 1 )

        cmd_check "AppArmor is enabled in bootloader configuration ... " 'grep -s "^\s*linux" /boot/grub/grub.cfg 2>&1 | grep -v "apparmor=1" && grep -s "^\s*linux" /boot/grub/grub.cfg | grep -v "security=apparmor"'

        #ROOT NEEDED
        if [ $root -eq 1 ]; then
        apparmor_loaded='apparmor_status | grep -E '\''^0 profiles are loaded'\'''
        apparmor_complain_mode='apparmor_status | grep profiles | grep -E '\''^0 profiles are in complain mode.'\'''
        apparmor_unconfined='apparmor_status | grep processes | grep -E '\''^0 processes are unconfined'\'''

        q2=`bash -c "${apparmor_loaded}"` #empty
        q3=`bash -c "${apparmor_complain_mode}"` #output
        q4=`bash -c "${apparmor_unconfined}"` #output

        echo -n "AppArmor profiles are enforcing ... "
        if [[ "$q2" == "" ]] && [[ "$q3" != "" ]] && [[ "$q4" != "" ]]; then
          echo $success
          score=$( expr $score + 1 )
        else
          echo $failure
          failed=$( expr $failed + 1 )
        fi
        fi
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

