payload ={}
headers = {'Content-Type': 'application/json', 'Accept': 'application/json'}
pc_user = '@@{PC_Creds.username}@@'
pc_pass = '@@{PC_Creds.secret}@@'

# Set the address and make images call
url = "https://localhost:9440/karbon/v1/k8s/clusters/@@{cluster_name}@@/kubeconfig"
resp = urlreq(url, verb='GET',params=json.dumps(payload), headers=headers, auth='BASIC', user=pc_user, passwd=pc_pass, verify=False)

kubeconfig = resp.json()

#with open('@@{SRC_KUBECONFIG_name}@@', 'w') as outfile:
#  json.dump(kubeconfig['kube_config'], outfile)
 
kubearray = kubeconfig['kube_config'].splitlines()
print "src_server={}".format(kubearray[8].rstrip('server:'))
print "src_ca={}".format(kubearray[9].rstrip('certificate-authority-data:'))
print "src_token={}".format(kubearray[13].rstrip('token:'))
#print "src_kubeconfig={}".format(kubeconfig['kube_config'])