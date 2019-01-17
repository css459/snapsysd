# snapsysd
COW (Copy-on-Write) Rotational Snapshotting Tool for Linux Systems

## Description

`snapsysd` is a system tool for taking incremental backups of the current disk.
The backups are rotational and leverage the `-l` flag on the `cp` command to only
store *changes* in the increments. 

It is worth noting that changes to file permissions
will propagate backwards in the increments. This can be avoided by instead adding the
following to the `rsync` call in place of the previous `cp` call:

`--link-dest=$SNAPSHOT_PATH/day.1`

The end result is a series of `day.x` directories within the specified snapshots directory
that contain the full file tree of the system at the time of the backup. These can be easily
explored using a normal file manager in case you only need a few backed up files.

## Installing

The following requirements are necessary:

	`rsync`

	`tar`

	`gpg` (for encrypted tar backups)

	GNU versions of:

	`cp` `mv` `seq`

(other versions may work, but you must check your versions' man pages
against their usage in these files to ensure compatibility)

Most of these should already be installed on your system, and all of them will
be available through your package manager.

---

The program can then be installed with:

    ./install.sh

A configured install can be done with:

    ./install.sh --snapshots-dir=<path> --num-increments=<int> --no-systemd

A default installation with create the directory `/snapshots` and
set the number of increment backups to be `5` (5 plus current, for a total of `6`)

If `--no-systemd` was not specified, then service files will be installed to `/etc/systemd/system/`

## Encrypted Tarball Backups

Another script is provided called `gen_tarball_backup.sh` which will place a
GPG encrypted tarball of `day.1` into the current directory. Since this file
will also store a password in plain-text, it should also have only **root permissions**

## Optional Configuration

You may want to exclude certain files from being backed up. Large binary blobs
will perform poorly under this backup tool since increments are made at the file
level, not the block level.

Some examples of large binary blobs you might want to exclude are:

- Virtual Machine disks
- Large compiled binaries or libraries that change often

At the **very minimum**, you will want to exclude files like:

- `/dev`
- `/proc`
- `/mnt`
- `/run`

A number of these are excluded by default.

---

You might also want to activate the systemd service file or timer.
**Do not enable snapsyd on startup** unless you like terrible startup performance,
and Silicon Valley already has plenty of that.

The systemd timer will run a backup every day at 4AM (or closest possible time)

If you are **not using systemd** then you can symlink `snapsysd.sh` to anacron
folders, which will run the script for you. (This is supported on Debian, for example).

Similarly, if you aren't using systemd, then chances are you already have a version of
cron you're familiar with, so just have it execute this script without arguments.

## That's it!

If you found this script to be too simple for your needs, I suggest you check out my
other backup script called Backpac, which can make backups to other drives, auto-mount
them, and manage multipe configurations:

https://github.com/css459/Backpac

For support or bugs, feel free to submit an Issue through GitHub. Enjoy!
