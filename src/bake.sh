#!/bin/bash

# Bash Make  :P


taskdir=Bakefile


taskfile() {
  echo $1 | sed -e "s;^$taskdir/;;" -e "s;^;$taskdir/;;"
}


taskname() {
  sed "s;^$taskdir/;;"
}


desc() {
  sed -e '/###/!d' -e 's/^### *//' `taskfile $1`
}


executable() {
  [ -x `taskfile $1` ]
}


help() {
  tasks=`find $taskdir -type f | sort | taskname`
  maxlength=`awk '{ if ( length > L ) { L=length} }END{ print L}' <<<"$tasks"`
  for task in $tasks; do
    desc=`desc "$task"`
    if ! executable $task; then
      printf "%-${maxlength}s !! not executable" "$task"
    elif [ -n "$desc" ]; then
      printf "%-${maxlength}s # %s" "$task" "$desc"
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
if [ ! -f $file ]; then
  echo "Task '$1' not found." >&2
  help
  exit 1
elif ! executable $1; then
  echo "Task '$1' not executable." >&2
  exit 1
fi


shift
$file $@
