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

```bash
*/5 * * * * /home/ubuntu/scripts/chkCherry.sh
0 0 * * 0 rm -rf /var/www/mapper/exporter/temp/*
```


#### 3.  Install global dependencies
```bash
npm install -g bower gulp
```
