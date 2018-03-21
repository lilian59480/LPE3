#!/bin/bash

WT_TITLE="Creation d'une cle USB bootable"
WT_MSG="Cette manipulation modifie le systeme embarque et
detruit les donnees d'une cle USB"

_warningbox

# Afficher le log kernel afin de recuperer la cle USB utilise
dmesg | grep -15 usb | less

# Recuperation des disques disponibles grace a la commande lsblk
DRIVES=$(lsblk -do name,size | tail -n +2 | awk '{if (NR == 1){ \
    print "/dev/null 0G ON \n/dev/"$0, "OFF"} else \
    {print "/dev/"$0, "OFF"}}')

WT_RADIO=($DRIVES)
WT_MSG="Quelle disque choisir (Cle USB Obligatoire) ?"

_radiobox

if [ $WT_EXIT_STATUS != 0 ]; then
    exit 0
fi

LPE_USB=$WT_RADIO_CHOICE

WT_MSG="Partitionner la cle USB en 2 partitions, 1 de boot(8MO) et 1 de data"
_msgbox

fdisk "$LPE_USB"

LPE_USB_BOOT="${LPE_USB}1"
LPE_USB_DATA="${LPE_USB}2"

mkfs -t vfat "$LPE_USB_BOOT"
syslinux -s "$LPE_USB_BOOT"

mke2fs -b 1024 -j "$LPE_USB_DATA"

# Montage du disque de donnees
LPE_MOUNT_PATH="/mnt/script-lpe-usb-data"

mkdir -p "$LPE_MOUNT_PATH"
mount "$LPE_USB_DATA" "$LPE_MOUNT_PATH"

grub-install "--root-directory=$LPE_MOUNT_PATH" "$LPE_USB"

# Demander si on fait une installation complete
WT_MSG="Installer le systeme entier ?"

_questionbox

if [ $WT_EXIT_STATUS = 0 ]; then

    LPE_EMB="$LPE_USB_DATA"
    LPE_DEV_P="$LPE_USB"

    LPE_UNAME_K_RELEASE=$(uname -r)
    # Creations des dossiers pour acceuillir les fichiers
    mkdir -pv "$LPE_EMB/lib/modules" \
        "$LPE_EMB/etc/modprobe.d" \
        "$LPE_EMB/etc/init.d" \
        "$LPE_EMB/boot" \
        "$LPE_EMB/dev" \
        "$LPE_EMB/proc" \
        "$LPE_EMB/usr/share/udhcpc"

    # Copie des modules
    cp -arvf "/lib/modules/$LPE_UNAME_K_RELEASE" "$LPE_EMB/lib/modules"

    # Copie du modprobe
    cp -arvf "/etc/modprobe.d" "$LPE_EMB/etc"

    # Copie du boot
    cp -arvf "/boot/grub" "$LPE_EMB/boot"
    cp -v "/boot/initrd.img-$LPE_UNAME_K_RELEASE" "$LPE_EMB/boot"
    cp -v "/boot/vmlinuz-$LPE_UNAME_K_RELEASE" "$LPE_EMB/boot"
    # Copie de Busybox
    WT_MSG="(Re)Installer Busybox?\n\
        N'oublier pas de l'installer dans $LPE_EMB"

    _questionbox

    if [ $WT_EXIT_STATUS = 0 ]; then
        . scripts/compiler_busybox.sh
        WT_TITLE="Copie du systeme de base"
    fi

    # Creation des fichiers blocks
    $(cd "$LPE_EMB/dev" && MAKEDEV -v generic console)

    # Creation du fichier pour l'automontage
    echo "#!/bin/sh
    mount -t proc /proc
    mount -o remount,rw /
    mount -a
    loadkmap < /etc/french.kmap
    ifconfig lo 127.0.0.1
    udhcpc" > "$LPE_EMB/etc/init.d/rcS"

    chmod a+x "$LPE_EMB/etc/init.d/rcS"

    echo "$LPE_DEV_P / ext3 defaults 1 1
    none /dev/pts devpts mode=622 0 0
    none /proc proc defaults 0 0" > "$LPE_EMB/etc/fstab"

    # Creation de l'entree dans le fichier grub
    echo "menuentry 'Busybox Petitpas Mauriaucourt' {
        insmod gzio
        insmod part_msdos
        insmod ext2
        set root='hd1,msdos1'
        echo 'Chargement de Linux $LPE_UNAME_K_RELEASE'
        linux /boot/vmlinuz-$LPE_UNAME_K_RELEASE root=$LPE_DEV_P ro
        echo 'Chargement du disque initrd'
        initrd /boot/initrd.img-$LPE_UNAME_K_RELEASE
    }" > "$LPE_EMB/boot/grub.cfg"

    update-grub2

    # Copie du clavier fr
    "$LPE_EMB/bin/dumpkmap" > "$LPE_EMB/etc/french.kmap"

    # Copie du fichier udhcpc
    cp -v compilation/busybox/busybox-1.27.2/examples/udhcp/simple.script "$LPE_EMB/usr/share/udhcpc/default.script"
    chmod a+x "$LPE_EMB/usr/share/udhcpc/default.script"
    cp -v compilation/busybox/busybox-1.27.2/examples/inittab "$LPE_EMB/etc"

    WT_MSG="Installer un utilisateur par defaut?"

    _questionbox

    if [ $WT_EXIT_STATUS = 0 ]; then
        echo "root::0:0:Super User:/:/bin/sh" > "$LPE_EMB/etc/passwd"
        echo "root:x:0:" > "$LPE_EMB/etc/group"
    fi
fi
