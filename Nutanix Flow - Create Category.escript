user = "@@{PCAdmin_username}@@"
password = "@@{PCAdmin_password}@@"
ip = "@@{PC_IP}@@"

def process_request(url, method, user, password, headers, payload=None):
    r = urlreq(url, verb=method, auth="BASIC", user=user, passwd=password, params=payload, verify=False, headers=headers)
    return r

headers = {'Accept': 'application/json', 'Content-Type': 'application/json'}

#AppTier/DB if not existed
url = "https://" + ip + ":9440/api/nutanix/v3/categories/AppTier/DB"
url_method = "PUT"
payload = {"value": "DB","description":"DB"}
r = process_request(url, url_method, user, password, headers, json.dumps(payload))
print "Response Status: " + str(r.status_code)
print "Response: ", r.json()

#environment
url = "https://" + ip + ":9440/api/nutanix/v3/categories/Environment/@@{ENVIRONMENT}@@"
url_method = "PUT"
payload = {"value": "@@{calm_application_name}@@","description":"@@{ENVIRONMENT}@@"}
r = process_request(url, url_method, user, password, headers, json.dumps(payload))
print "Response Status: " + str(r.status_code)
print "Response: ", r.json()