#!/bin/bash

# Bash Make  :P


taskdir=Bakefile
default={default}


taskfile() {
  if [ -z "$1" ]; then
    echo "$taskdir/$default"
  elif [ -d "$taskdir/$1" ]; then
    echo "$taskdir/$1/$default"
  elif [ -e "$taskdir/$1" ]; then
    echo "$taskdir/$1"
  elif [[ "$1" == */* ]]; then
    echo "$taskdir/$1".*
  else
    find $taskdir -name "$1" -or -name "$1.*"
  fi
}


taskname() {
  delete_extension="s;\.[^/]*$;;"
  convert_directory_task="s;/$default;;"
  sed -e "s;^$taskdir/;;" -e "$delete_extension" -e $convert_directory_task
}


desc() {
  file=`taskfile $task`
  if [ ! -x "$file" ]; then
    echo "!!  not executable"
  elif grep -q '^ *$BAKE' "$file"; then
    echo -n "->  "
    sed -e '/^ *$BAKE/!d' -e 's;^ *$BAKE *\([^ ]*\).*$;\1;' "$file" | tr "\n" ' ' | sed 's/ *$//'
  else
    sed -e '/###/!d' -e 's/^### */##  /' "$file"
  fi
}


help() {
  tasks=`grep --recursive --files-without-match ==-==-== "$taskdir"| sort | taskname`
  maxlength=`awk '{ if ( length > L ) { L=length} }END{ print L}' <<<"$tasks"`
  for task in $tasks; do
    printf "%-${maxlength}s  %s\n" "$task" "`desc "$task"`"
  done
}


while [ ! -d $taskdir ]; do
  cd ..
done


if [ "$1" = "-h" ]; then
  help
  exit
fi

file=`taskfile $1`
if [ ! -f "$file" ]; then
  if [ $# -eq 0 ]; then
    echo "-bake: $default: not defined" >&2
    help
    exit
  fi

  echo "-bake: $1: does not exist" >&2
  exit 1
elif [ ! -x "$file" ]; then
  echo "-bake: $1: not executable" >&2
  exit 1
fi


shift
echo Baking "'`taskname <<<$file`'"
BAKE="$0" "$file" $@
