#!/bin/sh

  # Purpose: To monitor the Memory utilization and alert the channel if it is found above the threshold continuously for 5 minutes

#directory where the script is located
cdir="/home/rails/scripts/monitoring/memory-check/"

SLACK_URL=<>


threshold=90

cd $cdir

#Setting up Logs Folder for the first time
if [ ! -e Logs ]; then
  mkdir Logs
    if [ ! -e info.log ]; then
      touch Logs/info.log
    fi
fi

#echo "$(date +"%m-%d-%y-%T")" >> Logs/info.log

#check the memory utilization
memory_util=$(free | awk 'FNR == 2 {print ($3)/($2)*100}')
echo "$(date +"%m-%d-%y-%T")    $memory_util" >> Logs/info.log
memory_util=$(echo ${memory_util%\.*})

if [ $memory_util -ge $threshold ]; then
    echo "Memory is above the threshold limit. Monitoring memory every 10 seconds for next 5 minutes..." >> Logs/info.log
    count=1
    while [ $count -le 29 ]
    do
        sleep 10
        memory_util=$(free | awk 'FNR == 2 {print ($2-$7)/($2)*100}')
        memory_util=$(echo ${memory_util%\.*})
        secs=$(( count * 10 ))
        echo "At $secs seconds ... Memory: $memory_util" >> Logs/info.log
        if [ $memory_util -le $threshold ]; then
            count=200
        fi
        count=$(( count + 1 ))
    done
    if [ $count -eq 30 ]; then
        pc="$(hostname)"
        if [ "$(hostname)" = "ip-172-31-4-147" ]; then
         pc="Demo Server"
        elif [ "$(hostname)" = "ip-172-31-26-63" ]; then
         pc="Bizongo.net"
        elif [ "$(hostname)" = "ip-172-31-4-212" ]; then
         pc="Indopus.in"
        fi
        echo "{\"link_names\": \"true\", \"attachments\": [{\"text\": \"@channel Memory utilization has been above the threshold for 5 minutes\",\"fields\": [{\"title\": \"Memory\",\"value\": \"$memory_util %\",\"short\": true},{\"title\": \"Server\",\"value\": \"$pc\",\"short\": true}],\"color\": \"danger\"}]}" > message.json
        curl -H "Content-type: application/json" -X POST -d @message.json $SLACK_URL
    fi
fi

echo "" >> Logs/info.log

  #Checking the log size and if greater than MaxFileSize, create the new log file
  MaxFileSize=2048000
  file_size=`du -b Logs/info.log | tr -s '\t' ' ' | cut -d' ' -f1`
      if [ $file_size -gt $MaxFileSize ];then
          timestamp=`date +%s`
          mv Logs/info.log Logs/test.log.$(date +"%m-%d-%y-%T")
          touch Logs/info.log
      fi

  cd $cdir
  #clear old logs
  file_count=$(ls Logs/ | wc -l)
  if [ $file_count -ge 5 ];then
    cd Logs/
    logfile=$(ls -t | grep -E '^test.log' | tail -1)
    rm $logfile
  fi

