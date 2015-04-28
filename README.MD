# nwis-mapper

> codebase for NWIS mapper

## Server setup

#### 1.  Install required software 

```bash
sudo apt-get install python
sudo apt-get install python-pip
pip install Mako
pip install cherrypy
```

#### 2.  Add crontab entries
The chkCherry.sh shell script ensures the set of python scripts that use cherrypy are running
The second line clears out the exporter temp folder every week

```bash
*/5 * * * * /home/ubuntu/scripts/chkCherry.sh
0 0 * * 0 rm -rf /var/www/mapper/exporter/temp/*
```


#### 3.  Install global dependencies
```bash
npm install -g bower gulp
```
