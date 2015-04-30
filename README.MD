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
sudo apt-get install libapache2-mod-proxy-html libxml2-dev
sudo pip install Mako
sudo pip install cherrypy
sudo pip install xlwt
sudo pip install shapely
```

#### 2.  Configure apache for proxy rewrites

enable apache mod-proxy
```bash
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_html
sudo a2enmod xml2enc
```

enable mod_proxy rewrites.  add this to /etc/apache2/sites-available/000-default under the DocumentRoot line
```bash
	#apache mod_proxy setup
	ProxyPass /mapper/nwis/site http://waterservices.usgs.gov/nwis/site
	ProxyPass /mapper/sitesmapper http://waterdata.usgs.gov
	ProxyPass /mapper/nwissitesmapper http://nwis.waterdata.usgs.gov
	ProxyPass /mapper/wamapper http://waterservices.usgs.gov/nwis/iv
	ProxyPass /mapper/export http://localhost:8080/exportFile
	ProxyPass /mapper/exportSM http://localhost:8081/exportFileSM
	ProxyPass /mapper/sitecounter http://localhost:9998/counterProcess
	ProxyPass /mapper/tileRGB http://localhost:8085/tileRGBValue
```

#### 3.  Add crontab entries
The chkCherry.sh shell script ensures the set of python scripts that use cherrypy are running
The second line clears out the exporter temp folder every week

```bash
*/5 * * * * /home/ubuntu/scripts/chkCherry.sh
0 0 * * 0 rm -rf /var/www/mapper/exporter/temp/*
```