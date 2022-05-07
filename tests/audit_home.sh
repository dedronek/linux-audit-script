echo "Auditing /home..."

cmd_check "/home exists on separate partition ... " "findmnt /home" "output"

if [ $? -eq 1 ]; then
  cmd_check "nodev option set for /home ... " "findmnt -n /home | grep -v nodev" "empty"
  fi

