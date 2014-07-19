#!/bin/sh

# iptables off
sudo chkconfig iptables off
sudo service iptables stop

# epel,remi
sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

# developer
sudo yum -y update
sudo yum -y groupinstall "Development Tools"

cd /etc/yum.repos.d/
sudo wget http://wing-repo.net/wing/6/EL6.wing.repo
sudo wget http://wing-repo.net/wing/extras/6/EL6.wing-extras.repo
sudo yum clean all
sudo yum -y install yum-priorities

# git
sudo yum -y remove git
sudo yum -y install git --enablerepo=wing

# ntp
sudo yum -y install ntp
sudo service ntpd start
sudo chkconfig ntpd on

# vim
sudo yum -y install vim

#php
sudo rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm
sudo yum -y --enablerepo=epel install re2c libmcrypt libmcrypt-devel
sudo yum -y install libxml2-devel bison bison-devel openssl-devel curl-devel libjpeg-devel libpng-devel libmcrypt-devel readline-devel libtidy-devel libxslt-devel httpd-devel enchant-devel libXpm libXpm-devel freetype-devel t1lib t1lib-devel gmp-devel libc-client-devel libicu-devel oniguruma-devel net-snmp net-snmp-devel  bzip2-devel
sudo yum -y install php55w php55w-bcmath php55w-cli php55w-common php55w-dba php55w-devel php55w-embedded php55w-enchant php55w-fpm php55w-gd php55w-imap php55w-interbase php55w-intl php55w-ldap php55w-mbstring php55w-mcrypt php55w-mssql php55w-mysql php55w-odbc php55w-opcache php55w-pdo php55w-pear.noarch php55w-pecl-apcu php55w-pecl-apcu-devel php55w-pecl-memcache php55w-pecl-xdebug php55w-pgsql php55w-process php55w-pspell php55w-recode php55w-snmp php55w-soap php55w-tidy php55w-xml php55w-xmlrpc
sudo service php-fpm start
sudo chkconfig php-fpm on

# node
sudo yum -y install nodejs npm --enablerepo=epel

# ruby
sudo yum -y install ruby ruby-devel ruby-docs rubygems

# mysql
sudo yum -y install http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
sudo yum -y install mysql mysql-devel mysql-server mysql-utilities
sudo service mysqld start
sudo chkconfig mysqld on

# nginx
sudo rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
sudo yum -y install nginx --enablerepo=nginx
sudo service nginx start
sudo chkconfig nginx on

# user
sudo groupadd zabbix
sudo useradd -g zabbix zabbix

# wget
sudo wget https://www.dropbox.com/s/94pc7xh0zlkzv1z/zabbix-2.2.2.tar.gz

sudo yum -y install net-snmp unixODBC OpenIPMI-libs ipa-pgothic-fonts --enablerepo=remi
sudo yum -y install fping iksemel-utils libssh2-devel

# zabbix 
sudo mv zabbix-2.2.2.tar.gz /tmp/zabbix-2.2.2.tar.gz
cd /tmp
sudo tar zxf zabbix-2.2.2.tar.gz

cd /tmp/zabbix-2.2.2
sudo ./configure \
    --prefix=/usr/share/zabbix \
    --enable-server \
    --enable-agent \
    --enable-ipv6 \
    --with-libcurl=/usr/bin/curl-config \
    --with-mysql=/usr/bin/mysql_config \
    --with-net-snmp=/usr/bin/net-snmp-config

sudo make && sudo make install

# mysql settings
sudo cp -f /vagrant/my.cnf /etc/my.cnf
sudo service mysqld restart

# database
mysql -uroot -e "create database zabbix character set utf8;"
mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'password';"
mysql -uroot  zabbix < /tmp/zabbix-2.2.2/database/mysql/schema.sql
mysql -uroot  zabbix < /tmp/zabbix-2.2.2/database/mysql/images.sql
mysql -uroot  zabbix < /tmp/zabbix-2.2.2/database/mysql/data.sql

# config copy
sudo cp -f /vagrant/zabbix_server.conf /usr/share/zabbix/etc/zabbix_server.conf
sudo cp -a /tmp/zabbix-2.2.2/misc/init.d/fedora/core5/* /etc/init.d/
sudo cp -f /vagrant/zabbix_server /etc/init.d/zabbix_server
sudo cp -f /vagrant/zabbix_agentd /etc/init.d/zabbix_agentd

# log
sudo mkdir -p /var/log/zabbix
sudo chown -R zabbix.zabbix /var/log/zabbix/

# zabbix restart
sudo service zabbix_server start
sudo chkconfig zabbix_server on
sudo service zabbix_agentd start
sudo chkconfig zabbix_agentd on

# config file edit
sudo cp -f /vagrant/php.ini /etc/php.ini
sudo service php-fpm restart
sudo cp -R /tmp/zabbix-2.2.2/frontends/php /var/www/html/zabbix
sudo mkdir -p /var/log/nginx/dev.zabbix.com
sudo cp -f /vagrant/dev.zabbix.com.conf /etc/nginx/conf.d/dev.zabbix.com.conf
sudo cp -f /vagrant/zabbix.conf.php /var/www/html/zabbix/conf/zabbix.conf.php
sudo chown -R zabbix.zabbix /var/www/html/zabbix/
sudo chmod 777 -R /var/www/html/zabbix/

# nginx restart
sudo service nginx restart
