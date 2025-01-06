#!/bin/sh
# =========================================
# Rfriends (radiko radiru録音ツール)
# 1.0 2024/12/16 new github
# 1.2 2025/01/07 fix
ver=1.2
echo start arch_install
echo
# =========================================
sys=`pgrep -o systemd`
if [ $? -ne 0 ]; then
sys=0
fi
#
if [ -z "$optlighttpd" ]; then
  optlighttpd="on"
fi
if [ -z "$optsamba" ]; then
  optsamba="on"
fi
if [ "$optlighttpd" != "on" ]; then
  optlighttpd="off"
fi
if [ "$optsamba" != "on" ]; then
  optsamba="off"
fi
#
dir=$(cd $(dirname $0);pwd)
user=`whoami`
if [ -z $HOME ]; then
  homedir=`sh -c 'cd && pwd'`
else
  homedir=$HOME
fi
#
SITE=https://github.com/rfriends/rfriends3/releases/latest/download
SCRIPT=rfriends3_latest_script.zip
# -----------------------------------------
echo
echo rfriends3 Setup Utility for arch Ver. $ver
echo
#sudo ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# update
sudo pacman -Sy --noconfirm
sudo pacman -Syu --noconfirm
# -----------------------------------------
# ツールのインストール
# -----------------------------------------

# already included
#sudo pacman -S --noconfirm php-cli php-xml php-zip php-mbstring php-json php-curl
 
sudo pacman -S --noconfirm php php-intl unzip wget ffmpeg at cronie atomicparsley chromium
#sudo pacman -S --noconfirm ffmpeg-devel

sudo systemctl start atd
sudo systemctl start cronie

sudo ln -s /usr/bin/atomicparsley /usr/bin/AtomicParsley
# -----------------------------------------
# .vimrcを設定する
# -----------------------------------------
cd $homedir
mv -n .vimrc .vimrc.org
cat <<EOF > .vimrc
set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileformats=unix,dos,mac
EOF
chmod 644 .vimrc
# =========================================
# rfriends3のインストール
# =========================================
cd $homedir
rm -f $SCRIPT
wget $SITE/$SCRIPT
unzip -q -o $SCRIPT

mkdir -p $homedir/tmp/
cat <<EOF > $homedir/rfriends3/config/usrdir.ini
usrdir = "$homedir/rfriends3/usr/"
tmpdir = "$homedir/tmp/"
EOF
# -----------------------------------------
# install samba
# -----------------------------------------
echo samba $optsamba
if [ $optsamba = "on" ]; then
sudo pacman -S --noconfirm samba
sudo mkdir -p /var/log/samba
sudo chown root:adm /var/log/samba

#sudo cp -p /etc/samba/smb.conf /etc/samba/smb.conf.org
sed -e s%rfriendshomedir%$homedir%g $dir/smb.conf.skel > $dir/smb.conf
sed -i s%rfriendsuser%$user%g $dir/smb.conf
sudo cp -p $dir/smb.conf /etc/samba/smb.conf
sudo chown root:root /etc/samba/smb.conf

mkdir -p $homedir/smbdir/usr2/
cat <<EOF > $homedir/rfriends3/config/usrdir.ini
usrdir = "$homedir/smbdir/usr2/"
tmpdir = "$homedir/tmp/"
EOF

sudo systemctl restart smb
sudo systemctl enable smb
fi
# -----------------------------------------
echo
echo install lighttpd
echo
# -----------------------------------------
echo lighttpd $optlighttpd
if [ $optlighttpd = "on" ]; then
conf_dir=/etc/lighttpd
#
cd $dir
sudo pacman -S --noconfirm lighttpd php-cgi
mkdir -p $homedir/lighttpd
echo lighttpd > $homedir/rfriends3/rfriends3_boot.txt
#
# lighttpd
#sudo cp -p $conf_dir/lighttpd.conf $conf_dir/lighttpd.conf.org
sed -e s%rfriendshomedir%$homedir%g lighttpd.conf.skel > lighttpd.conf
sed -i s%rfriendsuser%$user%g lighttpd.conf
sudo cp -p lighttpd.conf $conf_dir/lighttpd.conf
sudo chown root:root $conf_dir/lighttpd.conf
#
# modules
#sudo cp -p $conf_dir/modules.conf $conf_dir/modules.conf.org
sudo cp -p modules.conf.skel $conf_dir/modules.conf
sudo chown root:root $conf_dir/modules.conf
#
sudo mkdir -p $conf_dir/conf.d
sudo cp -p conf.d/* $conf_dir/conf.d/
#
cd $homedir/rfriends3/script/html
ln -nfs temp webdav
#
fi
#
sudo systemctl enable lighttpd
sudo systemctl restart lighttpd
# =========================================-
#echo rfriends3ビルトインサーバの実行方法
#echo cd $homedir/rfriends3
#echo sh rf3server.sh
# =========================================
echo
echo finished arch_install
# -----------------------------------------
