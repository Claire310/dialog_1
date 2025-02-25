sudo apt install apache2 -y &> /dev/null 
# echo "Apache2 installed." 
wget https://www.free-css.com/assets/files/free-css-templates/download/page296/browny.zip &> /dev/null
unzip browny.zip &> /dev/null 
sudo mv browny-v1.0/* /var/www/html/ 


# 取得原始標題並依序替換
if [ ! -z "$SITE_NAME" ]; then
    # 先取得原始標題
    ORIGINAL_TITLE=$(grep -oPi '(?<=<title>).*?(?=</title>)' /var/www/html/index.html)
    if [ ! -z "$ORIGINAL_TITLE" ]; then
        # 替換所有與原始標題相同的文字（不區分大小寫）為 SITE_NAME
        sudo sed -i "s|$ORIGINAL_TITLE|$SITE_NAME|gi" /var/www/html/index.html
    fi
fi


dialog --title "完成安裝" --msgbox "\n恭喜你，可以開始瀏覽我的網站了~~" 10 37