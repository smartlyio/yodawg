FROM ubuntu:xenial

RUN apt-get update && apt-get install --assume-yes --no-install-recommends lxc
RUN apt-get update && apt-get install --assume-yes --no-install-recommends wget

RUN set -ex && wget --no-check-certificate https://releases.hashicorp.com/vagrant/2.0.3/vagrant_2.0.3_x86_64.deb -O /tmp/vagrant_2.0.3_x86_64.deb
RUN set -ex && dpkg -i /tmp/vagrant_2.0.3_x86_64.deb && apt-get install -f

RUN vagrant plugin install vagrant-lxc

RUN apt-get update && apt-get install --assume-yes --no-install-recommends git
RUN apt-get update && apt-get install --assume-yes --no-install-recommends ca-certificates

RUN git clone https://github.com/obnoxxx/vagrant-lxc-base-boxes.git /tmp/vagrant-lxc-base-boxes

RUN apt-get update && apt-get install --assume-yes --no-install-recommends build-essential

RUN apt-get update && apt-get install --assume-yes --no-install-recommends sudo

RUN apt-get update && apt-get install --assume-yes --no-install-recommends lxctl lxc-templates


ENV ADDPACKAGES "vim locales-all"

WORKDIR /tmp/vagrant-lxc-base-boxes

RUN sed -i 's/#!\/bin\/bash/#!\/bin\/bash -x/' mk-debian.sh common/download.sh common/package.sh debian/vagrant-lxc-fixes.sh debian/install-extras.sh common/utils.sh

RUN apt-get update && apt-get install --assume-yes --no-install-recommends debootstrap
RUN apt-get update && apt-get install --assume-yes --no-install-recommends iproute2

ENV LANG "en_US.UTF-8"

RUN sed -i 's/lxc-attach -n/lxc-attach --elevated-privileges -n/' common/utils.sh

COPY ./build-lxc-vagrant-box.sh /tmp/
CMD [ "/tmp/build-lxc-vagrant-box.sh", "xenial" ]
