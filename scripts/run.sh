#!/bin/bash

#enable job control in script
set -m

# Configure couchdb
sed -i -r 's/;port = 5984/port = 5984/' /usr/local/etc/couchdb/local.ini
sed -i -r 's/;bind_address = 127.0.0.1/bind_address = 0.0.0.0/' /usr/local/etc/couchdb/local.ini

if [ ! -f /usr/local/var/lib/couchdb/.couchdb_admin_created ]; then
	PASS=${SUPERPASS:-$(pwgen -s -1 16)}
	echo $PASS
	sed -i -r 's/;admin = mysecretpassword/'"$SUPERUSER"' = '"${PASS}"'/' /usr/local/etc/couchdb/local.ini
	tail -n 1 /usr/local/etc/couchdb/local.ini
fi
#[couchdb]
#sed -i -r 's/;database_dir = 127.0.0.1/bind_address = 0.0.0.0/' /usr/local/etc/couchdb/local.ini
#sed -i -r 's/;view_index_dir = 127.0.0.1/bind_address = 0.0.0.0/' /usr/local/etc/couchdb/local.ini

# adduser --no-create-home couchdb
# chown -R couchdb:couchdb /usr/local/var/lib/couchdb /usr/local/var/log/couchdb /usr/local/var/run/couchdb
# ln -sf /usr/local/etc/rc.d/couchdb /etc/init.d/couchdb

# Run CouchDB in background
/usr/local/bin/couchdb &

# identify the ini files used by CouchDB
# couchdb -c

# Create admin user
if [ ! -f /usr/local/var/lib/couchdb/.couchdb_admin_created ]; then

	# If the superuser password is not defnied in an environment variable
	# it is randomly generated

	echo "SUPERUSER: \"$SUPERUSER\""
	echo "SUPERPASS: \"$PASS\""
# 	echo "DATADIR: \"$DATADIR\""

	RET=7
	while [[ RET -ne 0 ]]; do
	    echo "=> Waiting for confirmation of CouchDB service startup"
	    sleep 5
	    curl -s http://127.0.0.1:5984 >/dev/null 2>&1
	    RET=$?
	done

	curl -s http://$SUPERUSER:$PASS@127.0.0.1:5984/_config/httpd/bind_address
	curl -s http://$SUPERUSER:$PASS@127.0.0.1:5984/_config/httpd/port

	touch /usr/local/var/lib/couchdb/.couchdb_admin_created

	echo "========================================================================"
	echo "You can now connect to this CouchDB server using:"
	echo "    curl http://$SUPERUSER:$PASS@<host>:<port>"
	echo "========================================================================"
fi

# Bring couchdb to foreground
fg