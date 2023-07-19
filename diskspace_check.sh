#!/bin/sh

cdir="/home/rails/scripts/monitoring/disk-space"
threshold=90
SLACK_URL=<>
cd $cdir

#If logs directory is not present
if [ ! -e Logs ]; then
  mkdir Logs
  if [ ! -e info.log ];then
    touch Logs/info.log
  fi
fi

echo "$(date)" >> Logs/info.log
df -H | grep -vE '^Filesystem|tmpfs|cdrom|loop' | awk '{ print $5 " " $1 }' | while read output;
do
  echo $output >> Logs/info.log
  pc="$(hostname)"
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge $threshold ]; then
    if [ "$(hostname)" = "ip-172-31-4-147" ]; then
	   pc="Demo Server"
    elif [ "$(hostname)" = "ip-172-31-26-63" ]; then
	   pc="Bizongo.net"
    elif [ "$(hostname)" = "ip-172-31-4-212" ]; then
	   pc="Indopus.in"
    fi
    echo "Running out of space $partition ($usep%) on $pc as on $(date)" >> Logs/info.log
    mtext=$(echo "Running out of space $partition ($usep%) on $pc as on $(date)")

    escapedText=$(echo $mtext | sed 's/"/\"/g' | sed "s/'/\'/g" )
    echo "{\"text\": \"@channel $escapedText\", \"link_names\": \"true\"}" > message.json

    curl -H "Content-type: application/json" -X POST -d @message.json $SLACK_URL
    /home/rails/scripts/disk-clear.sh
  fi
done

echo "" >> Logs/info.log

MaxFileSize=2048000
#MaxFileSize=1
file_size=`du -b Logs/info.log | tr -s '\t' ' ' | cut -d' ' -f1`
#echo "$file_size"
    if [ $file_size -gt $MaxFileSize ];then
        timestamp=`date +%s`
        mv Logs/info.log Logs/test.log.$timestamp
        touch Logs/info.log
    fi

file_count=$(ls -lq Logs/ | wc -l)
#echo "$file_count"
if [ $file_count -ge 5 ];then
  cd Logs/
 # rm "$(ls -t | tail -1)"
fi


