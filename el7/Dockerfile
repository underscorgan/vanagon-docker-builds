FROM centos:7 as build
ARG ruby_major_ver=2.6
ARG ruby_patch_ver=2
ENV ruby_ver="$ruby_major_ver.$ruby_patch_ver"

RUN yum -y groupinstall "Development Tools" && \
    yum -y install wget openssl-devel

RUN wget "http://cache.ruby-lang.org/pub/ruby/$ruby_major_ver/ruby-$ruby_ver.tar.gz" && \
    tar xf "ruby-$ruby_ver.tar.gz"

WORKDIR /ruby-$ruby_ver
RUN ./configure && \
    make && \
    make install

FROM centos:7
ENV VANAGON_USE_MIRRORS=n
ENV VANAGON_PROJECT=''
ENV REPO_URL=''
ENV REPO_REF=master

COPY --from=build /usr/local/bin /usr/local/bin
COPY --from=build /usr/local/include /usr/local/include
COPY --from=build /usr/local/lib /usr/local/lib
COPY --from=build /usr/local/share /usr/local/share

RUN mkdir -p /runtime && mkdir -p /artifacts
RUN yum clean all && yum install -y wget
RUN wget http://pl-build-tools.delivery.puppetlabs.net/yum/pl-build-tools-release-el-7.noarch.rpm && \
    rpm -i pl-build-tools-release-el-7.noarch.rpm && \
    yum clean all && \
    yum install -y git pl-cmake pl-gcc && \
    yum remove -y pl-build-tools-release && \
    yum clean all && \
    gem install vanagon

# pre-load some runtimes for ease of use
WORKDIR /runtime
RUN wget "http://builds.delivery.puppetlabs.net/puppet-runtime/201904090/artifacts/bolt-runtime-201904090.el-7-x86_64.tar.gz" && \
    wget "http://builds.delivery.puppetlabs.net/puppet-runtime/201904090/artifacts/bolt-runtime-201904090.el-7-x86_64.settings.yaml" && \
    wget "http://builds.delivery.puppetlabs.net/puppet-runtime/201903260/artifacts/bolt-runtime-201903260.el-7-x86_64.tar.gz" && \
    wget "http://builds.delivery.puppetlabs.net/puppet-runtime/201903260/artifacts/bolt-runtime-201903260.el-7-x86_64.settings.yaml"

WORKDIR /
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

COPY Dockerfile /
