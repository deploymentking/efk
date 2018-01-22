FROM nginx
MAINTAINER DORU Mihai doru.mihai@haufe-lexware.com
LABEL Description="Log aggregator reverse proxy docker image" Version="0.1"

COPY default.conf /etc/nginx/conf.d/default.conf
COPY htpasswd.users /etc/nginx/htpasswd.users
