FROM centos:centos7
MAINTAINER Neogeo Technologies http://www.neogeo-online.net

RUN yum -y update; yum clean all
RUN yum -y -q reinstall glibc-common; yum clean all
RUN yum -y install epel-release; yum clean all

# CouchDB dependencies
RUN yum -y install \
	autoconf \
	autoconf-archive \
	automake \
	crudini \
	curl-devel \
	gcc \
	gcc-c++ \
	glibc-devel \
	erlang-asn1 \
	erlang-erts \
	erlang-eunit \
	erlang-os_mon \
	erlang-xmerl \
	help2man \
	js-devel \
	libicu-devel \
	libtool \
	make \
	openssl-devel \
	perl-Test-Harness \
	pwgen \
    wget \
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


RUN yum -y install \
	crudini \
	; yum clean all


ENV DATADIR /usr/local/var/lib/couchdb
ENV SUPERUSER neogeo
# ENV SUPERPASS neogeo

# Add scripts
ADD scripts /scripts
RUN chmod +x /scripts/*.sh

CMD ["/scripts/run.sh"]

VOLUME ["${DATADIR}", "/usr/local/var/log/couchdb"]
EXPOSE 5984