# nwis-mapper

> codebase for NWIS mapper

## Server setup

#### 1.  Install required software 

```bash
sudo apt-get install python
sudo apt-get install python-pip
sudo apt-get install git
sudo apt-get install libgeos-dev
sudo apt-get install apache2
sudo pip install Mako
sudo pip install cherrypy
sudo pip install xlwt
sudo pip install shapely
```

#### 2.  Configure apache for proxy rewrites

enable apache mod-proxy
http://www.microhowto.info/howto/configure_apache_as_a_reverse_proxy.html
http://opcodesolutions.com/tech/ubuntu-apache-reverse-proxy-rewrite-html-links/
```bash
sudo a2enmod proxy_http
```

enable mod_proxy rewrites.  add this to /etc/apache2/sites-available/000-default under the DocumentRoot line
```bash
	#apache mod_proxy setup
	ProxyPass /mapper/nwis/site http://waterservices.usgs.gov/nwis/site
	ProxyPassReverse /mapper/nwis/site http://waterservices.usgs.gov/nwis/site
	ProxyPass /mapper/sitesmapper http://waterdata.usgs.gov
	ProxyPassReverse /mapper/sitesmapper http://waterdata.usgs.gov
	ProxyPass /mapper/nwissitesmapper http://nwis.waterdata.usgs.gov
	ProxyPassReverse /mapper/nwissitesmapper http://nwis.waterdata.usgs.gov
	ProxyPass /mapper/wamapper http://waterservices.usgs.gov/nwis/iv
	ProxyPassReverse /mapper/wamapper http://waterservices.usgs.gov/nwis/iv
	ProxyPass /mapper/export http://localhost:8080/exportFile
	ProxyPassReverse /mapper/export http://localhost:8080/exportFile
	ProxyPass /mapper/exportSM http://localhost:8081/exportFileSM
	ProxyPassReverse /mapper/exportSM http://localhost:8081/exportFileSM
	ProxyPass /mapper/sitecounter http://localhost:9998/counterProcess
	ProxyPassReverse /mapper/sitecounter http://localhost:9998/counterProcess
	ProxyPass /mapper/tileRGB http://localhost:8085/tileRGBValue
	ProxyPassReverse /mapper/tileRGB http://localhost:8085/tileRGBValue
```

Restart apache
```bash
sudo service service apache2 restart
```

#### 3.  Install code from github
```bash
*/5 * * * * /home/ubuntu/scripts/chkCherry.sh
0 0 * * 0 rm -rf /var/www/mapper/exporter/temp/*
```

#### 4.  Add crontab entries
The chkCherry.sh shell script ensures the set of python scripts that use cherrypy are running
The second line clears out the exporter temp folder every week

```bash
*/5 * * * * /home/ubuntu/scripts/chkCherry.sh
0 0 * * 0 rm -rf /var/www/mapper/exporter/temp/*
```