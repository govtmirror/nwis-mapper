#!/bin/sh

#list of apps
LIST_OF_MAIN_APPS="python python-pip git libgeos-dev apache2"
LIST_OF_PYTHON_APPS="Mako cherrypy xlwt shapely"

#install apps
apt-get update  # To get the latest package lists
apt-get install -y $LIST_OF_MAIN_APPS
pip install $LIST_OF_PYTHON_APPS

#install mod-proxy
a2enmod proxy_http

#get website content from github
git clone https://github.com/USGS-OWI/nwis-mapper.git
mv nwis-mapper mapper
ln -s /home/osboxes/mapper /var/www 

#start up cherrypy services
sh /home/osboxes/mapper/server-config/PythonAppServers.sh

#add proxy config to default virtualhost site
if grep -q "apache mod_proxy setup" "/etc/apache2/sites-available/000-default.conf"; then
	echo "Already appended mod-proxy setup"
else
	echo "#apache mod_proxy setup" >> /etc/apache2/sites-available/000-default.conf
	echo "ProxyPass /mapper/nwis/site http://waterservices.usgs.gov/nwis/site" >> /etc/apache2/sites-available/000-default.conf
	echo "ProxyPassReverse /mapper/nwis/site http://waterservices.usgs.gov/nwis/site" >> /etc/apache2/sites-available/000-default.conf
	echo "ProxyPass /mapper/sitesmapper http://waterdata.usgs.gov" >> /etc/apache2/sites-available/000-default.conf
	echo "ProxyPassReverse /mapper/sitesmapper http://waterdata.usgs.gov" >> /etc/apache2/sites-available/000-default.conf
	echo "ProxyPass /mapper/nwissitesmapper http://nwis.waterdata.usgs.gov" >> /etc/apache2/sites-available/000-default.conf
	echo "ProxyPassReverse /mapper/nwissitesmapper http://nwis.waterdata.usgs.gov" >> /etc/apache2/sites-available/000-default.conf
	echo "ProxyPass /mapper/wamapper http://waterservices.usgs.gov/nwis/iv" >> /etc/apache2/sites-available/000-default.conf
	echo "ProxyPassReverse /mapper/wamapper http://waterservices.usgs.gov/nwis/iv" >> /etc/apache2/sites-available/000-default.conf
	echo "ProxyPass /mapper/export http://localhost:8080/exportFile" >> /etc/apache2/sites-available/000-default.conf
	echo "ProxyPassReverse /mapper/export http://localhost:8080/exportFile" >> /etc/apache2/sites-available/000-default.conf
	echo "ProxyPass /mapper/exportSM http://localhost:8081/exportFileSM" >> /etc/apache2/sites-available/000-default.conf
	echo "ProxyPassReverse /mapper/exportSM http://localhost:8081/exportFileSM" >> /etc/apache2/sites-available/000-default.conf
	echo "ProxyPass /mapper/sitecounter http://localhost:9998/counterProcess" >> /etc/apache2/sites-available/000-default.conf
	echo "ProxyPassReverse /mapper/sitecounter http://localhost:9998/counterProcess" >> /etc/apache2/sites-available/000-default.conf
	echo "ProxyPass /mapper/tileRGB http://localhost:8085/tileRGBValue" >> /etc/apache2/sites-available/000-default.conf
	echo "ProxyPassReverse /mapper/tileRGB http://localhost:8085/tileRGBValue" >> /etc/apache2/sites-available/000-default.conf

#restart apache2
service apache2 restart
fi