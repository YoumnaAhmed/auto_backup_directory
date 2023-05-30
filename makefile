dir=directory1
backupdir=backupdir
interval_secs=3
max_backups=3
all: generate executable bash
generate:
	@mkdir -p backupdir
executable:
	@chmod +x backupd.sh
bash:
	@./backupd.sh ${dir} ${backupdir} ${interval_secs} ${max_backups}


