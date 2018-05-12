#!/bin/bash

#This script is under a CC-0 Licence.

#######################################################
#LANCER LE SCRIPT EN ROOT ! | RUN THIS SCRIPT AS ROOT !
#######################################################
if [ "$EUID" -ne 0 ]; then
    echo "Please, run as root."
    exit
fi

#-------------------------------------------------------#
#Téléchargement des ressources. | Downloading ressources.

wget 'http://dl.ak.ankama.com/games/installers/dofus-amd64.tar.gz'
wget 'http://drive.noobslab.com/data/apps/AdobeAir/adobeair_2.6.0.2_amd64.deb'
wget 'fr.archive.ubuntu.com/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb'

#-------------------------------------------------------#
#Dépaquetage de l'archive Dofus et installation des dépendances. | Unzipping Dofus' archive and installing dependancies.

mkdir extract
mv dofus-amd64.tar.gz extract
cd extract
tar xvzf dofus-amd64.tar.gz
rm dofus-amd64.tar.gz
cd -
dpkg -i libpng12-0_1.2.54-1ubuntu1_amd64.deb
dpkg -i adobeair_2.6.0.2_amd64.deb

#-------------------------------------------------------#
#Correction des bugs de dépendances. | Correcting dependancies bugs.

apt --fix-broken install
apt-get install libcanberra-gtk-module:i386 gtk2-engines-murrine:i386 libasound2:i386 libasound2-plugins:i386

#-------------------------------------------------------#
#Déplacement de l'archive Dofus. | Moving Dofus' Archive.
##Ici, vous pouvez changer le dossier de destination qui contiendra Dofus. | Here, you can change the destination directory which will contain Dofus.

mv ./extract/Dofus/ /opt/ ##CUSTOMIZABLE DIRECTORY (change /opt/)
rm -rf extract

#-------------------------------------------------------#
#Suppression des archives téléchargées. | Removing downloaded archives.

rm libpng12-0_1.2.54-1ubuntu1_amd64.deb adobeair_2.6.0.2_amd64.deb 

#-------------------------------------------------------#
#Création du script de lancement de Dofus. | Creating Dofus' running script.

SCRIPT_DIR=/usr/local/bin/dofus

echo "#!/bin/bash" > $SCRIPT_DIR
echo "cd /opt/Dofus" >> $SCRIPT_DIR ##CUSTOMIZABLE Directory (Be constant with your previous choice)
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
echo "Icon=/opt/Dofus/share/updater_data/icons/game_icon_128x128.png" >> $DESKTOP_APP ##CUSTOMIZABLE Icon (Founded in */Dofus/share/updater_data/icons/)

#-------------------------------------------------------#
#Fin du Programme. | End of Program.
exit
