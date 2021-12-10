# otzarri-hacking

Ethical hacking tool set.

## Remote interactive installation (AchLinux/Manjaro, Debian/Ubuntu)

```
$ bash -c "$(curl -s https://gitlab.com/josebamartos/otzarri-hacking/-/raw/master/installer/remote-install.sh)"
```

## Remote unattended installation (AchLinux/Manjaro, Debian/Ubuntu)

To force the script to overwrite the existing configuration files:

```
$ curl -s https://gitlab.com/josebamartos/otzarri-hacking/-/raw/master/installer/remote-install.sh | bash -s overwrite-config
```

## Local installation

```
$ git clone git@gitlab.com:josebamartos/otzarri-hacking.git
$ otzarri-hacking/installer/install.sh
```

## Uninstallation

```
$ otzarri-hacking-uninstall
```

Tools are in [bin](bin) directory and their respective config files are in [config](config) directory.

| Tool                            | Config    | Description                                                |
| ------------------------------- | --------- | ---------------------------------------------------------- |
| [mkt](bin/mkt)                  | None      | Creates a directory structure for a pentesting target host |
