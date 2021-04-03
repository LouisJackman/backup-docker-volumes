.POSIX:

DESTDIR=
PREFIX=/usr/local
SYSTEMD=/etc/systemd/system
SERVICE=backup-docker-volumes-locally-and-clean-expired

build:

install: build
	mkdir -p '$(DESTDIR)$(PREFIX)'
	mkdir -p '$(DESTDIR)$(SYSTEMD)'
	sed \
	    -e "s|\$$\$${DESTDIR_PREFIX}|$$(readlink -f '$(DESTDIR)$(PREFIX)')|" \
	    '$(SERVICE).service' \
	    >'$(DESTDIR)$(SYSTEMD)/$(SERVICE).service'
	cp '$(SERVICE).timer' '$(DESTDIR)$(SYSTEMD)'
	mkdir -p '$(DESTDIR)$(PREFIX)/bin'
	cp '$(SERVICE).sh' '$(DESTDIR)$(PREFIX)/bin/$(SERVICE)'
	cp backup-docker-volumes-locally.sh '$(DESTDIR)$(PREFIX)/bin/backup-docker-volumes-locally'
	cp move-local-docker-volume-backups-off-site.sh '$(DESTDIR)$(PREFIX)/bin/move-local-docker-volume-backups-off-site'
	cp remove-local-expired-docker-volume-backups.sh '$(DESTDIR)$(PREFIX)/bin/remove-local-expired-docker-volume-backups'
	mkdir -p '$(DESTDIR)$(PREFIX)/lib/$(SERVICE)'
	cp utils.sh '$(DESTDIR)$(PREFIX)/lib/$(SERVICE)'

uninstall:
	rm '$(DESTDIR)$(SYSTEMD)/$(SERVICE).service'
	rm '$(DESTDIR)$(SYSTEMD)/$(SERVICE).timer'
	rm '$(DESTDIR)$(PREFIX)/lib/$(SERVICE)/'*
	rm '$(DESTDIR)$(PREFIX)/bin/$(SERVICE)'
	rm '$(DESTDIR)$(PREFIX)/bin/backup-docker-volumes-locally'
	rm '$(DESTDIR)$(PREFIX)/bin/move-local-docker-volume-backups-off-site'
	rm '$(DESTDIR)$(PREFIX)/bin/remove-local-expired-docker-volume-backups'
	rmdir '$(DESTDIR)$(PREFIX)/lib/$(SERVICE)' || true

