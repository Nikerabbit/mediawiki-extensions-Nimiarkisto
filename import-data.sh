service memcached restart
service hhvm restart
echo "DROP DATABASE narkisto; CREATE DATABASE narkisto;"| mysql narkisto -u narkistong -p --host narkistong.cry6sjidctkw.us-west-2.rds.amazonaws.com
mysql narkisto -u narkistong -p --host narkistong.cry6sjidctkw.us-west-2.rds.amazonaws.com < narkisto-empty.sql
export MW_INSTALL_PATH=/srv/mediawiki/workdir
php ../../maintenance/addSite.php --language=fi --pagepath="https://nimiarkisto.fi/wiki/$1" --wiki="narkisto.nikerabb.it" nimiarkisto special
service memcached restart
service hhvm restart
time php ../Sanat/SanatImport.php maintenancepages --wiki=narkisto.nikerabb.it
php Import.php --wiki=narkisto.nikerabb.it props.yaml
php Import.php --wiki=narkisto.nikerabb.it items.yaml
time parallel "php Import.php --wiki=narkisto.nikerabb.it" ::: out/AA_*.yaml
time parallel --joblog /tmp/log -j24 --linebuffer --eta --progress "php Import.php --wiki=narkisto.nikerabb.it" ::: out/XX_*.yaml
