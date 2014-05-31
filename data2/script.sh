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
sudo wget http://wing-net.ddo.jp/wing/extras/6/EL6.wing-extras.repo
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

sudo rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm
sudo yum -y --enablerepo=epel install re2c libmcrypt libmcrypt-devel
sudo yum -y install libxml2-devel bison bison-devel openssl-devel curl-devel libjpeg-devel libpng-devel libmcrypt-devel readline-devel libtidy-devel libxslt-devel httpd-devel enchant-devel libXpm libXpm-devel freetype-devel t1lib t1lib-devel gmp-devel libc-client-devel libicu-devel oniguruma-devel net-snmp net-snmp-devel  bzip2-devel
sudo yum -y install php55w php55w-bcmath php55w-cli php55w-common php55w-dba php55w-devel php55w-embedded php55w-enchant php55w-fpm php55w-gd php55w-imap php55w-interbase php55w-intl php55w-ldap php55w-mbstring php55w-mcrypt php55w-mssql php55w-mysql php55w-odbc php55w-opcache php55w-pdo php55w-pear.noarch php55w-pecl-apcu php55w-pecl-apcu-devel php55w-pecl-memcache php55w-pecl-xdebug php55w-pgsql php55w-process php55w-pspell php55w-recode php55w-snmp php55w-soap php55w-tidy php55w-xml php55w-xmlrpc

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

# yum
sudo yum -y install net-snmp unixODBC OpenIPMI-libs ipa-pgothic-fonts --enablerepo=remi
sudo yum -y install fping iksemel-utils libssh2-devel



# nginx settings
sudo mkdir -p /var/log/nginx/dev.example.com
sudo cp -p /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.org
sudo cat /etc/php-fpm.d/www.conf > /tmp/www.conf
sudo sed -i 's/user = apache/user = nginx/g'                   /tmp/www.conf
sudo sed -i 's/group = apache/group = nginx/g'                 /tmp/www.conf
sudo sed -i 's/;listen.mode = 0666/listen.mode = 0666/g'       /tmp/www.conf
sudo sed -i 's/;listen.owner = nobody/listen.owner = nginx/g'  /tmp/www.conf
sudo sed -i 's/;listen.group = nobody/listen.group = nginx/g'  /tmp/www.conf
sudo mv /tmp/www.conf /etc/php-fpm.d/www.conf

cat <<'_EOT_' > /tmp/dev.example.com.conf
server {
    listen       80;
    server_name  dev.example.com
                 192.168.50.112
                 ;

    access_log  /var/log/nginx/dev.example.com/access.log  main;
    error_log   /var/log/nginx/dev.example.com/error.log;

    root   /vagrant/app_project/htdocs;

    index  index.php;

    location / {
        try_files $uri $uri/ /index.php?$uri&$args;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }

    location ~ (\.htaccess|\.git|\.svn) {
        deny  all;
    }
    
    charset utf-8;
    
}

_EOT_


sudo mkdir -p /var/log/nginx/dev.example.com
sudo mv /tmp/dev.example.com.conf /etc/nginx/conf.d/dev.example.com.conf


# nginx restart
sudo service nginx restart
sudo service php-fpm restart

