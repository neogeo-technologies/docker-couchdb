FROM centos:centos7
MAINTAINER Neogeo Technologies http://www.neogeo-online.net

RUN yum -y update; yum clean all
RUN yum -y -q reinstall glibc-common; yum clean all
RUN yum -y install epel-release; yum clean all

# CouchDB dependencies
RUN yum -y install \
	autoconf \
	crudini \
	curl-devel \
	fop \
	gcc \
	gcc-c++ \
	glibc-devel \
	java-1.8.0-openjdk-devel \
	libicu-devel \
	libtool \
	libxslt \
	make \
	ncurses-devel \
	openssl-devel \
	pwgen \
	unixODBC \
	unixODBC-devel \
	wget \
	zip \
	; yum clean all

# Install Erlang with SSL support from source
RUN cd /tmp && \
	wget -nv http://www.erlang.org/download/otp_src_R16B02.tar.gz && \
    tar -xzvf otp_src_R16B02.tar.gz && \
    cd otp_src_R16B02 && \
    CFLAGS="-DOPENSSL_NO_EC=1" ./configure && \
    make && \
    make install && \
	rm /tmp/otp_src_R16B02.tar.gz && \
	rm -rf /tmp/otp_src_R16B02

# Install SpiderMonkey JS from source
RUN cd /tmp && \
	wget -nv http://ftp.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz && \
    tar -xzvf js185-1.0.0.tar.gz && \
    cd js-1.8.5/js/src/ && \
    ./configure && \
    make && \
    make install && \
	rm /tmp/js185-1.0.0.tar.gz && \
	rm -rf /tmp/js-1.8.5

# Install CouchDB from source
RUN cd /tmp && \
	wget -nv http://mirror.tcpdiag.net/apache/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz && \
    tar -xzvf apache-couchdb-1.6.1.tar.gz && \
    cd apache-couchdb-1.6.1 && \
    ./configure && \
    make && \
    make install && \
	rm /tmp/apache-couchdb-1.6.1.tar.gz && \
	rm -rf /tmp/apache-couchdb-1.6.1

ENV DATADIR /usr/local/var/lib/couchdb
ENV SUPERUSER neogeo
# ENV SUPERPASS neogeo

# Add scripts
ADD scripts /scripts
RUN chmod +x /scripts/*.sh

CMD ["/scripts/run.sh"]

VOLUME ["${DATADIR}", "/usr/local/var/log/couchdb", "/usr/local/etc/couchdb"]
EXPOSE 5984