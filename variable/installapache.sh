#!/bin/bash

# 檢查參數是否完整
if [ $# -lt 5 ]; then
    echo "使用方式: $0 <template_id> <template_url> <template_zip> <template_dir> <template_name>"
    exit 1
fi

# 設定變數
TEMPLATE_ID="$1"
TEMPLATE_URL="$2"
TEMPLATE_ZIP="$3"
TEMPLATE_DIR="$4"
TEMPLATE_NAME="$5"

# 安裝模板
install_template() {
    # 顯示進度條
    (
        # 安裝 Apache2 
        sudo apt install apache2 -y &> /dev/null
        wget ${TEMPLATE_URL} &> /dev/null
        unzip -o ${TEMPLATE_ZIP} &> /dev/null
        sudo mv ${TEMPLATE_DIR}/* /var/www/html/ &> /dev/null
    ) | dialog --title "進度條" --gauge "正在執行，請稍候..." 10 50 0
    
    # 顯示完成訊息
    dialog --title "完成安裝" --msgbox "\n恭喜你，可以開始瀏覽你的「${TEMPLATE_NAME}」網站了~~\n\n在瀏覽器中輸入 http://localhost 或伺服器IP進行訪問。" 10 60

}

# 執行安裝
install_template