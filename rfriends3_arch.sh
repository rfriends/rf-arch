#!/bin/sh
# -----------------------------------------
# Rfriends (radiko radiru録音ツール)
# 2024/12/16 new github
# -----------------------------------------
SITE=https://github.com/rfriends/rfriends3/releases/latest/download
SCRIPT=rfriends3_latest_script.zip
dir=.
user=`whoami`
HOME=/home/$user
userstr="s/rfriendsuser/${user}/g"
# -----------------------------------------
echo
echo rfriends Setup Utility Ver. 1.0
echo
echo "これは Arch Linux 用です"
echo
# -----------------------------------------
# ツールのインストール
# -----------------------------------------
#sudo timedatectl set-timezone Asia/Tokyo

echo
echo "pacman update します"
echo
sudo pacman -Syu

echo
echo php, ffmpeg, at, AtomicParsley
echo
	sudo pacman -S  php php-intl
    	# already included
	#sudo pacman -S php-cli 
	#sudo pacman -S php-xml php-zip php-mbstring php-json php-curl

	sudo pacman -S unzip wget
	sudo pacman -S ffmpeg
	#sudo pacman -S ffmpeg-devel
 
	sudo pacman -S at cronie
	sudo pacman -S atomicparsley
	sudo pacman -S chromium
 
	#sudo pacman -S samba
	#sudo pacman -S lighttpd lighttpd-mod-webdav php-cgi
	#sudo pacman -S libmp4v2
	#sudo pacman -S gpac
	#sudo pacman -S ImageMagick
	#sudo pacman -S swftools

 	sudo systemctl start atd
 	sudo systemctl start atd cronie

	sudo ln -s /usr/bin/atomicparsley /usr/bin/AtomicParsley
fi

echo
echo "rfriends3をインストールしますか　(y/n) ?"
read ans
if [ "$ans" = "y" ]; then
    cd ~/
    rm -f $SCRIPT
    wget $SITE/$SCRIPT
    unzip -q -o $SCRIPT
fi
# -----------------------------------------
#echo rfriends3の実行方法
#echo
#echo cd ~/rfriends3
#echo sh rfriends3.sh
# -----------------------------------------
echo
echo configure samba
echo

#sudo mkdir -p /var/log/samba
#sudo chown root.adm /var/log/samba

#mkdir -p $HOME/smbdir/usr2/

#sudo cp -p /etc/samba/smb.conf /etc/samba/smb.conf.org
#sudo sed -e ${userstr} $dir/smb.conf.skel > $dir/smb.conf
#sudo cp -p $dir/smb.conf /etc/samba/smb.conf
#sudo chown root:root /etc/samba/smb.conf
# -----------------------------------------
echo
echo configure usrdir
echo
#mkdir -p $HOME/tmp/
#sed -e ${userstr} $dir/usrdir.ini.skel > $HOME/rfriends3/config/usrdir.ini
# -----------------------------------------
#  ビルトインサーバ
#
echo
echo rfriends3の実行方法
echo 
echo rfriends3/rf3server.sh
echo
echo 以下が表示されるので、webブラウザでアクセス
echo
echo rfriends3_server start
echo xxx.xxx.xxx.xxx:8000
echo
# -----------------------------------------
# 終了
# -----------------------------------------
echo
echo finished
# -----------------------------------------
