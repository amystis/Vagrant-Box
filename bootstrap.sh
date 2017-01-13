#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='root'
PROJECTFOLDER='My Projects'

# create project folder
#sudo mkdir "/vagrant/${PROJECTFOLDER}"

# update / upgrade
# update / upgrade
sudo apt-get install -y python-software-properties software-properties-common
sudo LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php 
sudo apt-get purge -y php5-common

sudo apt-get update
sudo apt-get -y upgrade

# install apache 2.5 and php 5.5
sudo apt-get install -y apache2
sudo apt-get install -y php5.6 php5.6-curl php5.6-soap
sudo apt-get --purge -y autoremove 

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get install php5.6-mysql

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
	PHPINIDir /vagrant
    DocumentRoot "/vagrant/${PROJECTFOLDER}"
    <Directory "/vagrant/${PROJECTFOLDER}">
		Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-enabled/000-default.conf
# php extensions
sudo apt-get install -y php5.6-mbstring
sudo apt-get install -y php5.6-gd
sudo apt-get install -y php5.6-xml
sudo apt-get install -y php5-mcrypt
sudo php5enmod mcrypt
# programs
sudo apt-get install zip gzip tar

#ioncube installation
sudo wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
sudo tar -zxvf ioncube_loaders_lin_x86-64.tar.gz -C /usr/local/src/
sudo mkdir /usr/local/ioncube
cp /usr/local/src/ioncube/ioncube_loader_lin_5.6.so /usr/local/ioncube/
cp /usr/local/src/ioncube/ioncube_loader_lin_5.6_ts.so  /usr/local/ioncube/

# enable mod_rewrite
sudo a2enmod rewrite

# restart apache
service apache2 restart

# install git
 sudo apt-get -y install git

# install Composer
 curl -s https://getcomposer.org/installer | php
 mv composer.phar /usr/local/bin/composer

#database import
#sudo  mysql -u root -proot -e "create database xtc";
#sudo mysql -u root -proot xtc < /vagrant/xtc.sql



