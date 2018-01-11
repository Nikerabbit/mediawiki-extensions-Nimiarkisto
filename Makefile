.PHONY: maintenance

maintenance: export MW_INSTALL_PATH=/srv/mediawiki/workdir
maintenance:
	php ../Sanat/SanatImport.php maintenancepages --wiki=nimiarkisto.nikerabb.it
