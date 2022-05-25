echo "Auditing /var..."

cmd_check "/var exists on separate partition ... " "findmnt /var" "output"
cmd_check "/var/tmp exists on separate partition ... " "findmnt /var/tmp" "output"

if [ $? -eq 1 ]; then
  cmd_check "nodev option set for /var/tmp ... " "findmnt -n /var/tmp | grep -v nodev 2>&1"
  cmd_check "nosuid option set for /var/tmp ... " "findmnt -n /var/tmp | grep -v nosuid 2>&1"
  cmd_check "noexec option set for /var/tmp ... " "findmnt -n /var/tmp | grep -v noexec 2>&1"
  fi

cmd_check "/var/log exists on separate partition ... " "findmnt /var/log" "output"
cmd_check "/var/log/audit exists on separate partition ... " "findmnt /var/log/audit" "output"
