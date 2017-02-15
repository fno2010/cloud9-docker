# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# ------------------------------------------------------------------------------
# Pull base image.
FROM kdelfour/supervisor-docker
MAINTAINER Kevin Delfour <kevin@delfour.eu>

ENV MININET_REPO https://github.com/mininet/mininet
ENV MININET_INSTALLER ./mininet/util/install.sh
ENV JAVA_HOME /opt/jdk/jdk1.8.0_101
ENV PATH /root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update --quiet \
`# ------------------------------------------------------------------------------` \
`# Install base` \
    && apt-get install \
        --yes \
        --no-install-recommends \
        --no-install-suggests \
        autoconf automake ca-certificates libtool net-tools openssh-client unzip \
        build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs tmux \
`# ------------------------------------------------------------------------------` \
`# Clone and install mininet` \
    && cd /tmp \
    && git clone -b 2.2.1 $MININET_REPO \
    && sed -e 's/sudo //g' \
        -e 's/~\//\//g' \
        -e 's/\(apt-get -y install\)/\1 --no-install-recommends --no-install-suggests/g' \
        -i $MININET_INSTALLER && touch /.bashrc \
    && chmod +x $MININET_INSTALLER \
    && $MININET_INSTALLER -nfv \
`# ------------------------------------------------------------------------------` \
`# Install Java and Maven` \
    && curl -LO -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-x64.tar.gz \
    && mkdir /opt/jdk \
    && tar -zxf jdk-8u101-linux-x64.tar.gz -C /opt/jdk \
    && update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_101/bin/java 100 \
    && update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_101/bin/javac 100 \
    && curl -LO http://mirror.cc.columbia.edu/pub/software/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz \
    && tar -zxf apache-maven-3.3.9-bin.tar.gz -C /opt \
    && ln -s /opt/apache-maven-3.3.9/bin/mvn /usr/bin/mvn \
    && mkdir -p /root/.m2 \
    && curl -L https://raw.githubusercontent.com/opendaylight/odlparent/master/settings.xml > /root/.m2/settings.xml \
    && curl -L -o m2.zip $(curl -s https://api.github.com/repos/snlab/m2-odl-summit/releases | grep browser_download_url | head -n 1 | cut -d "\"" -f 4) \
    && unzip m2.zip \
    && cp -rf .m2/* /root/.m2/ \
`# ------------------------------------------------------------------------------` \
`# Install Node.js` \
    && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get install -y nodejs \
`# Symbolic link for utility` \
    && mkdir -p /root/bin \
    && cd /root/bin \
    && npm i ssh2 scp2 optimist \
    && ln -s /cloud9/plugins/snlab.devopen.controller/deploy.js /root/bin/deploy \
`# ------------------------------------------------------------------------------` \
`# Install Cloud9` \
    && git clone https://github.com/fno2010/core.git -b devopen /cloud9 \
    && cd /cloud9 \
    && scripts/install-sdk.sh \
`# Tweak standlone.js conf` \
    && sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js \
`# Fix bug https://github.com/npm/npm/issues/9863` \
    && cd $(npm root -g)/npm \
    && npm install fs-extra \
    && sed -i -e s/graceful-fs/fs-extra/ -e s/fs\.rename/fs.move/ ./lib/utils/rename.js \
    && cd /cloud9 \
`# Install extra dependencies for cloud9` \
    && npm i body-parser express ssh2 sqlite3 request \
`# ------------------------------------------------------------------------------` \
`# Clean up APT when done` \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /cloud9

# Add supervisord conf
ADD conf/cloud9.conf /etc/supervisor/conf.d/

# ------------------------------------------------------------------------------
# Add volumes
RUN mkdir /workspace
VOLUME /workspace

# ------------------------------------------------------------------------------
# Create a start script to start OpenVSwitch
COPY docker-entry-point /docker-entry-point
RUN chmod 755 /docker-entry-point
COPY mininetSim /root/bin/mininetSim

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 80
EXPOSE 3000
EXPOSE 9001-9100

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
ENTRYPOINT ["/docker-entry-point"]
