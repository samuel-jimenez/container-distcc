#!/bin/sh

# create empty container
ctr=$(buildah from scratch)

# create archlinux container
archctr=$(buildah from "archlinux")

# update and copy minimum functionality
buildah run "$archctr" -- pacman  -Syu --noconfirm pacman-contrib  rsync
buildah run "$archctr" -- rm -rf /usr/include /usr/lib/firmware /usr/lib/modules
buildah run "$archctr" -- rsync -aAX /* /mnt --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found,/home/*/.gvfs}

# install desired packages
buildah run "$archctr" -- pacman --root /mnt --config /etc/pacman.conf -b /var/lib/pacman --cachedir /var/cache/pacman/pkg  --noconfirm -S base  distcc gcc

# clean cache
buildah run "$archctr" -- paccache -rk0

# copy packages to scratch container
archmnt=$(buildah mount $archctr)
buildah copy $ctr $archmnt/mnt /
buildah unmount $archctr

# cleanup and commit
buildah rm "$archctr"
buildah commit -- "$ctr" "distcc"

