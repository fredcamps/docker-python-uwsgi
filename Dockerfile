FROM debian:jessie

ENV PYTHON_VER 3.4.5

RUN apt-get update && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends -y \
  build-essential \
  ca-certificates \
  git \
  supervisor \
  libpq-dev \
  curl \
  libmysqlclient-dev \
  libmongo-client-dev \
  openssh-client \
  uwsgi \
  nginx \
  sqlite3 \
  cron \
  telnet \
  wget

RUN wget https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz
RUN tar -zxf Python-${PYTHON_VER}.tgz && cd Python-${PYTHON_VER} \
  && ./configure --prefix=/opt/python && make && make install \
  && cd .. && rm -rf Python-* && cp /opt/python/bin/* /usr/bin

EXPOSE 80 8000 443

ADD ./setup.sh /setup.sh
RUN /setup.sh && rm -rf /setup.sh

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
