FROM centos:centos7
MAINTAINER Neogeo Technologies http://www.neogeo-online.net

RUN yum -y update; yum clean all
RUN yum -y -q reinstall glibc-common; yum clean all
RUN yum -y install epel-release; yum clean all


RUN yum -y install \
	crudini \
	pwgen \
	wget \
	; yum clean all

# Dev tools
RUN yum -y groupinstall "Development Tools"

# CouchDB dependencies
RUN yum -y install \
	libicu-devel \
	curl-devel \
	ncurses-devel \
	libtool \
	libxslt \
	fop \
	java-1.6.0-openjdk \
	java-1.6.0-openjdk-devel \
	unixODBC \
	unixODBC-devel \
	openssl-devel \
	; yum clean all

# Install Erlang with SSL support from source
RUN cd /tmp && \
	wget http://www.erlang.org/download/otp_src_R16B02.tar.gz && \
    tar -xzvf otp_src_R16B02.tar.gz && \
    cd otp_src_R16B02 && \
    CFLAGS="-DOPENSSL_NO_EC=1" ./configure && \
    make && \
    make install

# Install SpiderMonkey JS from source
RUN cd /tmp && \
	wget http://ftp.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz && \
    tar -xzvf js185-1.0.0.tar.gz && \
    cd js-1.8.5/js/src/ && \
    ./configure && \
    make && \
    make install

# Install CouchDB from source
RUN cd /tmp && \
	wget http://mirror.tcpdiag.net/apache/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz && \
    tar -xzvf apache-couchdb-1.6.1.tar.gz && \
    cd apache-couchdb-1.6.1 && \
    ./configure && \
    make && \
    make install

   
ENV DATADIR /usr/local/var/lib/couchdb
ENV SUPERUSER neogeo
# ENV SUPERPASS neogeo

# Add scripts
ADD scripts /scripts
RUN chmod +x /scripts/*.sh

CMD ["/scripts/run.sh"]

VOLUME ["${DATADIR}", "/usr/local/var/log/couchdb", "/usr/local/etc/couchdb"]
EXPOSE 5984