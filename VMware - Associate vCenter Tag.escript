# Set creds, headers, and URL
vcenter_ip = "@@{vCenter_IP}@@"
vcenter_user = '@@{vCenter.username}@@'
vcenter_pass = '@@{vCenter.secret}@@'
tag_name = '@@{TAG_NAME}@@'
vm_name = '@@{name}@@'
headers = {'Content-Type': 'application/json', 'Accept': 'application/json'}
base_url     = "https://@@{vCenter_IP}@@/rest"
resp_out = {}
vm_id = ""
tag_id = ""

# Create VMware Session
url = base_url + '/com/vmware/cis/session'
resp = urlreq(url, verb='POST', auth='BASIC', user=vcenter_user, passwd=vcenter_pass, headers=headers)
resp_out = json.loads(resp.content)
print(resp_out)
sid = resp.json()['value']

if resp.status_code != 200:
  print "Session creation failed for vcenter %s" % (vcenter_ip)
  exit(1)
  

# List down all vms 
url = base_url + '/vcenter/vm'
resp = urlreq(url, verb='GET', auth='BASIC', user=vcenter_user, passwd=vcenter_pass, headers={'vmware-api-session-id':sid})
resp_out = json.loads(resp.content)


if resp.status_code != 200:
  print "VM List failed for vcenter %s" % (vcenter_ip)
  exit(1)

#Find out vm_id for further activity.
for vm in resp_out["value"]:
    if vm["name"] == vm_name:
        vm_id = vm["vm"]
        break
        
# List down all tags
url = base_url + '/com/vmware/cis/tagging/tag'
resp = urlreq(url, verb='GET', auth='BASIC', user=vcenter_user, passwd=vcenter_pass, headers={'vmware-api-session-id':sid})
resp_out = json.loads(resp.content)


# Find out tag_id for vm tag association.
for t_id in resp_out["value"]:

# Get tag_id for given tag name
    url = base_url + '/com/vmware/cis/tagging/tag/id:' + t_id
    resp = urlreq(url, verb='GET', auth='BASIC', user=vcenter_user, passwd=vcenter_pass, headers={'vmware-api-session-id':sid})
    resp_out = json.loads(resp.content)
        
    if resp.status_code != 200:
        print "Failed while getting tag details for tag_id  %s" % (tag_id)
        continue

    if resp_out["value"]["name"] == tag_name:
        tag_id = t_id
        break
        
## Associate Tag to VM

payload = {}
payload['object_id'] = {}
payload['object_id']['id'] = vm_id
payload['object_id']['type'] = "VirtualMachine"



data = json.dumps(payload)


print(data)

url = base_url + '/com/vmware/cis/tagging/tag-association/id:' + tag_id + '?~action=attach'
print(url)
resp = urlreq(url, verb='POST', auth='BASIC', user=vcenter_user, passwd=vcenter_pass, params=data, headers={'vmware-api-session-id': sid, 'Content-Type': 'application/json', 'Accept': 'application/json'})
print(resp.status_code)


if resp.status_code != 200:
  print "Failed while associating tag '%s' to vm '%s' " % (tag_name, vm_name)
  exit(1)

print "success associating tag '%s' to vm '%s' " % (tag_name, vm_name)