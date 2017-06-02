FROM debian:jessie-backports

# Install debian packages used by the container
# Configure apache to run the lava server
# Log the hostname used during install for the slave name
RUN \
 echo 'lava-server   lava-server/instance-name string lava-docker-instance' | debconf-set-selections \
 && echo 'lava-server   lava-server/db-server string lavadb' | debconf-set-selections \
 && echo 'locales locales/locales_to_be_generated multiselect C.UTF-8 UTF-8, en_US.UTF-8 UTF-8 ' | debconf-set-selections \
 && echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections \
 && apt-get clean && \
 apt-get update && \
 apt-get install -y wget

# Add linaro staging repo
RUN cd /tmp && \
 wget http://images.validation.linaro.org/production-repo/production-repo.key.asc &&  \
 apt-key add production-repo.key.asc  && \
 echo "deb http://images.validation.linaro.org/production-repo sid main"  >>/etc/apt/sources.list.d/linaro.list


RUN \
 DEBIAN_FRONTEND=noninteractive apt-get install -y \
 cu \
 expect \
 locales \
 openssh-server \
 screen \
 sudo \
 gunicorn \
 vim
RUN  \
 DEBIAN_FRONTEND=noninteractive apt-get install -y -t jessie-backports \
 python-django \
 python-django-tables2
RUN \
 DEBIAN_FRONTEND=noninteractive apt-get install -y \
 qemu-system
RUN \
 DEBIAN_FRONTEND=noninteractive apt-get install -y \
 mdadm mtools nfs-common \
 nfs-kernel-server ntfs-3g \
 ntp openbsd-inetd
RUN \
 DEBIAN_FRONTEND=noninteractive apt-get install -y \
 python-xdg python-yaml python-zmq \
 python-zope.interface reiserfsprogs \
 rsync scrub ser2net sshfs supermin \
 syslinux syslinux-common telnet \
 tftpd-hpa u-boot-tools unzip \
 xfsprogs xkb-data xz-utils zerofree
RUN \
 DEBIAN_FRONTEND=noninteractive apt-get install -y \
 apache2 binutils \
 bridge-utils busybox bzip2 \
 console-setup cryptsetup docutils-common

RUN \
 DEBIAN_FRONTEND=noninteractive apt-get -t jessie-backports install -y \
 python-voluptuous \
 python-pyudev

RUN \
 DEBIAN_FRONTEND=noninteractive apt-get install -y \
 gdebi
RUN \
 DEBIAN_FRONTEND=noninteractive apt-get install -y \
 curl \
 python-sphinx-bootstrap-theme \
 node-uglify \
 docbook-xsl \
 xsltproc \
 python-mock

RUN \
 DEBIAN_FRONTEND=noninteractive apt-get install -y \
 python-pip
