rfriends_archはarch linux環境でrfriends3を動作させるスクリプトです。  
現在は、samba,lighttpdはインストールされません。  
  
cd ~/  
sudo pacman -S git  
rm -rf rfriends_arch  
git clone https://github.com/rfriends/rfriends_arch.git  
cd rfriends_arch  
sh rfriends_arch.sh  
