export MW_INSTALL_PATH=/srv/mediawiki/workdir
php Import.php --wiki=narkisto.nikerabb.it props.yaml
time php ../Sanat/SanatImport.php maintenancepages --wiki=narkisto.nikerabb.it
time parallel --eta --progress "php Import.php --wiki=narkisto.nikerabb.it" ::: out/{maps,kerääjä,pitäjä}.yaml
time parallel --joblog /tmp/log -j24 --linebuffer --eta --progress "php Import.php --wiki=narkisto.nikerabb.it" ::: out/Blom*.yaml
