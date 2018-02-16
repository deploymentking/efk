# Fluentd Log Aggregation

This Docker template allows for the quick deployment of a fully functioning EFK Stack along with an optional NGINX web server 
that will enable Basic authentication access control to kibana.

## Table of Contents

<!-- toc -->

- [Quick & Easy Startup - OSS](#quick--easy-startup---oss)
- [Quick & Easy Startup - Default (with XPack Extensions)](#quick--easy-startup---default-with-xpack-extensions)

<!-- tocstop -->

## Quick & Easy Startup - OSS

- Ensure the .env file has the setting `FLAVOUR_ELK` set to a value of `-oss`
- Run the following command `docker-compose -p efk up`

You will then be able to access the stack via the following:
- Elasticsearch @ [http://localhost:9200](http://localhost:9200)
- Kibana @ [http://localhost:5601](http://localhost:5601)

## Quick & Easy Startup - Default (with XPack Extensions)

- Ensure the .env file has the setting `FLAVOUR_ELK` set to an empty string
- Run the following command `docker-compose -f docker-compose.yml -f nginx/docker-compose.yml -p efk up`

You will then be able to access the stack via the following:
- Kibana @ [http://localhost:8080](http://localhost:8080)

When accessing via the NGINX container you do not need to supply the username and password credentials as it uses the 
`htpasswd.users` file which contains the default username and password of `elastic` and `changeme`. If you wish to use
different credentials then replace the text in the file using the following command `htpasswd -b ./nginx/config/htpasswd.users newuser newpassword`

:warning: You must use the `--build` flag on docker-compose when switching between `FLAVOUR_ELK` values e.g.
`docker-compose -p efk up --build`

## Logging to EFK via Docker logging driver

- Run the following command `docker-compose -f docker-compose.yml -f via-logging-driver/docker-compose.yml -p efk up`

## Logging to EFK via td-agent

- Run the following command `docker-compose -f docker-compose.yml -f via-td-agent/docker-compose.yml -p efk up`
