# Install tarball version of Tetr.IO with just a basic script!

A script to easily install Tetr.IO the tarball way on your Linux machine!

Note: This installation script is by no means affiliated with osk. If you may have a concern about script, open an issue, if you have a concern about copyright or anything related to it, please open an issue, or compose me an email. 

## Usage

Clone the repo and run the script
```bash

git clone https://github.com/spookyorange/tetrio-linux-install.git
cd tetrio-linux-install
sh ./install.sh

```

To remove the application(if it has been installed with this method)
```bash

sh ./uninstall.sh

```

Updates are handled by running the install script again. The script reads the latest major version from the Tetr.io download page, so major updates are picked up automatically. If detection ever fails, or you want a specific version, set it yourself: `TETRIO_VERSION=10 ./install.sh`

```bash

sh ./install.sh

```

## Details

The script will install the application in the following destinations if you have installed locally:

- ~/.tarball-installations/tetrio
- ~/.local/bin/tetrio
- ~/.local/share/applications/tetrio.desktop

## Tested Distros

- Fedora by Spookyorange
- Fedora Atomic(Silverblue) by Spookyorange
- SteamOS(Steam Deck) by Spookyorange

## Contributing

If you have a distro that you would like to add to the list of tested distros, please submit a pull request with the changes you made to the script and the distro you tested it on.
