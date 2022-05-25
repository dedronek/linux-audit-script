echo "Auditing users and groups settings..."

cmd_check "password masked in /etc/passwd ... " 'awk -F: '\''($2 != "x" ) { print $1 " not masked "}'\'' /etc/passwd'

#ROOT NEEDED
if [[ $root -eq 1 ]]; then

  cmd_check "no password is empty in /etc/passwd ... " 'awk -F: '\''($2 == "" ) { print $1 " missing password "}'\'' /etc/shadow'
  fi

echo -n "all groups from /etc/passwd exist in /etc/group ... "


q1=`for i in $(cut -s -d: -f4 /etc/passwd | sort -u ); do grep -q -P "^.*?:[^:]*:$i:" /etc/group 2>&1
  if [ $? -ne 0 ]; then
    echo "false"
  fi
  done`

    if [[ "$q1" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "all home directories from /etc/passwd exist ... "


q1=`awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ && $7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {print $1 " " $6 }' /etc/passwd |
  while read -r user dir; do
    if [ ! -d "$dir" ]; then
      echo "false"
    fi
  done`

    if [[ "$q1" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "users own their home directories ... "


  q1=`grep -E -v '^(halt|sync|shutdown)' /etc/passwd 2>&1 | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read -r user dir
  do
    if [ ! -d "$dir" ]; then
      echo "false"
    else
      owner=$(stat -L -c "%U" "$dir")
      if [ "$owner" != "$user" ]; then
       echo "false"
      fi
    fi
  done`

    if [[ "$q1" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "users have permissions for their home directories (750 or more restrictive) ... "

q1=`awk -F: '($1!~/(halt|sync|shutdown)/ && $7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {print $1 " " $6}' /etc/passwd | while
  read -r user dir
do
  if [ ! -d "$dir" ]; then
    echo "false"
  else
    dirperm=$(stat -L -c "%A" "$dir")
    if [ "$(echo "$dirperm" | cut -c6)" != "-" ] || [ "$(echo "$dirperm" | cut -c8)" != "-" ] || [ "$(echo "$dirperm" | cut -c9)" != "-" ] || [ "$(echo "$dirperm" | cut -c10)" != "-" ]; then
        echo "false"
    fi
  fi
done`

    if [[ "$q1" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "users' dot files are not group or word writable ... "

  q1=`awk -F: '($1!~/(halt|sync|shutdown)/ && $7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) { print $1 " " $6 }' /etc/passwd | while
    read -r user dir
  do
    if [ -d "$dir" ]; then
      for file in "$dir"/.*; do
        if [ ! -h "$file" ] && [ -f "$file" ]; then
          fileperm=$(stat -L -c "%A" "$file")
          if [ "$(echo "$fileperm" | cut -c6)" != "-" ] || [ "$(echo "$fileperm" | cut -c9)" != "-" ]; then
            echo "false"
          fi
        fi
      done
    fi
  done`

    if [[ "$q1" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "no users have .netrc files ... "

q1=`awk -F: '($1!~/(halt|sync|shutdown)/ && $7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) { print $1 " " $6 }' /etc/passwd |
  while read -r user dir; do
    if [ -d "$dir" ]; then
      file="$dir/.netrc"
      if [ ! -h "$file" ] && [ -f "$file" ]; then
        if stat -L -c "%A" "$file" | cut -c4-10 | grep -Eq '[^-]+' 2>&1; then
          echo "FAILED"
        else
          echo "WARNING"
        fi
      fi
    fi
  done`

    if [[ "$q1" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "no users have .forward files ... "

q1=`awk -F: '($1!~/(root|halt|sync|shutdown)/ && $7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {print $1 " " $6 }' /etc/passwd |
  while read -r user dir; do
    if [ -d "$dir" ]; then
      file="$dir/.forward"
      if [ ! -h "$file" ] && [ -f "$file" ]; then
        echo "false"
      fi
    fi
  done`

    if [[ "$q1" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "no users have .rhosts files ... "

q1=`awk -F: '($1!~/(root|halt|sync|shutdown)/ && $7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {print $1 " " $6 }' /etc/passwd |
  while read -r user dir; do
    if [ -d "$dir" ]; then
      file="$dir/.rhosts"
      if [ ! -h "$file" ] && [ -f "$file" ]; then
        echo "User: \"$user\" file: \"$file\" exists"
      fi
    fi
  done`

    if [[ "$q1" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "root has UID 0 ... "

    q1=`awk -F: '($3 == 0) { print $1 }' /etc/passwd`

    if [[ "$q1" == "root" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

#ROOT NEEDED
if [[ $root -eq 1 && $is_sudo -eq 1 ]]; then

  echo -n "root PATH integrity ... "

  q1=`RPCV="$(sudo -Hiu root env | grep '^PATH' | cut -d= -f2)"
  echo "$RPCV" | grep -q "::" && echo "root's path contains a empty directory (::)"
  echo "$RPCV" | grep -q ":$" && echo "root's path contains a trailing (:)"
  for x in $(echo "$RPCV" | tr ":" " "); do
    if [ -d "$x" ]; then
      ls -ldH "$x" | awk '$9 == "." {print "PATH contains current working directory (.)"} $3 != "root" {print $9, "is not owned by root"} substr($1,6,1) != "-" {print $9, "is group writable"} substr($1,9,1) != "-" {print $9, "is world writable"}'
    else
      echo "$x is not a directory"
    fi
  done`

    if [[ "$q1" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

  fi

echo -n "UIDs are unique ... "

q1=`cut -f3 -d":" /etc/passwd | sort -n | uniq -c | while read x ; do [ -z "$x" ] && break
  set - $x
  if [ $1 -gt 1 ]; then
  users=$(awk -F: '($3 == n) { print $1 }' n=$2 /etc/passwd | xargs)
      echo "Duplicate UID ($2): $users"
    fi
  done`

    if [[ "$q1" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "GIDs are unique ... "

q1=`cut -d: -f3 /etc/group | sort | uniq -d | while read x ; do
    echo "Duplicate GID ($x) in /etc/group"
  done`

    if [[ "$q1" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "usernames are unique ... "

q1=`cut -d: -f1 /etc/passwd | sort | uniq -d | while read -r x; do
  echo "Duplicate login name $x in /etc/passwd"
    done`

    if [[ "$q1" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "group names are unique ... "

q1=`cut -d: -f1 /etc/group | sort | uniq -d | while read -r x; do
  echo "Duplicate group name $x in /etc/group"
    done`

    if [[ "$q1" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi

echo -n "shadow group is empty ... "

    q1=`awk -F: '($1=="shadow") {print $NF}' /etc/group`
    q2=`awk -F: -v GID="$(awk -F: '($1=="shadow") {print $3}' /etc/group)" '($4==GID) {print $1}' /etc/passwd`


    if [[ "$q1" == "" && "$q2" == "" ]]; then
        echo $success
        score=$( expr $score + 1 )
      else
        echo $failure
        failed=$( expr $failed + 1 )
      fi