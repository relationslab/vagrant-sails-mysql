#!/bin/sh

MYSQL_DB=cid
MYSQL_USER=cid
MYSQL_PASS=prototype

#
# iptables off
#
/sbin/iptables -F
/sbin/service iptables stop
/sbin/chkconfig iptables off


#
# yum repository
#
yum update -y ca-certificates

cp -a /vagrant/fastestmirror.conf /etc/yum/pluginconf.d/fastestmirror.conf 

rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/i386/epel-release-6-8.noarch.rpm
rpm -ivh http://dl.iuscommunity.org/pub/ius/stable/CentOS/6/x86_64/ius-release-1.0-11.ius.centos6.noarch.rpm


#
# ntp
#
yum -y install ntp
/sbin/service ntpd start
/sbin/chkconfig ntpd on


#
# php
#
yum -y install php54 php54-cli php54-pdo php54-mbstring php54-mcrypt php54-pecl-memcache php54-mysql php54-devel php54-common php54-pgsql php54-pear php54-gd php54-xml php54-pecl-xdebug php54-pecl-apc php54-intl
touch /var/log/php.log && chmod 666 /var/log/php.log
cp -a /vagrant/php.ini /etc/php.ini


#
# MySQL
#
yum -y install http://repo.mysql.com/mysql-community-release-el6-4.noarch.rpm
yum -y install mysql-community-server
#cp -a /vagrant/my.conf /etc/my.conf
/sbin/service mysqld restart
/sbin/chkconfig mysqld on

mysql -u root -e "create database ${MYSQL_DB} default charset utf8"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASS}' WITH GRANT OPTION;"
mysql -h localhost -u ${MYSQL_USER} -p${MYSQL_PASS} ${MYSQL_DB} < /vagrant/ddl.sql


#
# phpMyAdmin
#
sudo yum -y install --enablerepo=epel install -y phpMyAdmin


#
# Apache
#
cp -a /vagrant/httpd.conf /etc/httpd/conf/
cp -a /vagrant/phpMyAdmin.conf /etc/httpd/conf.d/phpMyAdmin.conf
/sbin/service httpd restart
/sbin/chkconfig httpd on


#
# Git
#
sudo yum -y remove git
sudo yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker
wget https://www.kernel.org/pub/software/scm/git/git-2.2.0.tar.gz
tar -zxf git-2.2.0.tar.gz
cd git-2.2.0
sudo make prefix=/usr/local all
sudo make prefix=/usr/local install
sudo ln -s /usr/local/bin/git /usr/bin/git
cd ..
sudo rm -f git-2.2.0.tar.gz
sudo rm -Rf git-2.2.0


#
# AWS-ElasticBeanstalk-CLI 
#
sudo yum -y install ruby
sudo yum -y install unzip
wget https://s3.amazonaws.com/elasticbeanstalk/cli/AWS-ElasticBeanstalk-CLI-2.5.1.zip
unzip AWS-ElasticBeanstalk-CLI-2.5.1.zip
rm AWS-ElasticBeanstalk-CLI-2.5.1.zip
mkdir .aws
mv AWS-ElasticBeanstalk-CLI-2.5.1 ./.aws/AWS-ElasticBeanstalk-CLI-2.5.1

#
# Node
#
sudo yum -y install nodejs npm --enablerepo=epel
sudo npm install -g npm
sudo npm install -g sails

