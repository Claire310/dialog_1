rm -rf *.zip
rm -rf html &> /dev/null
sudo rm -rf /var/www 
sudo apt remove apache2 -y &> /dev/null
dialog --title "成功" --msgbox "你已成功移除apache!" 10 50


