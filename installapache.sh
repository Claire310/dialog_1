#!/bin/bash

# 檢查參數是否完整
if [ $# -lt 6 ]; then
    echo "使用方式: $0 <template_id> <template_url> <template_zip> <template_dir> <template_name> <site_name>"
    exit 1
fi

# 設定變數
TEMPLATE_ID="$1"
TEMPLATE_URL="$2"
TEMPLATE_ZIP="$3"
TEMPLATE_DIR="$4"
TEMPLATE_NAME="$5"
SITE_NAME="$6"

# 創建臨時目錄
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# 安裝模板
install_template() {
    # 顯示進度條
    (
        echo "10"; sleep 0.5

# 安裝 Apache2
        echo "20"; sleep 0.5
        sudo apt install apache2 -y &> /dev/null

        echo "40"; sleep 0.5
        # 下載模板並指定輸出檔案名稱
        wget -O "$TEMPLATE_ZIP" "$TEMPLATE_URL" &> /dev/null

# 確認下載成功
        if [ ! -f "$TEMPLATE_ZIP" ]; then
            dialog --title "錯誤" --msgbox "\n下載失敗，請檢查網路連接或URL是否正確。" 8 40
            exit 1
        fi

        echo "60"; sleep 0.5
        # 解壓縮檔案
        unzip -o "$TEMPLATE_ZIP" &> /dev/null

# 確認目錄存在
        if [ ! -d "$TEMPLATE_DIR" ]; then
            # 嘗試列出解壓後的目錄
            EXTRACTED_DIRS=$(ls -la | grep "^d" | awk '{print $9}' | grep -v "^.$" | grep -v "^..$")
            dialog --title "錯誤" --msgbox "\n解壓縮後找不到目錄 $TEMPLATE_DIR\n已解壓目錄: $EXTRACTED_DIRS" 12 60
            exit 1
        fi

        echo "80"; sleep 0.5
        # 移動檔案到 Apache 目錄
        sudo cp -R "$TEMPLATE_DIR"/* /var/www/html/ &> /dev/null
        
        # 修改所有 HTML 檔案的 title
        echo "90"; sleep 0.5
        sudo find /var/www/html -type f -name "*.html" -exec sudo chmod 666 {} \;
        sudo find /var/www/html -type f -name "*.html" -exec sudo sed -i 's|<title>[^<]*</title>|<title>'"$SITE_NAME"'</title>|g' {} \;
        sudo find /var/www/html -type f -name "*.html" -exec sudo chmod 644 {} \;
        
        # 確認是否成功修改
        if ! grep -q "<title>$SITE_NAME</title>" /var/www/html/index.html; then
            dialog --title "警告" --msgbox "\nTitle 修改可能未成功，請手動確認。" 8 40
        fi

        echo "100"; sleep 0.5
    ) | dialog --title "＊.°· 進度條 ＊.°·" --gauge "\n正在執行，請稍候..." 10 50 0

# 清理臨時檔案
    cd - > /dev/null
    rm -rf "$TEMP_DIR"

# 顯示完成訊息
    dialog --title "＊.°·完成安裝＊.°·" --msgbox "\n恭喜你，可以開始瀏覽你的「${TEMPLATE_NAME}」網站了~\n\n請在瀏覽器中輸入 http://10.167.214.28 進行訪問。" 10 60
}

# 執行安裝
install_template