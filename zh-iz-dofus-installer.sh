#!/bin/bash

#This script is under a CC-0 Licence.

#######################################################
#LANCER LE SCRIPT EN SUDO ! | RUN THIS SCRIPT AS SUDO !
#######################################################
if [ "$EUID" -ne 0 ]; then
    echo "Please, run as sudo."
    exit
fi

if [ ! -d "$1" ]; then
    echo "You need to set an existing installation directory."
    exit
fi
#-------------------------------------------------------#
#Téléchargement des ressources. | Downloading ressources.

wget -O dofus.tar.gz 'http://dl.ak.ankama.com/games/installers/dofus-amd64.tar.gz'
wget -O libpng12.deb 'fr.archive.ubuntu.com/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb'

#-------------------------------------------------------#
#Installation de WINE. Depuis la mise à jour 2.48, il remplace Adobe Air. | Installing WINE. Since 2.48 update, it replaces Adobe Air.

dpkg --add-architecture i386  
wget -nc https://dl.winehq.org/wine-builds/Release.key
apt-key add Release.key && rm Release.key
apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
apt-get update
apt-get -y install --install-recommends winehq-stable


#-------------------------------------------------------#
#Dépaquetage de l'archive Dofus et installation des dépendances. | Unzipping Dofus' archive and installing dependancies.

mkdir extract
mv dofus.tar.gz extract
cd extract
tar -xvzf dofus.tar.gz
rm dofus.tar.gz
cd -
dpkg -i libpng12.deb

#-------------------------------------------------------#
#Correction des bugs de dépendances. | Correcting dependancies bugs.

apt --fix-broken install

#-------------------------------------------------------#
#Déplacement de l'archive Dofus. | Moving Dofus' Archive.
##Ici, vous pouvez changer le dossier de destination qui contiendra Dofus. | Here, you can change the destination directory which will contain Dofus.

mv ./extract/Dofus/ $1 
rm -rf extract
chown -R $SUDO_USER:$SUDO_USER $1"Dofus"

#-------------------------------------------------------#
#Suppression des archives téléchargées. | Removing downloaded archives.

rm libpng12.deb

#-------------------------------------------------------#
#Création du script de lancement de Dofus. | Creating Dofus' running script.

SCRIPT_DIR=/usr/local/bin/dofus

echo "#!/bin/bash" > $SCRIPT_DIR
echo "cd "$1"/Dofus" >> $SCRIPT_DIR
echo "./Dofus" >> $SCRIPT_DIR
echo "exit 0;" >> $SCRIPT_DIR
chmod +x $SCRIPT_DIR

#-------------------------------------------------------#
#Création du raccourci. | Creating dock link.

DESKTOP_APP=/usr/share/applications/dofus.desktop

echo "[Desktop Entry]" > $DESKTOP_APP 
echo "Type=Application" >> $DESKTOP_APP
echo "Name=Dofus 2.0" >> $DESKTOP_APP
echo "Exec=dofus" >> $DESKTOP_APP
echo "Icon="$1"Dofus/share/updater_data/icons/game_icon_512x512.png" >> $DESKTOP_APP

#-------------------------------------------------------#
#Fin du Programme. | End of Program.
exit
