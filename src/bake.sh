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
  file=`taskfile $task`
  if [ -L "$file" ]; then
    file $file
  elif [ ! -x "$file" ]; then
    echo "!! not executable"
  elif grep -q '^bake' "$file"; then
    echo -n "-> "
    sed -e '/^bake/!d' -e 's/^bake *//' "$file" | tr "\n" ' ' | sed 's/ *$//'
  else
    sed -e '/###/!d' -e 's/^### */## /' "$file"
  fi
}


executable() {
  [ -x `taskfile $1` ]
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
  echo "Task '$1' not found." >&2
  help
  exit 1
elif [ ! -x "$file" ]; then
  echo "Task '$1' not executable." >&2
  exit 1
fi


shift
$file $@
