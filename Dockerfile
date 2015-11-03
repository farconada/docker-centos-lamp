FROM centos:7
MAINTAINER "Fernando Arconada" <farconada@larioja.org>
ENV container docker
ADD ./runit-2.1.2-1.el7.centos.x86_64.rpm /tmp/runit-2.1.2-1.el7.centos.x86_64.rpm
RUN rpm -Uhv /tmp/runit-2.1.2-1.el7.centos.x86_64.rpm
RUN rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
RUN yum -y update; yum clean all;
RUN yum -y install epel-release
RUN yum -y install puppet-agent
RUN yum -y install cronie
RUN yum -y install rsyslog
RUN yum clean all
RUN mkdir /etc/service/apache
RUN mkdir /etc/service/cron
RUN mkdir /etc/service/syslog
ADD ./files/runit/service/cron-service /etc/service/cron/run
ADD ./files/runit/service/syslog-service /etc/service/syslog/run
######################
# Puppet configuration
######################
RUN  mkdir -p /puppet/files; mkdir -p /puppet/modules; mkdir -p /puppet/manifests
ADD ./files /puppet/files
ADD ./manifests /puppet/manifests
ADD ./modules /puppet/modules
RUN /opt/puppetlabs/bin/puppet apply --modulepath=/puppet/modules/ /puppet/manifests/default.pp
ENTRYPOINT ["/usr/sbin/runsvdir-start"]
