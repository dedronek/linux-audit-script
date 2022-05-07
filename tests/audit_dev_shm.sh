echo "Auditing /dev/shm..."

cmd_check "/dev/shm is configured ... "  "findmnt -n /dev/shm" "output"

if [ $? -eq 1 ]; then
  cmd_check "nodev option set for /dev/shm ... " "findmnt -n /dev/shm | grep -v nodev"
  cmd_check "nosuid option set for /dev/shm ... " "findmnt -n /dev/shm | grep -v nosuid"
  cmd_check "noexec option set for /dev/shm ... " "findmnt -n /dev/shm | grep -v noexec"
  fi
