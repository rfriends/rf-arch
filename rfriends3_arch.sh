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
echo rfriends3 Setup Utility Ver. 1.0
echo
echo "これは Arch Linux 用です"
echo
# -----------------------------------------
# ツールのインストール
# -----------------------------------------
#sudo ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# update
sudo pacman -Syu

echo
echo php, ffmpeg, at, AtomicParsley
echo

echo "上記ツールをインストールしますか　(y/n) ?"
read ans
if [ "$ans" = "y" ]; then
	sudo pacman -S php php-intl
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
#  ビルトインサーバ
#
echo
echo rfriends3の実行方法
echo 
echo sh $HOME/rfriends3/rf3server.sh
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
