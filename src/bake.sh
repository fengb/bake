#!/bin/bash

# Bash Make  :P


export BASEDIR=$PWD
taskdir=Bakefile


taskfile() {
  echo $1 | sed -e "s;^$taskdir/;;" -e "s;^;$taskdir/;;"
}


taskname() {
  echo $1 | sed "s;^$taskdir/;;"
}


desc() {
  sed -e '/###/!d' -e 's/^### *//' `taskfile $1`
}


help() {
  find $taskdir -type f | while read file; do
    echo `taskname $file` '#' `desc "$file"`
  done
  exit
}


if [ -z $1 ]; then
  help
  exit
fi


file=`taskfile $1`
if [ ! -f $file ]; then
  echo "Task '$1' not found." >&1
  help
  exit 1
elif [ ! -x $file ]; then
  echo "Task '$1' not executable." >&2
  exit 1
fi


shift
$file $@
