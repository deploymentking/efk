# Log Aggregation using Elasticsearch, Fluentd and Kibana

[![Build Status](https://travis-ci.org/deploymentking/efk.svg?branch=master)](https://travis-ci.org/deploymentking/efk)
[![Coverage Status](https://coveralls.io/repos/github/deploymentking/efk/badge.svg?branch=master)](https://coveralls.io/github/deploymentking/efk?branch=master)
[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=103)](https://opensource.org/licenses/mit-license.php)

This project allows for the quick deployment of a fully functioning EFK Stack.
- (E)lasticsearch
- (F)luentD
- (K)ibana

The intended use is as a local development environment to try out Fluentd configuration before deployment to an environment.
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
- [Log Sources](#log-sources)
  * [Logging via driver](#logging-via-driver)
    + [Launch Command](#launch-command)
  * [Logging via td-agent](#logging-via-td-agent)
    + [Launch Command](#launch-command-1)
    + [Accessing the Fluentd UI](#accessing-the-fluentd-ui)
    + [Changing the JAR log output type](#changing-the-jar-log-output-type)
    + [Changing the td-agent configuration file](#changing-the-td-agent-configuration-file)
    + [Changing the contents of a td-agent conf file](#changing-the-contents-of-a-td-agent-conf-file)
    + [Adding a new environment variable for use in the container](#adding-a-new-environment-variable-for-use-in-the-container)
  * [Logging via fluent-bit](#logging-via-fluent-bit)
    + [Launch Command](#launch-command-2)
  * [Encrypted logging with TLS](#encrypted-logging-with-tls)
- [Getting started with Kibana](#getting-started-with-kibana)
  * [Define index pattern](#define-index-pattern)
  * [View logs](#view-logs)
- [Getting started with ElasticHQ](#getting-started-with-elastichq)
  * [Launch Command](#launch-command-3)
- [Useful Commands](#useful-commands)
  * [Docker status commands](#docker-status-commands)
  * [General minikube commands](#general-minikube-commands)
  * [Test internet connectivity in minikube](#test-internet-connectivity-in-minikube)
  * [Tail the logs of fluent-bit](#tail-the-logs-of-fluent-bit)
  * [Useful Elasticsearch commands](#useful-elasticsearch-commands)
- [Docker Clean Up](#docker-clean-up)
- [Testing](#testing)
- [Contributing](#contributing)
- [References](#references)
- [External Projects](#external-projects)
- [Useful Articles](#useful-articles)

<!-- tocstop -->

## Requirements
All these instructions are for macOS only.

### Pre-requisites
Install
- [Homebrew](https://docs.brew.sh/Installation.html)
- [Homebrew Cask](https://caskroom.github.io/)

### Install supporting tools
```bash
brew install bash curl kubernetes-cli kubernetes-helm
brew cask install docker minikube virtualbox
```

## Quick & Easy Startup - OSS

Ensure the .env file has the setting `FLAVOUR_EFK` set to a value of `-oss`

```bash
docker-compose -p efk up
```

You will then be able to access the stack via the following:
- Elasticsearch @ [http://localhost:9200](http://localhost:9200)
- Kibana @ [http://localhost:5601](http://localhost:5601)

## Quick & Easy Startup - Default (with XPack Extensions)

Ensure the .env file has the setting `FLAVOUR_EFK` set to an empty string.

```bash
docker-compose -f docker-compose.yml -f nginx/docker-compose.yml -p efk up
```

You will then be able to access the stack via the following:
- Kibana @ [http://localhost:8080](http://localhost:8080)

When accessing via the NGINX container you do not need to supply the username and password credentials as it uses the 
`htpasswd.users` file which contains the default username and password of `kibana` and `kibana`. If you wish to use
different credentials then replace the text in the file using the following command 
`htpasswd -b ./nginx/config/htpasswd.users newuser newpassword`

:warning: You must use the `--build` flag on docker-compose when switching between `FLAVOUR_EFK` values e.g.
```bash
docker-compose -p efk up --build
```

## Log Sources

### Logging via driver
This is a simple log source that simply uses the log driver feature of Docker

```yaml
logging:
  driver: fluentd
  options:
    fluentd-address: localhost:24224
    tag: httpd.access
```

The docker image `httpd:alpine` is used to create a simple Apache web server. This will output the logs of the httpd 
process to STDOUT which gets picked up by the logging driver above.

#### Launch Command
```bash
docker-compose -f docker-compose.yml -f via-logging-driver/docker-compose.yml -p efk up
```

### Logging via td-agent
This source is based on an Ubuntu box with OpenJDK Java installed along with the td-agent. The executable is a JAR stored
in the executables folder that will log output controlled by log4j2 via slf4j. The JAR is controlled by the java-logger
project mentioned [here](#references). See the README of that project for further information.

#### Launch Command
```bash
docker-compose -f docker-compose.yml -f via-td-agent/docker-compose.yml -p efk up --build
```

#### Accessing the Fluentd UI
If the environment variable `FLUENTD_UI_ENABLED` is set to true in via-td-agent's `fluentd.properties` file then the UI
will be available once the stack is up and running otherwise the logs will be tailed to keep the container alive. The
following command will need to be used in order to start the Fluentd UI if it is not running.

```bash
docker exec -it agent fluentd-ui start
```

You will then be able to access the configuration of td-agent via the following:
- Fluentd UI @ [http://localhost:9292](http://localhost:9292)
- username: admin
- password: changeme

After the credentials above have been submitted, click the "Setup td-agent" button and then click the "Create" button.
The dashboard should be displayed. From here it is fairly obvious what you can change by navigating around the UI.

#### Changing the JAR log output type
In order to change the kind of logging output from the JAR, e.g. from single line logs to multi-line logs, the environment
variable `LOGGER_ENTRY_POINT` needs to be set. This can be achieved via the .env file found in the root of the project.
Simply uncomment the desired class.

#### Changing the td-agent configuration file
To try out different configuration options simply change the `FLUENTD_CONF` setting in the `via-td-agent/docker-compose.yml`
environment section to one of the files that are listed in `via-td-agent/config` and then rebuild the stack.

```bash
# ctrl+c to stop the stack (if not running in detached mode)
docker-compose -f docker-compose.yml -f via-td-agent/docker-compose.yml -p efk down
docker image ls --quiet --filter 'reference=efk_agent:*' | xargs docker rmi -f
docker-compose -f docker-compose.yml -f via-td-agent/docker-compose.yml -p efk up --build
```

#### Changing the contents of a td-agent conf file
In order to test changes made to a config file that is already configured to be used by the td-agent service simply make
the changes in the file on the host machine and then restart the td-agent service. The file is linked to the container
via the volume mount so the changes are immediately available to the container.

```bash
docker exec -it agent /bin/bash
service td-agent restart
```

#### Adding a new environment variable for use in the container
In order to make a new environment variable available to the td-agent process in the container it is necessary to add
the variable to a number of files to make sure it gets propagated successfully. The files to update are:

| File | Description |
| --- | --- |
| .env | Contains a list of all the environment variables that can be passed to the container |
| via-td-agent/docker-compose.yml | This passes a sub-set of the environment variables to the docker container |
| via-td-agent/executables/entrypoint.sh | This takes a sub-set of the environment variables within the container and makes them available to the td-agent service via /etc/default/td-agent |
| via-td-agent/config/td-agent-*.conf | The configuration files can make use of any variables defined in /etc/default/td-agent |

If you run the command below within this repo you will see an example of which files need to be changed and how.
```bash
git diff 66af1ad..857f181
```

### Logging via fluent-bit
The following command will launch a kubernetes cluster into minikube and ensure there is a fluent-bit daemon set installed.
In addition to that there is an apache image that is launched to test the fluent-bit setup will forward logs to the docker
composition setup prior to running this script.

#### Launch Command
```bash
cd via-fluent-bit && ./start-k8s.sh
```

You will then be able to access the apache instance via the following:
```bash
open "http://$(minikube ip):30080"
```

### Encrypted logging with TLS
Use the following command to create some certificates to be used for testing purposes
```bash
openssl req -new -x509 -sha256 -days 1095 -newkey rsa:2048 -keyout fluentd.key -out fluentd.crt

# Country Name (2 letter code) []:GB
# State or Province Name (full name) []:England
# Locality Name (eg, city) []:Frome
# Organization Name (eg, company) []:Think Stack Limited
# Organizational Unit Name (eg, section) []:Think Stack Limited Certificate Authority
# Common Name (eg, fully qualified host name) []:fluentd
# Email Address []:mail@thinkstack.io
```

```bash
echo -e '\x93\xa9debug.tls\xceZr\xbc1\x81\xa3foo\xa3bar' | openssl s_client -connect localhost:24224
```

## Getting started with Kibana
Once the stack has launched it should be possible to access kibana via [http://localhost:5601](http://localhost:5601).
It is not possible to instantly see the log output, first it is necessary to setup an index pattern. Kibana uses index
patterns to retrieve data from Elasticsearch indices for things like visualizations.

### Define index pattern
- Click this [link](http://localhost:5601/app/kibana#/management/kibana/index?_g=()) to navigate to the "Create index pattern" page
- Step 1 of 2: Define index pattern: type `fluentd*` into the "Index pattern" text box
- Click the "Next step" button
- Step 2 of 2: Configure settings: select `@timestamp` in the "Time Filter field name" drop-down list box
- Click the "Create index pattern" button

### View logs
- Click this [link](http://localhost:5601/app/kibana#/discover?_g=()) to navigate to the Discover page
- Click the "Auto-refresh" button at the top right of the page
- Select `5 seconds` from the drop-down panel that immediately appears
- Select the fields you wish to summarize in the table next to the left hand menu by hovering over the field name and
clicking the contextual "add" button. Select at least the "log" and "message" fields
- The selected fields should move from the "Available Fields" section to the "Selected Fields" section
- If using the logging driver you can trigger new logs to appear by clicking this [link](http://localhost) and refreshing
the page a few times

## Getting started with ElasticHQ
This application is used to perform analysis of metrics in the elasticsearch cluster. When the application UI loads, the
address of the elasticsearch cluster needs to be added in order to view the metric. The default value is localhost:9200.
This should be changed to `elasticsearch:9200` because the connection context is between running docker containers in the
`efk` network.

### Launch Command
```bash
docker-compose -f docker-compose.yml -f via-td-agent/docker-compose.yml -f elastichq/docker-compose.yml -p efk up --build
```

You will then be able to access the configuration of td-agent via the following:
- Fluentd UI @ [http://localhost:5000](http://localhost:5000)

## Useful Commands

### Docker status commands
```bash
watch 'docker ps -a --format "table {{.ID}}\t{{.Status}}\t{{.Names}}\t{{.Ports}}"'
```
### General minikube commands
```bash
kubectl cluster-info
kubectl cluster-info dump
kubectl config view
```

### Test internet connectivity in minikube
```bash
minikube ssh
# Commands to run during the SSH connection to the minikube VM
cat /etc/resolv.conf | egrep -v '^#'
ip route
ping -c 4 google.com
```

### Tail the logs of fluent-bit
```bash
kubectl logs -f --namespace=logging $(kubectl get pods --namespace=logging -l k8s-app=fluent-bit-logging -o name) -c fluent-bit
```

### Useful Elasticsearch commands
```bash
curl -X GET http://localhost:9200/_cat/indices?v
curl -X GET http://localhost:9200/_cluster/health?pretty=true
```

## Docker Clean Up
When running multiple stack updates or rebuilding stacks it is easy to build up a collection of dangling containers,
images and volumes that can be purged from your system. I use the following to perform a cleanup of my Docker environment.

```bash
# Delete all exited containers and their associated volume
docker ps --quiet --filter status=exited | xargs docker rm -v
# Delete all images, containers, volumes, and networks — that aren't associated with a container
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

## Testing

See [TESTING.md](https://github.com/deploymentking/efk/blob/master/TESTING.md).

## Contributing

Please do not hesitate to [open an issue](https://github.com/deploymentking/efk/issues/new) with any
questions or problems.

See [CONTRIBUTING.md](https://github.com/deploymentking/efk/blob/master/CONTRIBUTING.md).

## References
- [Install Elasticsearch with Docker](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html)
- [EFK Docker Images](https://www.docker.elastic.co/)
- [Fluentd Quickstart](https://docs.fluentd.org/v1.0/articles/quickstart)
- [Fluent Bit](http://fluentbit.io/documentation/0.12/)
- [Log4J2 Pattern Layout](https://logging.apache.org/log4j/log4j-2.1/manual/layouts.html#PatternLayout)
- [ElasticHQ](http://www.elastichq.org/)
- [log4j2 Appenders](https://logging.apache.org/log4j/2.x/manual/appenders.html)
- [log4j2 Configuration](http://logging.apache.org/log4j/2.x/manual/configuration.html)

## External Projects
- [Fluentd UI](https://github.com/fluent/fluentd-ui)
- [Fluent Bit in Kubernetes](https://github.com/fluent/fluent-bit-kubernetes-logging/)
- [java-logger](https://github.com/deploymentking/java-logger)
- [ElasticHQ](https://github.com/ElasticHQ/elasticsearch-HQ)
- [Dockerspec](https://github.com/zuazo/dockerspec)
- [docker-elk](https://github.com/deviantony/docker-elk)

## Useful Articles
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [How to remove docker images containers and volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)
- [How To Centralize Your Docker Logs with Fluentd and ElasticSearch on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-centralize-your-docker-logs-with-fluentd-and-elasticsearch-on-ubuntu-16-04)
- [Free Alternative to Splunk Using Fluentd](https://docs.fluentd.org/v1.0/articles/free-alternative-to-splunk-by-fluentd)
- [Elasticsearch monitoring and management plugins](https://blog.codecentric.de/en/2014/03/elasticsearch-monitoring-and-management-plugins/)
- [Add entries to pod hosts file with host aliases](https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/)
- [Exploring fluentd via EFK Stack for Docker Logging](http://kelonsoftware.com/fluentd-docker-logging/)
- [Logging Kubernetes Pods using Fluentd and Elasticsearch](http://blog.raintown.org/2014/11/logging-kubernetes-pods-using-fluentd.html)
- [Sharing a local registry with minikube](https://blog.hasura.io/sharing-a-local-registry-for-minikube-37c7240d0615)
- [Don’t be terrified of building native extensions](http://patshaughnessy.net/2011/10/31/dont-be-terrified-of-building-native-extensions)
- [Parse Syslog Messages Robustly](https://www.fluentd.org/guides/recipes/parse-syslog)
- [Docker Logging via EFK Stack with Docker Compose](https://docs.fluentd.org/v0.12/articles/docker-logging-efk-compose)
- [Fluent Bit on Kubernetes](http://fluentbit.io/documentation/0.12/installation/kubernetes.html)
