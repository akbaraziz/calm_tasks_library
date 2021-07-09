payload ={}
headers = {'Content-Type': 'application/json', 'Accept': 'application/json'}
pc_user = '@@{PC_Creds.username}@@'
pc_pass = '@@{PC_Creds.secret}@@'

count = 0
while(count < 10):
  # Set the address and make images call
  url = "https://localhost:9440/karbon/v1-alpha.1/k8s/clusters/@@{cluster_name}@@/tasks/@@{task_uuid}@@"
  resp = urlreq(url, verb='GET',params=json.dumps(payload), headers=headers, auth='BASIC', user=pc_user, passwd=pc_pass, verify=False)

  task_status = resp.json()
  # If the call went through successfully, find the image by name
  if resp.ok:
    
    if task_status['percentage_complete'] == 100:
      print "Removal of worker node was successful", json.dumps(json.loads(resp.content), indent=4)
      exit(0)
    else:
      print "Removal of Worker Node not ready. {0} percentage complete. Sleeping for 60 seconds".format(task_status['percentage_complete'])
      count = count + 1
      sleep(60) #Sleep for 1 min
  # If the call failed
  else:
    print "Removal of Worker Node failed", json.dumps(json.loads(resp.content), indent=4)
    exit(1)

print "Error: Operation Timeout after 10 mins"
exit(1)