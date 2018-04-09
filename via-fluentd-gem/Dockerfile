ARG VERSION_CENTOS=7
FROM centos:${VERSION_CENTOS}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Centos instance to test source of log data installed and configured manually"
LABEL Version="0.1"

RUN buildDeps="sudo make curl gnupg net-tools git-core zlib zlib-devel gcc-c++ glibc-devel \
    patch readline readline-devel libyaml-devel libxml2-devel libxslt-devel libffi-devel \
    openssl-devel bzip2 autoconf automake libtool bison sqlite-devel java-1.8.0-openjdk" \
    && yum -y update \
    && yum -y install $buildDeps \
    && yum clean all \
    && rm -rf /var/cache/yum

# Install rbenv
RUN git clone git://github.com/rbenv/rbenv.git /usr/local/rbenv \
    &&  git clone git://github.com/rbenv/ruby-build.git /usr/local/rbenv/plugins/ruby-build \
    &&  /usr/local/rbenv/plugins/ruby-build/install.sh

ENV PATH /usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv

# Setup rbenv
RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh \
    && echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /etc/profile.d/rbenv.sh \
    && echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh \
    && echo 'export RBENV_ROOT=/usr/local/rbenv' >> /root/.bashrc \
    && echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /root/.bashrc \
    && echo 'eval "$(rbenv init -)"' >> /root/.bashrc

ENV PATH /usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH

# TODO: Use this article to convert this into a multi-stage Dockerfile
# https://medium.com/kokster/fun-with-multi-stage-dockerfiles-7da7f11403d2
ARG VERSION_RUBY
ENV RBENV_VERSION ${VERSION_RUBY}

# Install ruby and gems
RUN eval "$(rbenv init -)"; rbenv install $RBENV_VERSION \
    && eval "$(rbenv init -)"; rbenv global $RBENV_VERSION \
    && eval "$(rbenv init -)"; gem update --system --no-document  \
    && eval "$(rbenv init -)"; gem install bundler --force --no-document \
    && eval "$(rbenv init -)"; gem install fluentd --no-document \
    && eval "$(rbenv init -)"; rbenv rehash $RBENV_VERSION \
    && mkdir -p /etc/fluent/certs /var/log/fluentd-gem/ \
    && rm -rf /tmp/*

COPY ./bin /bin
RUN chmod 755 /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
