#!/bin/bash

GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'

success="${GREEN}Passed${NC}"
failure="${RED}Not passed${NC}"

function cmd_check()
{
    echo -n "$1"

    q=`bash -c "${2}"`

    #echo $q

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

score=0
failed=0

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/functions/1_filesystem.sh"

echo -n "Total passed: "
echo $score

echo -n "Total failure: "
echo $failed

echo -n "Your score (%): "
echo "scale=2; $score / ($score+$failed) * 100" | bc