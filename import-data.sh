export MW_INSTALL_PATH=/srv/mediawiki/workdir
time php ../Sanat/SanatImport.php maintenancepages --wiki=narkisto.nikerabb.it
php Import.php --wiki=narkisto.nikerabb.it props.yaml
time parallel "php Import.php --wiki=narkisto.nikerabb.it" ::: out/{maps,kerääjä,pitäjä}.yaml
time parallel --joblog /tmp/log -j24 --linebuffer --eta --progress "php Import.php --wiki=narkisto.nikerabb.it" ::: out/XX*.yaml
