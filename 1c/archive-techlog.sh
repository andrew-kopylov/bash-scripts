#!/bin/bash

# Example with cron:
# crontab -e 
# 5 * * * * /bin/bash /home/usr1cv8/log/scripts/archive-techlog.sh /home/usr1cv8/log /var/1C/archive-techlog 10 > /dev/null

#logpath=/home/usr1cv8/log
#arcpath=/var/backups/1C/log

logpath=$1
arcpath=$2
keepday=$3

if [[ -d $logpath ]]
then :
else 
	echo "Log directory $logpath is not exist"
	exit 1
fi

logpathname=$(basename $logpath)
logpathdir=$(dirname $logpath)
logname=$(date -d "now - 1 hour" +%y%m%d%H)
arcname=$(hostname)"-$logname.tar.gz"

if [[ -d $arcpath ]] 
then :
else
	echo "Create archive direcotry $arcpath"
	if mkdir -p $arcpath
	then :
	else 
		echo "Archive directory $arcpath create error"
		exit 1
	fi
fi

echo "logpath=$logpathdir/$logpathname; arcpath=$arcpath/$arcname"

if [[ -e $arcpath"/"$arcname ]] 
then
	echo "Archive $arcpath"/"$arcname already exists"
	exit 1
fi

if cd $logpathdir
then
	find $logpathname -name "$logname.log" -print0 | xargs -0 tar -cvzf $arcpath"/"$arcname
fi

if [[ -n $keepday ]] 
then
	echo "Remove archives older then $keepday days"
	find $arcpath -mtime +$keepday -name "*.tar.gz" -exec rm {} \;
fi
