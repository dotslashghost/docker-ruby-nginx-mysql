FROM ruby:2.2.2

RUN apt-get update

RUN apt-get install -y sudo
RUN useradd deploy -g root
RUN mkdir -p /home/deploy

RUN apt-get install -y vim
RUN apt-get install -y build-essential
RUN apt-get install -y nginx
RUN sudo apt-get -y install python-pip python-dev build-essential
RUN pip install unicornherder

# Supervisor
RUN apt-get install -y supervisor

# Instalação do mysql
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y mysql-server-5.5 libmysqlclient-dev

ADD my.cnf /etc/mysql/conf.d/my.cnf
RUN chmod 644 /etc/mysql/conf.d/my.cnf

ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

VOLUME ["/var/lib/mysql"]

EXPOSE 3306

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY Gemfile /usr/src/app
ONBUILD COPY Gemfile.lock /usr/src/app
ONBUILD RUN bundle install

ONBUILD COPY . /usr/src/app




