/usr/bin/nohup python /var/www/mapper/exporter/export.py > /dev/null 2>&1 &
/usr/bin/nohup python /var/www/mapper/exporter/exportSM.py > /dev/null 2>&1 &
/usr/bin/nohup python /var/www/mapper/exporter/siteCounter.py  > /dev/null 2>&1 &
/usr/bin/nohup python /var/www/mapper/exporter/fileUpload.py  > /dev/null 2>&1 &
/usr/bin/nohup python /var/www/mapper/exporter/aquifers.py  > /dev/null 2>&1 &
