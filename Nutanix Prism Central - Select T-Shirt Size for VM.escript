# Purpose:  Sample calm script to dynamically change cpu\mem of VM via the REST API.
# Author: Chris Kingsley <chris.kingsley@nutanix.com>
# Date Created:  03/13/2020
# Date Modified:  1/20/2021
# Modified by:  Akbar Aziz <akbar.aziz@nutanix.com>
# Change log:  Added disk size, removed duplicate URI variable, added comments
# Version: 1.3

###################### DECLARE VARIABLES ######################
#
uri = "https://localhost:9440/api/nutanix/v3"
cluster_uuid = "@@{platform.status.cluster_reference.uuid}@@"
vm_uuid = "@@{id}@@"

# establish credentials
username = '@@{PcAdmin.username}@@'
username_secret = '@@{PcAdmin.secret}@@'

# match the tshirt size variable.
tshirt_size = '@@{tshirt_size}@@'
print(tshirt_size)

if tshirt_size == 'Small':
    vpcu = 2
    memory = 4096
    disk_size = 307200
elif tshirt_size == 'Extra Small':
    vpcu = 1
    memory = 2048
    disk_size = 307200
elif tshirt_size == 'Medium':
    vpcu = 2
    memory = 6144
    disk_size = 307200
elif tshirt_size == 'Large':
    vpcu = 4
    memory = 6144
    disk_size = 307200
elif tshirt_size == 'Extra Large':
    vpcu = 4
    memory = 8192
    disk_size = 307200


# How do we handle cost showbacks on the instances?

###################### DO NOT MODIFY BELOW HERE ######################
#
######################     DEFINE FUNCTIONS     ######################

# define the function 'rest_call'
# this encapsulates the api call.
def rest_call(url, method, payload="", username=username, username_secret=username_secret):

# we put the accept statement in here to ensure that we will only accept it in json.
    headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
    }

    if payload:
        resp = urlreq(
            url,
            verb=method,
            params=json.dumps(payload),
            auth="BASIC",
            user=username,
            passwd=username_secret,
            headers=headers,
            verify=False
        )
    else:
        resp = urlreq(
            url,
            verb=method,
            auth="BASIC",
            user=username,
            passwd=username_secret,
            headers=headers,
            verify=False
        )
# put in a try\catch block to ensure that we have json returned
    if resp.ok:
        try:
            return json.loads(resp.content)
        except:
            return resp.content
    else:
        print("Request failed")
        print("Headers: {}".format(headers))
        print("Payload: {}".format(json.dumps(payload)))
        print('Status code: {}'.format(resp.status_code))
        print('Response: {}'.format(json.dumps(
            json.loads(resp.content), indent=4)))
        exit(1)

######################## GET VM SPEC ########################
url = "{}/vms/{}".format(
    uri,
    vm_uuid
)
# Define the method (get\put\post, etc)
method = 'GET'

# create a variable - use the function 'rest_call' to populate the function.
response = rest_call(url=url, method=method)

######################## Change\update the  VM SPEC ########################
# delete 'status' element from json response
del response['status']

# update 'spec' element in the 'response' object with new vpcu and mem
response['spec']['resources']['num_sockets'] = vpcu
response['spec']['resources']['memory_size_mib'] = memory

# let's address the space allocation on disk 0
del response['spec']['resources']['disk_list'][0]['disk_size_bytes']
response['spec']['resources']['disk_list'][0]['disk_size_mib'] = disk_size

# set the method
method = 'PUT'
# create the 'payload' object from the updated 'response' object
payload = response

# 
response = rest_call(url=url, method=method, payload=payload)
print(response)