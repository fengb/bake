#!/bin/bash

# Bash Make  :P


export BASEDIR=$PWD
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


help() {
  tasks=`find $taskdir -type f | taskname`
  maxlength=`awk '{ if ( length > L ) { L=length} }END{ print L}' <<<"$tasks"`
  for task in $tasks; do
    printf "%-${maxlength}s" "$task"
    desc=`desc "$task"`
    if [ -n "$desc" ]; then
      echo " # $desc"
    else
      echo
    fi
  done
  exit
}


if [ -z $1 ]; then
  help
  exit
fi


file=`taskfile $1`
if [ ! -f $file ]; then
  echo "Task '$1' not found." >&2
  help
  exit 1
elif [ ! -x $file ]; then
  echo "Task '$1' not executable." >&2
  exit 1
fi


shift
$file $@
