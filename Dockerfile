FROM ubuntu:xenial

MAINTAINER fredcamps

ENV PYTHON_VER 3.4.5

RUN apt-get update && apt-get upgrade -y -q \
  && apt-get install -y -q --no-install-recommends \
  autoconf \
  build-essential \
  locales \
  libssl-dev \
  libbz2-dev \
  libsasl2-dev \
  libmemcached-dev \
  ca-certificates \
  supervisor \
  libpq-dev \
  curl \
  libmysqlclient-dev \
  libmongo-client-dev \
  openssh-client \
  software-properties-common \
  libsqlite3-dev \
  libncurses5-dev \
  libxml2-dev \
  libxslt1-dev \
  procps \
  pkg-config \
  libcurl4-gnutls-dev \
  libpcre3-dev \
  cron \
  phantomjs \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL C

RUN curl -O https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz \
  && tar -zxf Python-${PYTHON_VER}.tgz && cd Python-${PYTHON_VER} \
  && ./configure --prefix=/opt/python && make && make install \
  && cd .. && rm -rf Python-${PYTHON_VER}.tgz && mv Python-${PYTHON_VER} /opt/ \
  && v=$(echo $PYTHON_VER | cut -d '.' -f 1 ) \
  && ln -sf $(which python) /opt/python/bin/python \
  && /opt/python/bin/pip${v} install --upgrade pip virtualenvwrapper setuptools uwsgi \
  && mkdir -p /var/log/uwsgi

RUN adduser --disabled-password --gecos '' python

ADD ./supervisord.conf /etc/supervisor/supervisord.conf
ADD ./virtualenv /home/python/.virtualenv
ADD ./bashrc /home/python/.bashrc

RUN chown python:python /home/python/.virtualenv \
    && chown python:python /home/python/.bashrc

RUN chown -R python:python /var/log/uwsgi

EXPOSE 9001

CMD /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
