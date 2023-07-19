#!/bin/bash

dev_vm_no=$(tail -1 /home/produser/jenkins/dev-vm/latest_vm.txt)

echo $dev_vm_no
current_vm_no=$((dev_vm_no+1));
try_uri="subscriptions/94af9b41-aae8-4856-8439-b52a1bf9da78/resourceGroups/Dev-VMs-Image-Central-India-21032022/providers/Microsoft.Compute/images/Dev-VMs-Central-India-VMimage-14032022"
current_pri_no=$((current_vm_no+1000));
subscriptionId=94af9b41-aae8-4856-8439-b52a1bf9da78
resourceGroupName=Dev-VMs-Image-Central-India-21032022
vmName="dev-vm${current_vm_no}"
OldHostname="dev-vm17"
nsg="/subscriptions/94af9b41-aae8-4856-8439-b52a1bf9da78/resourceGroups/Bizongo-SG/providers/Microsoft.Network/networkSecurityGroups/Bizongo_Network"
image="/subscriptions/94af9b41-aae8-4856-8439-b52a1bf9da78/resourceGroups/Dev-VMs-Image-Central-India-21032022/providers/Microsoft.Compute/images/Dev-VMs-Central-India-VMimage-14032022"
output_file="/home/produser/jenkins/dev-vm/output_dev${current_vm_no}-indopus.txt"
wildcard_current_env_name="*.Dev-VM${current_vm_no}"
echo $current_vm_no >> /home/produser/jenkins/dev-vm/latest_vm.txt

echo "Building $vmName"

az vm create --name $vmName --resource-group $resourceGroupName --image $image --nsg $nsg --public-ip-address-allocation static --size Standard_D4as_v4 > $output_file

echo "Whitelist $vmName in Bizongo-SG"

echo "***********************************************************************************************************************************"
sleep 10

az network nsg rule create --resource-group Bizongo-SG --nsg-name Bizongo_Network --name $vmName --subscription $subscriptionId --priority $current_pri_no --description $vmName --access Allow --source-address-prefixes $(cat $output_file | grep publicIpAddress | awk -F':' '{ print $2 }' | xargs | tr -d ',') --destination-port-ranges '*' --direction Inbound --protocol '*' --source-port-ranges '*'

echo "***********************************************************************************************************************************"

echo "Enabling nightly shutdown of the VM"
az vm auto-shutdown --location "centralindia" --subscription $subscriptionId -g $resourceGroupName -n $vmName --time 0100

echo "***********************************************************************************************************************************"
echo "Public IP of dev server"
IP=$(cat $output_file | grep publicIpAddress | awk -F':' '{ print $2 }' | tr -d '",')
echo $(cat $output_file | grep publicIpAddress | awk -F':' '{ print $2 }' | tr -d '",')

echo "***********************************************************************************************************************************"
echo "Adding IP to a DNS record in Route53"
aws route53 --profile stage change-resource-record-sets --hosted-zone-id Z05079122DO0IEBOMTS3I --change-batch '{ "Comment": "creating a record set", 
"Changes": [ { "Action": "CREATE", "ResourceRecordSet": { "Name": 
"'"$vmName"'.indopus.in", "Type": "A", "TTL": 
300, "ResourceRecords": [ { "Value": "'"$IP"'" } ] } } ] }'

echo "***********************************************************************************************************************************"
echo "Adding IP to a Wildcard DNS record in Route53"
aws route53 --profile stage change-resource-record-sets --hosted-zone-id Z05079122DO0IEBOMTS3I --change-batch '{ "Comment": "creating a record set", 
"Changes": [ { "Action": "CREATE", "ResourceRecordSet": { "Name": 
"'"*.$vmName"'.indopus.in", "Type": "A", "TTL": 
300, "ResourceRecords": [ { "Value": "'"$IP"'" } ] } } ] }'

ip=$(cat $output_file | grep publicIpAddress | awk -F':' '{ print $2 }' | xargs | tr -d ',')
ip="${ip}/32"
echo $ip

echo "***********************************************************************************************************************************"
echo "whitelisting this server on AWS Stage account DEMO Staging"
aws ec2 --profile stage --region ap-south-1 authorize-security-group-ingress --group-name "DEMO Staging" --ip-permissions IpProtocol=-1,FromPort=-1,ToPort=-1,IpRanges=[{CidrIp=$ip,Description=$vmName}]

echo "***********************************************************************************************************************************"
echo "whitelisting this server on AWS stag account Dev-Vm_Servers"
aws ec2 --profile stage --region ap-south-1 authorize-security-group-ingress --group-name "Dev-Vm_Servers" --ip-permissions IpProtocol=-1,FromPort=-1,ToPort=-1,IpRanges=[{CidrIp=$ip,Description=$vmName}]

