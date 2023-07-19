#!/bin/bash
NAME=$(echo rails@${qa_server}.indopus.in)
echo $NAME

echo "Configuring the Dev Environment"

ssh -o StrictHostKeyChecking=no $NAME "sudo sed -i 's/dev-vm17/$qa_server/g' /etc/nginx/sites-enabled/* /etc/environment"
ssh -o StrictHostKeyChecking=no $NAME "sed -i 's/dev-vm17/$qa_server/g' ./apps/micro-ticketing/.env ./apps/cataloguing-micro-frontend/.env ./apps/ums-micro-frontend/.env ./apps/go-partner/.env ./apps/reporting-micro-frontend/.env ./apps/Lead-Plus/.env ./apps/deliveries-micro-frontend/.env ./apps/configuration-ui/.env ~/apps/./vendor-management-frontend/.env ~/apps/./Partner-Hub/.env ~/apps/./transporter-app/.env ~/apps/./finance/.env ~/apps/artwork-frontend/.env ~/apps/./micro-procure-live/.env ~/apps/./procure-live/.env ~/apps/./ui-infra/.env ~/apps/./go-ops/.env ~/apps/./DCMS/.env"
