#!/bin/bash

# Bash Make  :P


taskdir=Bakefile


taskfile() {
  if [ -e "$taskdir/$1" ]; then
    echo "$taskdir/$1"
  elif [[ "$1" == */* ]]; then
    echo "$taskdir/$1".*
  else
    find $taskdir -name "$1" -or -name "$1.*"
  fi
}


taskname() {
  sed -e "s;^$taskdir/;;" -e "s;\.[^/]*$;;"
}


desc() {
  file=`taskfile $task`
  if [ ! -x "$file" ]; then
    echo "!! not executable"
  elif grep -q '^$BAKE' "$file"; then
    echo -n "-> "
    sed -e '/^$BAKE/!d' -e 's;^$BAKE *\([^ ]*\).*$;\1;' "$file" | tr "\n" ' ' | sed 's/ *$//'
  else
    sed -e '/###/!d' -e 's/^### */## /' "$file"
  fi
}


help() {
  tasks=`find $taskdir -type f -or -type l | sort | taskname`
  maxlength=`awk '{ if ( length > L ) { L=length} }END{ print L}' <<<"$tasks"`
  for task in $tasks; do
    desc=`desc "$task"`
    if [ -n "$desc" ]; then
      printf "%-${maxlength}s %s\n" "$task" "`desc "$task"`"
    else
      echo "$task"
    fi
  done
  exit
}


while [ ! -d $taskdir ]; do
  cd ..
done


if [ -z $1 ]; then
  help
  exit
fi


file=`taskfile $1`
if [ ! -f "$file" ]; then
  echo "-bake: $1: does not exist" >&2
  exit 1
elif [ ! -x "$file" ]; then
  echo "-bake: $1: not executable" >&2
  exit 1
fi


shift
echo Baking "'`taskname <<<$file`'"
BAKE="$0" "$file" $@
