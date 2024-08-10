setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
systemctl stop firewalld
systemctl disable firewalld

dnf -y install mariadb-server
systemctl enable mariadb.service --now

rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-4.el8.noarch.rpm
dnf clean all
dnf -y install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-agent

mysql -u root -e "create database zab2 character set utf8 collate utf8_bin;"
mysql -u root -e "grant all privileges on zab2.* to zab2@localhost identified by 'zab2';"
mysql -u root -e "set global log_bin_trust_function_creators = 1;"
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzab2 -pzab2 zab2
mysql -u root -e "set global log_bin_trust_function_creators = 0;"

sed -i 's/# DBPassword=/DBPassword=zab2/' /etc/zabbix/zabbix_server.conf
sed -i 's/DBName=zabbix/DBName=zab2/' /etc/zabbix/zabbix_server.conf
sed -i 's/DBUser=zabbix/DBUser=zab2/' /etc/zabbix/zabbix_server.conf
echo "php_value[date.timezone] = Asia/Tokyo" >> /etc/php-fpm.d/zabbix.conf

systemctl restart zabbix-server zabbix-agent httpd php-fpm
systemctl enable zabbix-server zabbix-agent httpd php-fpm
