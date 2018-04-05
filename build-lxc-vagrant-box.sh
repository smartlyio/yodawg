#!/bin/sh

set -e
set -x

/usr/lib/x86_64-linux-gnu/lxc/lxc-net start

cd /tmp/vagrant-lxc-base-boxes && make xenial
