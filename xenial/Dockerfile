FROM ubuntu:16.04
ENV VANAGON_USE_MIRRORS=n
ENV VANAGON_PROJECT=''
ENV REPO_URL=''
ENV REPO_REF=master

RUN mkdir -p /runtime && mkdir -p /artifacts
RUN apt-get update && \
    apt-get install --no-install-recommends -y wget && \
    rm -rf /var/lib/apt/lists/*

RUN wget http://pl-build-tools.delivery.puppetlabs.net/debian/pl-build-tools-release-xenial.deb && \
    dpkg -i pl-build-tools-release-xenial.deb && \
    apt-get update && \
    apt-get install --no-install-recommends -y ruby ruby-dev gcc make zlib1g-dev git pl-cmake pl-gcc pl-gettext && \
    apt-get remove -y pl-build-tools-release && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    gem install --no-doc rspec:2.11.0 rake:10.1.0 mocha:0.10.5 bundler && \
    gem install vanagon

# pre-load some runtimes for ease of use
WORKDIR /runtime
# Included in p-a 6.4.4
RUN wget "http://builds.delivery.puppetlabs.net/puppet-runtime/201910040/artifacts/agent-runtime-6.4.x-201910040.ubuntu-16.04-amd64.tar.gz" && \
    wget "http://builds.delivery.puppetlabs.net/puppet-runtime/201910040/artifacts/agent-runtime-6.4.x-201910040.ubuntu-16.04-amd64.settings.yaml" && \
    wget "http://builds.delivery.puppetlabs.net/puppet-runtime/201910040/artifacts/agent-runtime-6.4.x-201910040.ubuntu-16.04-i386.tar.gz" && \
    wget "http://builds.delivery.puppetlabs.net/puppet-runtime/201910040/artifacts/agent-runtime-6.4.x-201910040.ubuntu-16.04-i386.settings.yaml"

WORKDIR /
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

COPY Dockerfile /
