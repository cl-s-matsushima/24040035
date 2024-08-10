sudo su -
sed -i -e "s/^mirrorlist=http:\/\/mirrorlist.centos.org/#mirrorlist=http:\/\/mirrorlist.centos.org/g" /etc/yum.repos.d/CentOS-Base.repo
sed -i -e "s/^#baseurl=http:\/\/mirror.centos.org/baseurl=http:\/\/vault.centos.org/g" /etc/yum.repos.d/CentOS-Base.repo
yum -y install httpd 
yum -y install epel-release
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum -y install --enablerepo=remi,remi-php74 php php-devel php-mbstring php-pdo php-gd php-mysqlnd
systemctl start httpd
systemctl enable httpd

systemctl start firewalld.service
firewall-cmd --permanent --add-port=80/tcp --zone=public --permanent
firewall-cmd --reload

yum -y install mariadb-server mariadb-client
systemctl enable mariadb
systemctl start mariadb

cat /etc/httpd/conf/httpd.conf | grep DocumentRoot
yum -y install wget
cd /var/www/html
touch index.html
wget https://ja.wordpress.org/latest-ja.tar.gz
tar xvf latest-ja.tar.gz
chown -R apache:apache

mysql -u root -e "CREATE DATABASE word2 DEFAULT CHARACTER SET utf8;"
mysql -u root -e "create user 'word2'@localhost identified by 'word2';"
mysql -u root -e "grant all privileges on *.* to 'word2'@'localhost';"

cd wordpress
cp wp-config-sample.php wp-config.php
sed -i 's/database_name_here/word2/' wp-config.php
sed -i 's/username_here/word2/' wp-config.php
sed -i 's/password_here/word2/' wp-config.php

