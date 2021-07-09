#!/bin/bash

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

# Get Number of Nodes
NODE_COUNT=$(curl -k -u "@@{Prism Central User.username}@@:@@{Prism Central User.secret}@@" -X GET -H "Accept: application/json" -H "Content-Type: application/json" \
    https://@@{pc_instance_ip}@@:9440/karbon/v1-beta.1/k8s/clusters/@@{k8s_cluster_name}@@/node-pools/${NODE_POOL} \
| jq -r '.num_instances')

NODE_LIST=$(curl -k -u "@@{Prism Central User.username}@@:@@{Prism Central User.secret}@@" -X GET -H "Accept: application/json" -H "Content-Type: application/json" \
    https://@@{pc_instance_ip}@@:9440/karbon/v1-beta.1/k8s/clusters/@@{k8s_cluster_name}@@/node-pools/${NODE_POOL} \
| jq -r '.nodes | .[] | "\(.hostname)"' | sort -r)

if [ $NODE_COUNT -le @@{min_worker_count}@@ ]; then
    echo "Unable to remove more nodes as the node count is at or below minimum node count."
    exit 0
fi

LOOP_COUNT=0
for NODE in $NODE_LIST
do
    
    if [ $NODE_COUNT -le @@{min_worker_count}@@ ]; then
        echo "Unable to remove more nodes as the node count is at or below minimum node count."
        exit 0
    fi
    
    echo $NODE
    
    if [ $LOOP_COUNT -lt @@{worker_scale_in_count}@@ ]; then
        curl -k -b /tmp/cookiefile -X DELETE https://@@{pc_instance_ip}@@:9440/karbon/acs/k8s/cluster/$K8S_UUID/workers/$NODE
    else
        echo "Number of specified nodes has been removed."
        exit 0
    fi
    
    sleep 5
    
    LOOP_COUNT=$(($LOOP_COUNT+1))
    
    NODE_COUNT=$(curl -k -u "@@{Prism Central User.username}@@:@@{Prism Central User.secret}@@" -X GET \
        -H "Accept: application/json" -H "Content-Type: application/json" \
        https://@@{pc_instance_ip}@@:9440/karbon/v1-beta.1/k8s/clusters/@@{k8s_cluster_name}@@/node-pools/${NODE_POOL} \
    | jq -r '.num_instances')
    
    echo $NODE_COUNT
    
done

echo $NODE_COUNT