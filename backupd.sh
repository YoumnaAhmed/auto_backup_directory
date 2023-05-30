#!/bin/bash

if [[ $# != 4 ]]; then
    echo "Number of arguments do not match the prerequisites of this project"
    exit
fi
dir=$1
backupdir=$2
interval_secs=$3
max_backups=$4
number='^[0-9]+$'

 
if ! [[ $interval_secs =~ $number ]] ; then
	echo "you must enter +ve integer for interval seconds"
	exit
fi
if ! [[ $max_backups =~ $number ]] ; then
	echo "you must enter +ve integer for maximum number of backup"
	exit
fi
if ! [[ -e $dir ]]; then
         echo "source directory does not exist"
         exit
fi
ls -lr $dir > directory-info.last
x=$(date +%F-%H-%M-%S)
mkdir -p "$backupdir/$x"
cp -r $dir $backupdir/$x
while true;do
        sleep $interval_secs
	ls -lr $dir > directory-info.new
     
	if ! cmp -s "directory-info.new"  "directory-info.last" ;then
	
	count=0
	sub_directories=($backupdir/*)
	oldest=${sub_directories[0]}
	for folder in $backupdir/*;do
	 	   count=`expr $count + 1 `
	 	   if [[ $folder -ot $oldest ]]; then
	 	     oldest=$folder
	 	   fi
	 	done
	 if [[ $count -eq $max_backups ]]; then
	 	 rm -r $oldest  
	 fi	 	
	   x=$(date +%F-%H-%M-%S)
	   mkdir -p "$backupdir/$x"
           cp -r $dir $backupdir/$x
           cp  directory-info.new directory-info.last
	 	
	fi
done

