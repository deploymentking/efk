#!/usr/bin/env bash

directory=$(cd `dirname $0` && pwd)
source ${directory}/helpers/common.sh

restartContainer $1 $2
