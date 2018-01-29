# Fluentd Log Aggregation

This Docker template allows for the quick deployment of a fully functioning EFK Stack along with an nginx web server that will enable Basic authentication access control to kibana.

## Table of Contents

<!-- toc -->

- [Quick & Easy Startup](#quick--easy-startup)

<!-- tocstop -->

## Quick & Easy Startup

`docker-compose -f docker-compose.yml -f logsource/docker-compose.yml -p efk up` :smile:

### OSS Setup
You can then access Kibana on [http://localhost:5601](http://localhost:5601)

### Default Setup
You can then access Kibana on [http://localhost:8080](http://localhost:8080) and login with the default username & password.
