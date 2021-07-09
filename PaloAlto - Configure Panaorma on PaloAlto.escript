def postrequest(api_url,payload):
  r = urlreq(api_url, verb='POST',auth="BASIC", params=payload, user='admin', passwd='admin', verify=False)
  if 'success' in r.content:
    return r.content
  else:
    print "PAN API configuration failed",r.content
    exit(1)


url1 = "https://@@{Panorama_IP}@@/api"
#Get the auth key for making API requests
payload = {'type': 'keygen', 'user': '@@{Panorama_Username}@@', 'password': '@@{Panorama_Password}@@'}
key_str = postrequest(api_url=url1,payload=payload)
key = key_str.split('<key>')[1].split('</key>')[0]

if @@{calm_array_index}@@ == 0:
    print "Configuring Panorama"
  
    #Create device group
    payload = {'type': 'config', 'action': 'set', 'key':key, 'xpath':"/config/devices/entry[@name='localhost.localdomain']/device-group/entry[@name='@@{Panorama_DeviceGroup}@@']", 'element':"<description>Device group added from Nutanix Calm</description>"}
    print postrequest(api_url=url1,payload=payload)


    #Create the template
    payload = {'type': 'config', 'action': 'set', 'key':key, 'xpath':"/config/devices/entry[@name='localhost.localdomain']/template/entry[@name='@@{Panorama_Template}@@']", 'element':"<settings/>"}
    print postrequest(api_url=url1,payload=payload)


    #Create interfaces on template
    payload = {'type': 'config', 'action': 'set', 'key':key, 'xpath':"/config/devices/entry[@name='localhost.localdomain']/template/entry[@name='@@{Panorama_Template}@@']/config/devices/entry[@name='localhost.localdomain']/network/interface/ethernet/entry[@name='ethernet1/1']", 'element':"<virtual-wire><lldp><enable>no</enable></lldp></virtual-wire>"}
    print postrequest(api_url=url1,payload=payload)

    payload = {'type': 'config', 'action': 'set', 'key':key, 'xpath':"/config/devices/entry[@name='localhost.localdomain']/template/entry[@name='@@{Panorama_Template}@@']/config/devices/entry[@name='localhost.localdomain']/network/interface/ethernet/entry[@name='ethernet1/2']", 'element':"<virtual-wire><lldp><enable>no</enable></lldp></virtual-wire>"}
    print postrequest(api_url=url1,payload=payload)


    #create Virtual wire
    payload = {'type': 'config', 'action': 'set', 'key':key, 'xpath':"/config/devices/entry[@name='localhost.localdomain']/template/entry[@name='@@{Panorama_Template}@@']/config/devices/entry[@name='localhost.localdomain']/network/virtual-wire/entry[@name='@@{Panorama_Vwire}@@']", 'element':"<tag-allowed>0-4094</tag-allowed><interface1>ethernet1/1</interface1><interface2>ethernet1/2</interface2>"}
    print postrequest(api_url=url1,payload=payload)

    #Create Zones
    payload = {'type': 'config', 'action': 'set', 'key':key, 'xpath':"/config/devices/entry[@name='localhost.localdomain']/template/entry[@name='@@{Panorama_Template}@@']/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='vsys1']", 'element':"<import><network><interface><member>ethernet1/1</member><member>ethernet1/2</member></interface></network></import>"}
    print postrequest(api_url=url1,payload=payload)

    payload = {'type': 'config', 'action': 'set', 'key':key, 'xpath':"/config/devices/entry[@name='localhost.localdomain']/template/entry[@name='@@{Panorama_Template}@@']/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='vsys1']/zone/entry[@name='@@{Panorama_Zone}@@']", 'element':"<network><virtual-wire><member>ethernet1/1</member><member>ethernet1/2</member></virtual-wire></network>"}
    print postrequest(api_url=url1,payload=payload)

    #Create template stack with template
    payload = {'type': 'config', 'action': 'set', 'key':key, 'xpath':"/config/devices/entry[@name='localhost.localdomain']/template-stack/entry[@name='@@{Panorama_TemplateStack}@@']", 'element':"<templates><member>@@{Panorama_Template}@@</member></templates><settings><default-vsys>vsys1</default-vsys></settings>"}
    print postrequest(api_url=url1,payload=payload)


    #Commit the changes
    payload = {'type': 'commit', 'cmd': '<commit-all></commit-all>', 'key':key}
    print postrequest(api_url=url1,payload=payload)

    sleep(60)

    #Add vsys the template
    payload = {'type': 'config', 'action': 'set', 'key':key, 'xpath':"/config/devices/entry[@name='localhost.localdomain']/template/entry[@name='@@{Panorama_Template}@@']", 'element':"<settings><default-vsys>vsys1</default-vsys></settings>"}
    print postrequest(api_url=url1,payload=payload)


    #commit and Push the changes
    payload = {'type': 'commit', 'cmd': '<commit-all></commit-all>', 'key':key}
    print postrequest(api_url=url1,payload=payload)

    sleep(60)
 
else:
    print "Panorama configuration is done only on 0th node"