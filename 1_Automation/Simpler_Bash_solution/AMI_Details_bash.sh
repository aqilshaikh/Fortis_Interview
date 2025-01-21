#!/bin/bash

# Fetch instance data and group by AMI
aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId, ImageId]" --output text | \
awk '{instances[$2] = instances[$2] ? instances[$2] "," $1 : $1} 
     END {for (ami in instances) print ami, instances[ami]}' | \
while read -r ami_id instance_ids; do
    ami_details=$(aws ec2 describe-images --image-ids "$ami_id" --query "Images[0]" --output json 2>/dev/null || echo '{}')
    echo "{\"$ami_id\": $ami_details, \"InstanceIds\": [$(echo $instance_ids | sed 's/,/","/g' | sed 's/^/"/;s/$/"/')]}"
done | jq -s 'add' > ami_output.json

echo "AMI details saved to ami_output.json"
