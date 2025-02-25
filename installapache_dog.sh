sudo apt install apache2 -y &> /dev/null 
# echo "Apache2 installed." 
wget https://www.free-css.com/assets/files/free-css-templates/download/page291/drool.zip &> /dev/null
unzip drool.zip &> /dev/null 
sudo mv drool-html/* /var/www/html/ 
# echo "You can visit my web site now."
dialog --title "完成安裝" --msgbox "\n恭喜你，可以開始瀏覽我的網站了~~" 10 37