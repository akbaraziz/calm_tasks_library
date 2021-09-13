user = "@@{PCAdmin_username}@@"
password = "@@{PCAdmin_password}@@"
ip = "@@{PC_IP}@@"

def process_request(url, method, user, password, headers, payload=None):
    r = urlreq(url, verb=method, auth="BASIC", user=user, passwd=password, params=payload, verify=False, headers=headers)
    return r

url = "https://" + ip + ":9440/api/nutanix/v3/network_security_rules"
headers = {'Accept': 'application/json', 'Content-Type': 'application/json'}
url_method = "POST"

payload = {
    "metadata": {
        "kind": "network_security_rule",
        "categories": {},
        "spec_version": 0
    },
    "spec": {
        "description": "@@{calm_application_name}@@",
        "resources": {
            "app_rule": {
                "action": "MONITOR",
                "outbound_allow_list": [],
                "target_group": {
                    "filter": {
                        "params": {
                            "Environment": [
                                "@@{calm_application_name}@@"
                            ],
                            "AppType": [
                                "Default"
                            ],
                            "AppTier": [
                                "DB"
                            ]
                        },
                        "kind_list": [
                            "vm"
                        ],
                        "type": "CATEGORIES_MATCH_ALL"
                    },
                    "default_internal_policy": "ALLOW_ALL",
                    "peer_specification_type": "FILTER"
                },
                "inbound_allow_list": [
                    {
                        "filter": {
                            "params": {
                                "Environment": [
                                    "@@{calm_application_name}@@"
                                ],
                                "AppType": [
                                    "Default"
                                ],
                                "AppTier": [
                                    "App"
                                ]
                            },
                            "kind_list": [
                                "vm"
                            ],
                            "type": "CATEGORIES_MATCH_ALL"
                        },
                        "tcp_port_range_list": [
                            {
                                "end_port": 5432,
                                "start_port": 5432
                            }
                        ],
                        "protocol": "TCP",
                        "peer_specification_type": "FILTER"
                    },
                    {
                        "filter": {
                            "params": {
                                "Environment": [
                                    "@@{calm_application_name}@@"
                                ],
                                "AppType": [
                                    "Default"
                                ],
                                "AppTier": [
                                    "App"
                                ]
                            },
                            "kind_list": [
                                "vm"
                            ],
                            "type": "CATEGORIES_MATCH_ALL"
                        },
                        "protocol": "UDP",
                        "udp_port_range_list": [
                            {
                                "end_port": 5432,
                                "start_port": 5432
                            }
                        ],
                        "peer_specification_type": "FILTER"
                    }
                ]
            }
        },
        "name": "@@{calm_application_name}@@"
    }
}



print "Payload: " + json.dumps(payload)

r = process_request(url, url_method, user, password, headers, json.dumps(payload))
print "Response Status: " + str(r.status_code)
print "Response: ", r.json()

print "policy_uuid_1=", r.json()['metadata']['uuid']
