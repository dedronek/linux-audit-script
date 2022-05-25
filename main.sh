#!/bin/bash

GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'

success="${GREEN}Passed${NC}"
failure="${RED}Not passed${NC}"

#consider adding function like:
# message, query, expected result -> cmd_check_result -> true/false
# message, query, string to find in output -> cmd_check_contains -> true/false

root=1

check_if_root_and_sudo()
{
  if [ "$EUID" -ne 0 ]
    then root=0
  fi

  q1=`dpkg -s sudo 2>&1 | grep -o "install ok"`
  q2=`dpkg -s sudo-ldap 2>&1 | grep -o "install ok" `

  if [ "$q1" == "install ok" ] || [ "$q2" == "install ok" ]; then
    is_sudo=1
  else
    is_sudo=0
  fi
}

check_if_root_and_sudo

function cmd_check()
{
    echo -n "$1"

    q=`bash -c "${2}"`



    if [ "$3" == "output" ]; then
      if [ "$q" != "" ]; then
        echo $success
        score=$( expr $score + 1 )
        return 1
      else
        echo $failure
        failed=$( expr $failed + 1 )
        return 0
      fi
    else
      if [ "$q" == "" ]; then
        echo $success
        score=$( expr $score + 1 )
        return 1
      else
        echo $failure
        failed=$( expr $failed + 1 )
        return 0
      fi
    fi
}

export -f cmd_check
export -f check_if_root_and_sudo

score=0
failed=0

total_score=0
total_failed=0

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi


. "$DIR/functions/1_filesystem.sh"
score_filesystem=$score
failed_filesystem=$failed
total_filesystem=$( expr $score_filesystem + $failed_filesystem )
total_score=$( expr $total_score + $score )
total_failed=$( expr $total_failed + $failed )
score=0
failed=0

. "$DIR/functions/2_services.sh"
score_services=$score
failed_services=$failed
total_services=$( expr $score_services + $failed_services )
total_score=$( expr $total_score + $score )
total_failed=$( expr $total_failed + $failed )
score=0
failed=0

. "$DIR/functions/3_network.sh"
score_network=$score
failed_network=$failed
total_network=$( expr $score_network + $failed_network )
total_score=$( expr $total_score + $score )
total_failed=$( expr $total_failed + $failed )
score=0
failed=0

. "$DIR/functions/4_logging.sh"
score_logging=$score
failed_logging=$failed
total_logging=$( expr $score_logging + $failed_logging )
total_score=$( expr $total_score + $score )
total_failed=$( expr $total_failed + $failed )
score=0
failed=0

. "$DIR/functions/5_access_authentication_authorization.sh"
score_access=$score
failed_access=$failed
total_access=$( expr $score_access + $failed_access )
total_score=$( expr $total_score + $score )
total_failed=$( expr $total_failed + $failed )
score=0
failed=0

. "$DIR/functions/6_system_maintenance.sh"
score_system=$score
failed_system=$failed
total_system=$( expr $score_system + $failed_system )
total_score=$( expr $total_score + $score )
total_failed=$( expr $total_failed + $failed )
score=0
failed=0

echo "========================="
echo -e " \tRESULTS"
echo "========================="

echo -e "Filesystem checks: \t$score_filesystem passed, \t$failed_filesystem failed, \t$total_filesystem in total"
echo -e "Services checks: \t$score_services passed, \t$failed_services failed, \t$total_services in total"
echo -e "Network checks: \t$score_network passed, \t$failed_network failed, \t$total_network in total"
echo -e "Logging checks: \t$score_logging passed, \t$failed_logging failed, \t$total_logging in total"
echo -e "Access & auth checks: \t$score_access passed, \t$failed_access failed, \t$total_access in total"
echo -e "System maint. checks: \t$score_system passed, \t$failed_system failed, \t$total_system in total"

echo "========================="

echo -n "Total passed: "
echo $total_score

echo -n "Total failure: "
echo $total_failed

echo -n "Tests amount: "
echo "$( expr $total_score + $total_failed )"

echo -n "Your score (%): "
echo "scale=2; $total_score / ($total_score+$total_failed) * 100" | bc