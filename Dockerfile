FROM debian:jessie

MAINTAINER fredcamps

ENV PYTHON_VER 3.4.5

RUN apt-get update && apt-get upgrade -y -q \
  && apt-get install -y -q --no-install-recommends -y \
  build-essential \
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
  uwsgi \
  uwsgi-plugin-python \
  uwsgi-plugin-python3 \
  libsqlite3-dev \
  cron \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN curl -O https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz \
  && tar -zxf Python-${PYTHON_VER}.tgz && cd Python-${PYTHON_VER} \
  && ./configure --prefix=/opt/python && make && make install \
  && cd .. && rm -rf Python-* && cp /opt/python/bin/* /usr/bin

RUN v=$(echo $PYTHON_VER | cut -d '.' -f 1 ) \
  && pip${v} install --upgrade pip virtualenvwrapper setuptools

RUN adduser --disabled-password --gecos '' python

ADD ./supervisord.conf /etc/supervisor/supervisord.conf
ADD ./virtualenv /home/python/.virtualenv
RUN chown python:python /home/python/.virtualenv \
  && su python -c "echo -e \"source /home/python/.virtualenv\" >> /home/python/.bashrc"

RUN chown -R python:python /var/log/uwsgi


EXPOSE 9001

CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]
