# Fluentd Log Aggregation

This project allows for the quick deployment of a fully functioning EFK Stack.
- (E)lasticsearch
- (F)luentD
- (K)ibana

The intended use is as a local development environment to try out FluentD configuration before deployment to an environment.
I have also included an optional NGINX web server that enables Basic authentication access control to kibana (if using
the XPack extension). In addition to this, there are a collection of "sources" that feed the EFK stack. For example the
folder `via-td-agent` contains Docker files that can launch and configure an Ubuntu box that will install the td-agent
and run a Java JAR from which we can control the type of logging to be sent to EFK

## Table of Contents

<!-- toc -->

- [Requirements](#requirements)
  * [Pre-requisites](#pre-requisites)
  * [Install supporting tools](#install-supporting-tools)
- [Quick & Easy Startup - OSS](#quick--easy-startup---oss)
- [Quick & Easy Startup - Default (with XPack Extensions)](#quick--easy-startup---default-with-xpack-extensions)
- [Docker Clean Up](#docker-clean-up)
- [Log Sources](#log-sources)
  * [Logging via Docker logging driver](#logging-via-docker-logging-driver)
    + [Launch Command](#launch-command)
  * [Logging to EFK via td-agent](#logging-to-efk-via-td-agent)

<!-- tocstop -->

## Requirements
All these instructions are for macOS only.

### Pre-requisites
Install
- [Homebrew](https://docs.brew.sh/Installation.html)
- [Homebrew Cask](https://caskroom.github.io/)

### Install supporting tools
```bash
brew cask install docker
```

## Quick & Easy Startup - OSS

Ensure the .env file has the setting `FLAVOUR_ELK` set to a value of `-oss`

```bash
docker-compose -p efk up
```

You will then be able to access the stack via the following:
- Elasticsearch @ [http://localhost:9200](http://localhost:9200)
- Kibana @ [http://localhost:5601](http://localhost:5601)

## Quick & Easy Startup - Default (with XPack Extensions)

Ensure the .env file has the setting `FLAVOUR_ELK` set to an empty string.

```bash
docker-compose -f docker-compose.yml -f nginx/docker-compose.yml -p efk up
```

You will then be able to access the stack via the following:
- Kibana @ [http://localhost:8080](http://localhost:8080)

When accessing via the NGINX container you do not need to supply the username and password credentials as it uses the 
`htpasswd.users` file which contains the default username and password of `elastic` and `changeme`. If you wish to use
different credentials then replace the text in the file using the following command 
`htpasswd -b ./nginx/config/htpasswd.users newuser newpassword`

:warning: You must use the `--build` flag on docker-compose when switching between `FLAVOUR_ELK` values e.g.
```bash
docker-compose -p efk up --build
```

## Docker Clean Up
When running multiple stack updates or rebuilding stacks it is easy to build up a collection of dangling containers,
images and volumes that can be purged from your system. I use the following to perform a cleanup of my Docker environment.

```bash
# Delete all exited containers and their associated volume
docker ps --quiet --filter status=exited | xargs docker rm -v
# Delete all images, containers, volumes, and networks — that are dangling (not associated with a container)
docker system prune --force --volumes
```

:warning: Quite destructive commands follow...
```bash
# Delete all containers
docker ps --quiet --all | xargs docker rm -f
# Delete forcefully all images that match the name passed into the filter e.g. efk_*
docker image ls --quiet --filter 'reference=efk_*:*' | xargs docker rmi -f
# Delete everything? EVERYTHING!
docker system prune --all
```

## Log Sources

### Logging via Docker logging driver
This is a simple log source that simply uses the log driver feature of Docker

```yaml
logging:
  driver: fluentd
  options:
    fluentd-address: localhost:24224
    tag: httpd.access
```

The docker image `httpd:alpine` is used to create a simple Apache web server

#### Launch Command
```bash
docker-compose -f docker-compose.yml -f via-logging-driver/docker-compose.yml -p efk up
```

### Logging to EFK via td-agent

- Run the following command `docker-compose -f docker-compose.yml -f via-td-agent/docker-compose.yml -p efk up`

The Docker container running the td-agent has a JAR installed from which logs are produced. To modify the JAR in order
to produce different output re-compile the [java-logger](https://github.com/DeploymentKing/java-logger) GitHub project.
See the README of that project for further information

## References
- [Docker Cleanup](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)
