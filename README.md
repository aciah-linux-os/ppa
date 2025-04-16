# Installation-de-Aciah-Linux
Une installation façon Debian

## Installation
```bash
sudo curl -Ssl -o /etc/apt/trusted.gpg.d/aciah.asc https://aciah-linux-os.github.io/ppa/ppa/KEY.asc
sudo echo "deb [signed-by=/etc/apt/trusted.gpg.d/aciah.asc] https://aciah-linux-os.github.io/ppa/ppa ./" > /etc/apt/sources.list.d/aciah.list
sudo apt update
sudo apt install aciah
aciah_raccourcis_clavier
```

## Construction du packet debian [en]
1. Modify the sources in the `src/scripts` directory.
2. Change the version in `VERSION`.
3. Add the latest section on top of the `debian/changelog` file.
4. Decrypt the package signing key: `make decrypt-key`.
5. Build the archive (just a compressed tarball of the sources) `make archive`.
6. Build the package `make package`. The files in the `ppa/` directories are updated by the script.
7. Commit and push these updated files, add the newly created .deb file. Push to the remote repository.

