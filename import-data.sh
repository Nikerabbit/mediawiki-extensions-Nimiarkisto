DBNAME=narkisto
DBHOST=narkisto.cry6sjidctkw.us-west-2.rds.amazonaws.com
DBUSER=narkistong

service memcached restart
echo "DROP DATABASE $DBNAME; CREATE DATABASE $DBNAME;" | mysql "$DBNAME" -u "$DBUSER" -p --host "$DBHOST"
mysql narkisto -u "$DBUSER" -p --host "$DBHOST" < narkisto-empty.sql
export MW_INSTALL_PATH=/srv/mediawiki/workdir
php ../../maintenance/addSite.php --language=fi --pagepath="https://nimiarkisto.fi/wiki/$1" --wiki="nimiarkisto.fi" nimiarkisto special
php ../../maintenance/populateContentModel.php --wiki="nimiarkisto.fi" --ns=1 --table="revision"
php ../../maintenance/populateContentModel.php --wiki="nimiarkisto.fi" --ns=1 --table="archive"
php ../../maintenance/populateContentModel.php --wiki="nimiarkisto.fi" --ns=1 --table="page"
service memcached restart
time php ../Sanat/SanatImport.php maintenancepages --wiki=nimiarkisto.fi
php Import.php --wiki=nimiarkisto.fi props.yaml
php Import.php --wiki=nimiarkisto.fi items.yaml
time parallel "php Import.php --wiki=nimiarkisto.fi" ::: out/AA_*.yaml
time parallel --joblog /tmp/log -j24 --linebuffer --eta --progress "php Import.php --wiki=nimiarkisto.fi" ::: out/XX_*.yaml
