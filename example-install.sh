IPSEC_VER=6.0.0
IPSEC_DB_URI=sqlite:///usr/lib/ipsec/ipsec.db
IPSEC_DB_FILE=/usr/lib/ipsec/ipsec.db
IPSEC_DB_TYPE=sqlite
IPSEC_DB_NAME=ipsec
IPSEC_DB_USER=ipsec
IPSEC_DB_PASS=ipsec
IPSEC_DB_HOST=localhost
IPSEC_DB_PORT=0
IPSEC_DB_POOL=dhcp-pool
IPSEC_DB_POOL_START=
IPSEC_DB_POOL_END=
IPSEC_DB_DUMP=/usr/share/strongswan/templates/database/sql/$IPSEC_DB_TYPE.sql
IPSEC_LIBEXEC_PATH=/usr/libexec
IPSEC_SBIN_PATH=/usr/sbin
IPSEC_CONF_PATH=/etc/ipsec.d
IPSEC_CONF_FILE=ipsec.conf
IPSEC_DB_DUMP=/usr/share/strongswan/templates/database/sql/$IPSEC_DB_TYPE.sql
# Install Strongswan

sudo apt update -y
sudo apt install -y astyle cmake gcc ninja-build libssl-dev python3-pytest-xdist unzip xsltproc doxygen graphviz python3-yaml valgrind openssl libssl-dev curl mc nmap net-tools git wget libsqlite3-dev sqlite3  pkg-config build-essential libgmp-dev libcurl4-openssl-dev libsystemd-dev libgcrypt20-dev libip4tc-dev build-essential debhelper devscripts dh-make 

# Download and extract the package:
wget https://download.strongswan.org/strongswan-$IPSEC_VER.tar.bz2
tar xjf strongswan-$IPSEC_VER.tar.bz2

# Configure the package: --with-systemdsystemunitdir=/usr/lib/systemd/system
cd ~/strongswan-$IPSEC_VER
./configure --prefix=/usr --sysconfdir=/etc --libexecdir=/usr/libexec --with-systemdsystemunitdir=/usr/lib/systemd/system \
    --enable-sql \
    --enable-sqlite \
    --enable-attr-sql \
    --enable-sha1 \
    --enable-openssl \
    --enable-charon \
    --enable-random \
    --enable-eap-mschapv2 \
    --enable-curl \
    --enable-gcrypt \
    --enable-connmark \
    --enable-chapoly \
    --enable-stroke \
    --enable-starter \
    --enable-pkcs11 \
    --disable-tpm \
    --enable-test-vectors \
    --enable-rdrand \
    --enable-socket-default 

make
sudo make install

# Configure IPSEC secrets:
sudo -s
echo ': PSK "f483747f337433737dd37h3dh37h73dHHay373727373"' > /etc/ipsec.secrets
chmod 600 /etc/ipsec.secrets


# Configure IPSEC DB:
IPSEC_DB_FILE=/usr/lib/ipsec/ipsec.db
#sudo sqlite3 /usr/lib/ipsec/ipsec.db < /usr/share/strongswan/templates/database/sql/sqlite.sql
sudo chown root:root $IPSEC_DB_FILE
sudo chmod 600 $IPSEC_DB_FILE



#sudo sqlite3 /usr/local/lib/ipsec/ipsec.db < $IPSEC_DB_DUMP

#sudo ipsec pool add dhcp-pool 172.16.16.0/24
sudo sqlite3 $IPSEC_DB_FILE "INSERT INTO pools (name, start, end, timeout) VALUES ('dhcp-pool', x'AC101000', x'AC1010FF', 3600);"


#sudo ipsec lease add dhcp-pool client-52-54-00-c2-14-38
#sudo ipsec lease add dhcp-pool client-52-54-00-f3-76-2d
sudo sqlite3 /usr/lib/ipsec/ipsec.db """INSERT INTO leases (pool, identity, address) VALUES ('dhcp-pool', 'client-52-54-00-c2-14-38', '172.16.16.20');"""
sudo sqlite3 /usr/lib/ipsec/ipsec.db """INSERT INTO leases (pool, identity, address) VALUES ('dhcp-pool', 'client-52-54-00-f3-76-2d', '172.16.16.21');"""

# Test the database:
sudo sqlite3 /usr/lib/ipsec/ipsec.db ".tables"
sudo sqlite3 /usr/lib/ipsec/ipsec.db "select * from leases;"
sudo sqlite3 /usr/lib/ipsec/ipsec.db "select * from pools;"pool --add dhcp-pool --start 172.16.16.1 --end 172.16.16.254 --timeout 3600


# Create DEB package:
# Make a directory for the package:
sudo mkdir -p ~/ipsec-package/{DEBIAN,usr/local/bin,etc/ipsec}
sudo cd ~/ipsec-package

# Create the package:
cd ~/ipsec-package
nano ~/ipsec-package/etc/ipsec/ipsec.conf
nano ~/ipsec-package/etc/ipsec/ipsec.secrets

make DESTDIR=~/ipsec-package install


pool --add dhcp-pool --start 172.16.16.1 --end 172.16.16.254 --timeout 1
lease --add dhcp-pool --identity client-52-54-00-c2-14-38 --address 172.16.16.10
lease --add dhcp-pool --identity client-52-54-00-f3-76-2d --address 172.16.16.20



"root" with the following password: pdMPYTMTsrkipx