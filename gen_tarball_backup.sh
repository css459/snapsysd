
#!/bin/bash
#
# Cole Smith
# Creates an encrypted archive of a folder
#

TAR=/bin/tar;
GPG=/usr/bin/gpg;
BACKUP_FOLDER=/snapshots/day.1;
PASSWD="!";

if [ -d $BACKUP_FOLDER ] ; then
    $TAR cz $BACKUP_FOLDER | $GPG --batch --yes --passphrase $PASSWD -aco ./backup-$(date +"%m-%d-%Y-"%T"").tar.gz.gpg
fi
