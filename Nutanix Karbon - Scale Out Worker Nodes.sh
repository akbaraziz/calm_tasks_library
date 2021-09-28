#!/bin/bash

pc_instance_ip= '10.10.10.35'

# Set authentication cookie
curl -k -u "@@{Prism Central User.username}@@:@@{Prism Central User.secret}@@" \
-c /tmp/cookiefile -X POST -H "Accept: application/json" -H "Content-Type: application/json" \
-d '{}' https://@@{pc_instance_ip}@@:9440/api/nutanix/v3/clusters/list

# Get K8s cluster UUID
K8S_UUID=$(curl -k -b /tmp/cookiefile -X POST https://@@{pc_instance_ip}@@:7050/acs/k8s/cluster/list | \
jq -r '[ .[].cluster_metadata | select( .name | match("(^@@{k8s_cluster_name}@@$)")) ]' | jq -r '.[].uuid')

# Get K8s cluster UUID
NODE_POOL=`curl -k -u "@@{Prism Central User.username}@@:@@{Prism Central User.secret}@@" \
-X GET -H "Accept: application/json" -H "Content-Type: application/json" https://@@{pc_instance_ip}@@:9440/karbon/v1/k8s/clusters/@@{k8s_cluster_name}@@ \
| jq -r '.worker_config.node_pools | .[] '`

# Get Task UUID
TASK_UUID=$(curl -k -b /tmp/cookiefile -X POST -H "Accept: application/json" -H "Content-Type: application/json" \
    --data-binary  '{"node_pool_name":"'$NODE_POOL'","worker_count":@@{worker_scale_out_count}@@}' \
https://@@{pc_instance_ip}@@:9440/karbon/acs/k8s/cluster/$K8S_UUID/workers | jq -r '.task_uuid')

sleep 30

STATUS_COMPLETE=$(curl -k -u "@@{Prism Central User.username}@@:@@{Prism Central User.secret}@@" -X GET --header "Accept: application/json" \
    https://@@{pc_instance_ip}@@:9440/api/nutanix/v3/tasks/$TASK_UUID \
| jq -r '.percentage_complete')

echo "${STATUS_COMPLETE}% Complete"

while [ $STATUS_COMPLETE -lt 100 ];do
    sleep 15
    STATUS_COMPLETE=$(curl -k -u "@@{Prism Central User.username}@@:@@{Prism Central User.secret}@@" -X GET --header "Accept: application/json" \
        https://@@{pc_instance_ip}@@:9440/api/nutanix/v3/tasks/$TASK_UUID \
    | jq -r '.percentage_complete')
    echo "${STATUS_COMPLETE}% Complete"
done

