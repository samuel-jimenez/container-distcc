# container-distcc

## Prerequisites
* `buildah` to build container image
* `podman` or another container engine


dnf:
```sh
dnf install podman buildah
```
pacman:
```sh
pacman -Syu podman buildah
```
## Building

Build a minimal container using buildah
```sh
buildah unshare ./build.sh
```
Add a firewall exception:
```sh
sudo firewall-cmd --permanent --add-service distcc
```


## Running
Edit `distccd.conf` to allow desired build machines and logging level.

Set `ENV_FILE` environment variable or edit `run.sh` with the location of config file (Default: `${HOME}/containers/distcc/distccd.conf`).

Run the container:
```sh
./run.sh
```


## Systemd integration


A systemd unit is provided to autorestart the container
```sh
mv container-distcc.service $HOME/.config/systemd/user/
systemctl --user daemon-reload
```

Start and enable it:
```sh
systemctl --user start container-distcc.service
systemctl --user enable container-distcc.service
```

To view logs:

```sh
journalctl --user -xeu container-distcc.service
```
Alteratively, a custom systemd unit can be created.
```sh
cd $HOME/.config/systemd/user/
podman generate systemd --new --files --name distcc
systemctl --user daemon-reload
```
To use a config file, the `EnvironmentFile` key must be set.


## TODO

Use Quadlets for running containers and pods under systemd.

