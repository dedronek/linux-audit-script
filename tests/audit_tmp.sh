echo "Auditing /tmp..."

cmd_check "/tmp exists on separate partition  ... " "findmnt /tmp" "output"

if [ $? -eq 1 ]; then
  cmd_check "nodev option set for /tmp ... " "findmnt -n /tmp | grep -v nodev" "empty"
  cmd_check "nosuid option set for /tmp ... " "findmnt -n /tmp | grep -v nosuid" "empty"
  cmd_check "noexec option set for /tmp ... " "findmnt -n /tmp | grep -v noexec" "empty"
  fi

