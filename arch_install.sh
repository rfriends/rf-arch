#!/bin/sh
# =========================================
# Rfriends (radiko radiru録音ツール)
# 1.0 2024/12/16 new github
# 1.1 2025/01/05 fix
ver=1.1
echo start arch_install
echo
# =========================================
sys=`pgrep -o systemd`
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
sudo pacman -g
sudo pacman -Syyu
# -----------------------------------------
# ツールのインストール
# -----------------------------------------

# already included
#sudo pacman -S php-cli php-xml php-zip php-mbstring php-json php-curl
 
sudo pacman -S php php-intl unzip wget ffmpeg at cronie atomicparsley chromium
#sudo pacman -S ffmpeg-devel
 
#sudo pacman -S samba
#sudo pacman -S lighttpd lighttpd-mod-webdav php-cgi

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
sudo pacman -S samba
sudo mkdir -p /var/log/samba
sudo chown root:adm /var/log/samba

sudo cp -p /etc/samba/smb.conf /etc/samba/smb.conf.org
sed -e s%rfriendshomedir%$homedir%g $dir/smb.conf.skel > $dir/smb.conf
sed -i s%rfriendsuser%$user%g $dir/smb.conf
sudo cp -p $dir/smb.conf /etc/samba/smb.conf
sudo chown root:root /etc/samba/smb.conf

mkdir -p $homedir/smbdir/usr2/
cat <<EOF > $homedir/rfriends3/config/usrdir.ini
usrdir = "$homedir/smbdir/usr2/"
tmpdir = "$homedir/tmp/"
EOF

sudo systemctl enable smb
sudo systemctl restart smb
fi
# =========================================-
echo
echo rfriends3ビルトインサーバの実行方法
echo 
echo sh $homedir/rfriends3/rf3server.sh
echo
echo 以下が表示されるので、webブラウザでアクセス
echo
echo rfriends3_server start
echo xxx.xxx.xxx.xxx:8000
echo
# =========================================
echo
echo finished arch_install
# -----------------------------------------
