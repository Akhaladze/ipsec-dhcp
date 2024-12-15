config setup

conn %default
	ikelifetime=60m
	keylife=20m
	rekeymargin=3m
	keyingtries=1
	keyexchange=ikev2
	leftcert=moonCert.pem
	leftid=@moon.strongswan.org
	leftfirewall=yes
	right=%any

conn int 
	left=10.1.0.1
	leftsubnet=10.3.0.0/16,10.4.0.0/16
	rightsourceip=%intpool
	auto=add

conn ext 
	left=192.168.0.1
	leftsubnet=10.3.0.0/16,10.4.0.0/16
	rightsourceip=%extpool
	auto=add








config setup
    charondebug="ike 2, knl 2, cfg 2"

conn %default
    keyexchange=ikev2
    authby=psk
    mobike=no
    dpdaction=restart
    dpddelay=30s
    dpdtimeout=120s

conn myvpn
    left=192.168.100.189
    leftid=192.168.100.189
    leftsubnet=192.168.100.189/32
    right=%any
    rightsourceip=%dhcp-pool
    auto=add
