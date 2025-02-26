rm -rf bro* dro* gra* ant* pic* res* sav* kla* jac* ant* ren* mak* hom* 
sudo rm -rf /var/www
sudo rm -rf phpsysinfo-3.4.4
sudo rm -rf v3.4.4.zip
sudo apt remove apache2 -y &> /dev/null && rm -rf /var/www 
# echo "Apache2 removed."
dialog --title "大功告成" --msgbox "你的Apache已經完成移除了" 10 50