echo "***********************************************************************************************************************************"
echo "whitelisting this server on AWS Production Dev-Vm_Servers"
aws ec2 --profile prod --region ap-south-1 authorize-security-group-ingress --group-name "Dev-Vm_Servers"  --ip-permissions IpProtocol=-1,FromPort=-1,ToPort=-1,IpRanges=[{CidrIp=$ip,Description=$vmName}]

echo "***********************************************************************************************************************************"
echo "whitelisting this server on AWS Production AD-Servers"
aws ec2 --profile prod --region ap-south-1 authorize-security-group-ingress --group-name "AD-Server"  --ip-permissions IpProtocol=-1,FromPort=-1,ToPort=-1,IpRanges=[{CidrIp=$ip,Description=$vmName}]

echo "***********************************************************************************************************************************"
echo "Configuring Dev Environment"
ssh -o StrictHostKeyChecking=no rails@$vmName.indopus.in "sudo sed -i 's/$OldHostname/$vmName/g' /etc/nginx/sites-enabled/* /etc/environment"
ssh -o StrictHostKeyChecking=no rails@$vmName.indopus.in "sudo sed -i 's/$OldHostname/$vmName/g' ./apps/micro-ticketing/.env ./apps/cataloguing-micro-frontend/.env ./apps/ums-micro-frontend/.env ./apps/go-partner/.env ./apps/reporting-micro-frontend/.env ./apps/Lead-Plus/.env ./apps/deliveries-micro-frontend/.env ./apps/configuration-ui/.env ~/apps/./vendor-management-frontend/.env ~/apps/./Partner-Hub/.env ~/apps/./transporter-app/.env ~/apps/./finance/.env ~/apps/artwork-frontend/.env ~/apps/./micro-procure-live/.env ~/apps/./procure-live/.env ~/apps/./ui-infra/.env ~/apps/./go-ops/.env ~/apps/./DCMS/.env"
ssh -o StrictHostKeyChecking=no rails@$vmName.indopus.in "sudo sysctl -w net.ipv4.tcp_keepalive_intvl=30"
ssh -o StrictHostKeyChecking=no rails@$vmName.indopus.in "sudo sysctl -w net.ipv4.tcp_keepalive_intvl=120"
ssh -o StrictHostKeyChecking=no rails@$vmName.indopus.in "sudo sed -i 's/ResourceDisk.Format=n/ResourceDisk.Format=y/g' /etc/nginx/sites-enabled/* /etc/waagent.conf"
ssh -o StrictHostKeyChecking=no rails@$vmName.indopus.in "sudo sed -i 's/ResourceDisk.EnableSwap=n/ResourceDisk.EnableSwap=y/g' /etc/nginx/sites-enabled/* /etc/waagent.conf"
ssh -o StrictHostKeyChecking=no rails@$vmName.indopus.in "sudo sed -i 's/ResourceDisk.SwapSizeMB=0/ResourceDisk.SwapSizeMB=16000/g' /etc/nginx/sites-enabled/* /etc/waagent.conf"
ssh -o StrictHostKeyChecking=no rails@$vmName.indopus.in "sudo sed -i '4a /mnt/swapfile none swap defaults 0 0 nano /etc/fstab"
ssh -o StrictHostKeyChecking=no rails@$vmName.indopus.in "sudo service walinuxagent restart"

echo "***********************************************************************************************************************************"
echo "Generating ssl cert"
/home/produser/.acme.sh/acme.sh --issue --force --dns dns_aws -d $vmName.indopus.in -d *.$vmName.indopus.in

echo "***********************************************************************************************************************************"
echo "ssl certificate is generated successfully New generated certifcate will be copied to $vmName"
scp -r /home/produser/.acme.sh/$vmName.indopus.in/* rails@$vmName.indopus.in:~/ssl_dev

echo "***********************************************************************************************************************************"
echo "restarting nginx service on $vmName"
ssh -o StrictHostKeyChecking=no rails@$vmName.indopus.in "sudo nginx -t"
ssh -o StrictHostKeyChecking=no rails@$vmName.indopus.in "sudo nginx -s reload"
ssh -o StrictHostKeyChecking=no rails@$vmName.indopus.in "sudo service nginx restart"
#ssh -o StrictHostKeyChecking=no rails@$vmName.indopus.in "sudo service nginx enable"


echo 
echo "***********************************************************************************************************************************"
echo "Your Dev-VM is ready with hostname:- $vmName!!"
#echo "You can ssh to your machine from produser on jumpbox using"
echo "ssh rails@$vmName.indopus.in"