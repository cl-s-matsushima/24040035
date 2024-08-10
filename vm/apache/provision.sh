sudo yum -y install httpd 
sudo systemctl start httpd
sudo systemctl enable httpd

systemctl start firewalld.service
sudo firewall-cmd --permanent --add-port=80/tcp --zone=public --permanent
sudo firewall-cmd --reload

cat /etc/httpd/conf/httpd.conf | grep DocumentRoot
cd /var/www/html
sudo touch index.html
echo <h1>iketa?</h1> > index.html