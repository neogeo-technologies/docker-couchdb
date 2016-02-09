#!/bin/bash

#enable job control in script
set -m

# Configure couchdb
if [ ! -f /usr/local/var/lib/couchdb/.couchdb_admin_created ]; then

	DATAPATH=${DATADIR:-/usr/local/var/lib/couchdb}
	PASS=${SUPERPASS:-$(pwgen -s -1 16)}
	crudini --set /usr/local/etc/couchdb/local.ini httpd port 5984
	crudini --set /usr/local/etc/couchdb/local.ini httpd bind_address 0.0.0.0
	crudini --set /usr/local/etc/couchdb/local.ini couchdb database_dir $DATAPATH
	crudini --set /usr/local/etc/couchdb/local.ini couchdb view_index_dir $DATAPATH
	crudini --set /usr/local/etc/couchdb/local.ini admins $SUPERUSER $PASS
fi

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
 	echo "DATADIR: \"$DATAPATH\""

	RET=7
	while [[ RET -ne 0 ]]; do
	    echo "=> Waiting for confirmation of CouchDB service startup"
	    sleep 5
	    curl -s http://127.0.0.1:5984 >/dev/null 2>&1
	    RET=$?
	done

	# curl -s http://$SUPERUSER:$PASS@127.0.0.1:5984/_config/httpd/bind_address
	# curl -s http://$SUPERUSER:$PASS@127.0.0.1:5984/_config/httpd/port

	touch /usr/local/var/lib/couchdb/.couchdb_admin_created

	echo "========================================================================"
	echo "You can now connect to this CouchDB server using:"
	echo "    curl http://$SUPERUSER:$PASS@<host>:<port>"
	echo "========================================================================"
fi

# Bring couchdb to foreground
fg