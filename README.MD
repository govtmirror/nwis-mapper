# nwis-mapper

> codebase for NWIS mapper

## Server setup

#### 1.  Deploy instance on AWS

##### current system specs

 - m3.large 
 - 8GB attached volume 
 - ubuntu server 12.04 LTS AMI

#### 2.  Set up server

copy server setup script from github
```bash
wget https://raw.githubusercontent.com/USGS-OWI/nwis-mapper/master/server-config/server-setup.sh
```

run server setup script
```bash
sudo sh server-setup.sh
```

the nwis mapper application should now be running