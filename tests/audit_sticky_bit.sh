echo "Auditing sticky bit..."

cmd_check "sticky bit is set on all world-writable directories ... " 'df --local -P | awk '\''{if (NR!=1) print $6}'\'' | xargs -I '\''{}'\'' find '\''{}'\'' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null'