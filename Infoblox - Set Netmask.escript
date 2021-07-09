(addrString, cidrString) = "@@{network}@@".split('/')
# Split address into octets and turn CIDR into int
addr = addrString.split('.')
cidr = int(cidrString)
# Initialize the netmask and calculate based on CIDR mask
mask = [0, 0, 0, 0]
for i in range(cidr):
	mask[i/8] = mask[i/8] + (1 << (7 - i % 8))
# Initialize net and binary and netmask with addr to get network
net = []
for i in range(4):
	net.append(int(addr[i]) & mask[i])
# Duplicate net into broad array, gather host bits, and generate broadcast
broad = list(net)
brange = 32 - cidr
for i in range(brange):
	broad[3 - i/8] = broad[3 - i/8] + (1 << (i % 8))
# Print information, mapping integer lists to strings for easy printing
print "cidr=" , cidr
print "net_ip_address=" , addrString
print "subnet_mask=" , ".".join(map(str, mask))
print "network=" , ".".join(map(str, net))
print "broadcast=" , ".".join(map(str, broad))