
prism_ip = "@@{PC_IP}@@"
cluster_name = "@@{platform.status.cluster_reference.name}@@"
nf_chain_name = "PANOS_CHAIN"

def crudops(api_url, payload):
  jwt = '@@{calm_jwt}@@'
  headers = {'Content-Type': 'application/json',  'Accept':'application/json', 'Authorization': 'Bearer {}'.format(jwt)}
  r = urlreq(api_url, verb='POST', params=json.dumps(payload), headers=headers, verify=False)
  if r.ok:
    resp = json.loads(r.content)
    return resp
  else:
    print "Post request failed", r.content
    exit(1)


print "Get cluster list"
cluster_api = 'https://{0}:9440/api/nutanix/v3/clusters/list'.format(prism_ip)
payload = {"kind": "cluster"}
cluster_list = crudops(api_url=cluster_api, payload=payload)
for i in cluster_list['entities']:
  if i['spec']['name'] == cluster_name:
    print i
    cluster_uuid = i['metadata']['uuid']
    break

    
print "Get NF list"
nf_list_api = 'https://{0}:9440/api/nutanix/v3/network_function_chains/list'.format(prism_ip)
payload = {}
nf_list = crudops(api_url=nf_list_api, payload=payload)
nf_exists = False
for i in nf_list['entities']:
  if i['status']['name'] == nf_chain_name:
    print i
    nf_exists = True
    nf_uuid = i['metadata']['uuid']
    break
    
print "Creating/Updating service chain"
service_chain_api = 'https://{0}:9440/api/nutanix/v3/network_function_chains'.format(prism_ip)
payload = {
"spec": {
"name": nf_chain_name,
"resources": {
"network_function_list": [
{
"network_function_type": "INLINE",
"category_filter": {
"type": "CATEGORIES_MATCH_ANY",
"params": {"network_function_provider": ["PaloAlto"]}
}
}
]
},
"cluster_reference": {
"kind": "cluster",
"name": cluster_name,
"uuid": cluster_uuid
}
},
"api_version": "3.1.0",
"metadata": {
"kind": "network_function_chain"
}
}

if not nf_exists and @@{calm_array_index}@@ == 0:
  crudops(api_url=service_chain_api, payload=payload)
  print "Created service chain"
else:
  print "Not creating chain as chain exists"