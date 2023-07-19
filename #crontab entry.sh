#crontab entry

#Memory-check
0,5,10,15,20,25,30,35,40,45,50,55 * * * * /bin/bash -l -c '/home/rails/scripts/monitoring/memory-check/memory-check.sh'

#cpu-check
0,5,10,15,20,25,30,35,40,45,50,55 * * * * /bin/bash -l -c '/home/rails/scripts/monitoring/cpu-check/cpu-check.sh'

#disk-space
0 * * * * /bin/bash -l -c '/home/rails/scripts/monitoring/diskspace-check/diskspace-check.sh'

#QA16
postgresql-9.5-main.log = 2023-01-01 - 2023-01-04
postgresql-9.5-main.log.1 = 2022-12-30 - 2023-01-01 00:51:50 UTC
postgresql-9.5-main.log.2 = 2022-12-23 04:41:21 UTC - 2022-12-23 05:30:39 UTC 
postgresql-9.5-main.log.3 = 2022-12-21 08:42:57 UTC - 2022-12-21 09:31:58 UTC