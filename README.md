# Installation-de-Aciah-Linux


## Installation
le fichier iso permettant l'installation de Aciah-Linux, verson ddu 30 juillet 2026, est ici :
https://aciah.xyz/iso

Des explications sont ici : https://aciah.xyz/iso/infos

## Construction du packet debian [en]
Note du 7 novembre 2026 : les sept lignes ci-dessous sont peut-être dépassées)

1. Modify the sources in the `src/scripts` directory.
2. Change the version in `VERSION`.
3. Add the latest section on top of the `debian/changelog` file.
4. Decrypt the package signing key: `make decrypt-key`.
5. Build the archive (just a compressed tarball of the sources) `make archive`.
6. Build the package `make package`. The files in the `ppa/` directories are updated by the script.
7. Commit and push these updated files, add the newly created .deb file. Push to the remote repository.

