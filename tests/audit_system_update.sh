echo "Auditing system updates and patches ..."

cmd_check "no packages to upgrade ... " 'apt-get -s upgrade | grep "^0 upgraded"' "output"
cmd_check "no packages to remove ... " 'apt-get -s upgrade | grep -E "[[:space:]]0 to remove"' "output"
