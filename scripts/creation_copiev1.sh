#!/bin/bash

WT_TITLE="Copie du systeme de base"
WT_MSG="Cette manipulation modifie le systeme embarque !"

_warningbox

if [ -z "$LPE_EMB" ]; then
    WT_MSG="Pas de dossier de montage ; /mnt/emb est donc choisi"
    $LPE_EMB="/mnt/emb"
fi

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
ifconfig lo 127.0.0.1" > "$LPE_EMB/etc/init.d/rcS"

chmod a+x "$LPE_EMB/etc/init.d/rcS"

echo "$LPE_DEV_P / ext3 defaults 1 1
none /dev/pts devpts mode=622 0 0
none /proc proc defaults 0 0" > "$LPE_EMB/etc/fstab"

# Creation de l'entree dans le fichier grub

# Copie du clavier fr
"$LPE_EMB/bin/dumpkmap" > "$LPE_EMB/etc/french.kmap"
