.POSIX:

DESTDIR=
PREFIX=/usr/local
SYSTEMD=/etc/systemd/system
SERVICE=backup-docker-volumes

build:

install: build
	mkdir -p '$(DESTDIR)$(PREFIX)'
	mkdir -p '$(DESTDIR)$(SYSTEMD)'
	m4 \
	    -DDESTDIR_PREFIX="$$(readlink -f '$(DESTDIR)$(PREFIX)')" \
	    '$(SERVICE).service.m4' \
	    >'$(DESTDIR)$(SYSTEMD)/$(SERVICE).service'
	cp '$(SERVICE).timer' '$(DESTDIR)$(SYSTEMD)'
	mkdir -p '$(DESTDIR)$(PREFIX)/bin'
	chmod go+rx '$(DESTDIR)$(PREFIX)/bin'
	cp backup-docker-volumes-locally-and-clean-expired.sh '$(DESTDIR)$(PREFIX)'/bin/backup-docker-volumes-locally-and-clean-expired
	chmod go+rx '$(DESTDIR)$(PREFIX)'/bin/backup-docker-volumes-locally-and-clean-expired
	cp backup-docker-volumes-locally.sh '$(DESTDIR)$(PREFIX)/bin/backup-docker-volumes-locally'
	chmod go+rx '$(DESTDIR)$(PREFIX)/bin/backup-docker-volumes-locally'
	cp move-local-docker-volume-backups-off-site.sh '$(DESTDIR)$(PREFIX)/bin/move-local-docker-volume-backups-off-site'
	chmod go+rx '$(DESTDIR)$(PREFIX)/bin/move-local-docker-volume-backups-off-site'
	cp remove-local-expired-docker-volume-backups.sh '$(DESTDIR)$(PREFIX)/bin/remove-local-expired-docker-volume-backups'
	chmod go+rx '$(DESTDIR)$(PREFIX)/bin/remove-local-expired-docker-volume-backups'
	mkdir -p '$(DESTDIR)$(PREFIX)/lib/$(SERVICE)'
	chmod go+rx '$(DESTDIR)$(PREFIX)/lib/$(SERVICE)'
	cp utils.sh '$(DESTDIR)$(PREFIX)/lib/$(SERVICE)'
	chmod go+rx '$(DESTDIR)$(PREFIX)/lib/$(SERVICE)/utils.sh'

uninstall:
	rm '$(DESTDIR)$(SYSTEMD)/$(SERVICE).service'
	rm '$(DESTDIR)$(SYSTEMD)/$(SERVICE).timer'
	rm '$(DESTDIR)$(PREFIX)/lib/$(SERVICE)/'*
	rm '$(DESTDIR)$(PREFIX)/bin/backup-docker-volumes-locally-and-clean-expired'
	rm '$(DESTDIR)$(PREFIX)/bin/backup-docker-volumes-locally'
	rm '$(DESTDIR)$(PREFIX)/bin/move-local-docker-volume-backups-off-site'
	rm '$(DESTDIR)$(PREFIX)/bin/remove-local-expired-docker-volume-backups'
	rmdir '$(DESTDIR)$(PREFIX)/lib/$(SERVICE)' || true

