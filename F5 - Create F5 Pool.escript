resource = "ltm/pool"
base_url = "@@{f5_url}@@"
url = base_url + resource
url_method = "POST"
user = "@@{F5.username}@@"
password = "@@{F5.secret}@@"
hostname = "@@{service_name}@@-@@{calm_application_name}@@-@@{project_name}@@@@{build_number}@@"
print "Host Name: " + hostname 

def process_request(url, method, user, password, headers, payload=None):
    r = urlreq(url, verb=method, auth="BASIC", user=user, passwd=password, params=payload, verify=False, headers=headers)
    return r

headers = {'Accept': 'application/json', 'Content-Type': 'application/json'}
payload_obj = {}
payload_obj['name'] = hostname + "-pool"
payload_obj['description'] = "@@{service_name}@@ @@{calm_application_name}@@ Pool."
payload_obj['monitor'] = "/@@{partition}@@/@@{monitor}@@"
payload_obj['loadBalancingMode'] = "@@{loadBalancingMode}@@"

payload = json.dumps(payload_obj)
print "Payload: " + payload

r = process_request(url, url_method, user, password, headers, payload)
print "Response Status: " + str(r.status_code)
print "Response: " + str(r.json())