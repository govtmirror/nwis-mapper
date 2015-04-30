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

#### 2.  Add crontab entries
The chkCherry.sh shell script ensures the set of python scripts that use cherrypy are running
The second line clears out the exporter temp folder every week

```bash
*/5 * * * * /home/ubuntu/scripts/chkCherry.sh
0 0 * * 0 rm -rf /var/www/mapper/exporter/temp/*
```


#### 3.  Configure apache for proxy rewrites

enable apache mod-rewrite
```bash
sudo a2enmod rewrite
```

allow rewrites from /mapper folder.  add this to /etc/apache2/sites-available/000-default
```bash
<Directory /var/www/mapper>
		AllowOverride All
		Order Allow,Deny
		Allow from all
</Directory>
```