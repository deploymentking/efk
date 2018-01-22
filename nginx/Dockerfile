FROM nginx
MAINTAINER Lee Myring mail@thinkstack.io
LABEL Description="Log aggregator reverse proxy docker image" Version="0.1"

COPY default.conf /etc/nginx/conf.d/default.conf
COPY htpasswd.users /etc/nginx/htpasswd.users
