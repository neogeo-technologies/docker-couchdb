# docker-couchdb
Simple CouchDB 1.6.1 server image (based on Centos 7)

CouchDB is installed from source in this image

Exposed port: 5984

## Volumes declared:
- $DATADIR: path to the data dir
- /usr/local/var/log/couchdb: couchdb log files dir
- /usr/local/etc/couchdb: couchdb ini files dir


## Environment variables
- DATADIR (default value: /usr/local/var/lib/couchdb): db data dir
- SUPERUSER (default value: neogeo): db superuser login
- SUPERUSER (default value: none): db superuser password. If this variable is not defined in your docker run command or in your docker-compose file, it will be generated randomly. To get its value, use docker logs or docker-compose logs.


## Credits
Written by Benjamin Chartier http://www.neogeo-online.net

Inspiration for the compilation process on Centos:
- http://www.tecmint.com/install-apache-couchdb-in-rhel-centos-debian-and-ubuntu/
- https://www.digitalocean.com/community/tutorials/how-to-install-couchdb-from-source-on-a-centos-6-x64-vps
- http://docs.couchdb.org/en/1.6.1/install/unix.html
- http://docs.basho.com/riak/latest/ops/building/installing/erlang/#Installing-on-RHEL-CentOS


## Using the image
see the docker-compose configuration file in the resource dir