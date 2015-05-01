#!/bin/sh
USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

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

#rename folder to mapper
mv nwis-mapper mapper

#create symbolic link
ln -s ${USER_HOME}/mapper /var/www 

#start up cherrypy services
sh ${USER_HOME}/mapper/server-config/PythonAppServers.sh

#setup up crons
crontab -l | { cat; echo "*/5 * * * * ${USER_HOME}/mapper/server-config/chkCherry.sh"; } | crontab -
crontab -l | { cat; echo "0 0 * * 0 rm -rf ${USER_HOME}/mapper/exporter/temp/*"; } | crontab -

#add redirect for /
cp ${USER_HOME}/mapper/server-config/favicon.ico /var/www/favicon.ico
cp ${USER_HOME}/mapper/server-config/index.html /var/www/index.html

#remove default html folder
rm -R /var/www/html

#add new virtual site
cp ${USER_HOME}/mapper/server-config/nwis-mapper.conf /etc/apache2/sites-available/nwis-mapper.conf
a2dissite 000-default
a2ensite nwis-mapper
service apache2 restart

#end
fi