#!/bin/bash
NAME=$(echo rails@${qa_server}.indopus.in)
echo $NAME
echo "Generating ssl cert"
/home/produser/.acme.sh/acme.sh --issue --force --dns dns_aws -d $qa_server.indopus.in -d *.$qa_server.indopus.in

scp -r /home/produser/.acme.sh/$qa_server.indopus.in/* $NAME:~/ssl_dev

ssh -o StrictHostKeyChecking=no $NAME "sudo nginx -t"
ssh -o StrictHostKeyChecking=no $NAME "sudo nginx -s reload"
ssh -o StrictHostKeyChecking=no $NAME "sudo service nginx restart"
