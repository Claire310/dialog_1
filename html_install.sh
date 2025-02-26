#!/bin/bash

# 設定檔路徑
CONFIG_FILE="htmls.conf"
# 安裝腳本路徑
INSTALLER_SCRIPT="installapache.sh"

# 檢查是否已安裝 dialog
if ! command -v dialog &> /dev/null; then
    echo "錯誤：dialog 未安裝，請先執行 'sudo apt install dialog' 或 'sudo yum install dialog'"
    exit 1
fi

# 檢查檔案是否存在
if [ ! -f "$CONFIG_FILE" ]; then
    echo "錯誤：找不到設定檔 $CONFIG_FILE"
    exit 1
fi

if [ ! -f "$INSTALLER_SCRIPT" ]; then
    echo "錯誤：找不到安裝腳本 $INSTALLER_SCRIPT"
    exit 1
fi

# 使用 dialog 建立選單，並將選擇結果存入變數 USE
USE=$(dialog --title "網站用途" --menu "請選擇您想要的網站用途，可上下選擇" 10 50 3 \
    1 "餐廳" \
    2 "攝影作品" \
    3 "房地產租售平台" \
    2>&1 >/dev/tty)

clear  # 清除對話框

# 如果使用者取消選擇或按 ESC，變數會是空的
if [[ -z "$USE" ]]; then
    echo "未選擇任何選項，結束程式"
    exit 1
fi

# 根據選擇執行對應的程式
case $USE in
    1)
        CATEGORY="餐廳"
        dialog --title "執行中" --msgbox "\n您選擇的用途為『$CATEGORY』~~" 10 37
        CHOICE=$(dialog --title "風格選擇" --menu "請選擇您想要的網頁模板風格，可上下選擇" 10 50 3 \
            1 "餐酒館" \
            2 "咖啡廳" \
            3 "甜點店" \
            2>&1 >/dev/tty)

        clear  # 清除對話框

        # 如果使用者取消選擇或按 ESC，變數會是空的
        if [[ -z "$CHOICE" ]]; then
            echo "未選擇任何選項，結束程式"
            exit 1
        fi

        # 根據選擇執行對應的程式
        case $CHOICE in
            1)
                TEMPLATE_NAME="餐酒館"
                TEMPLATE_ID="browny"
                ;;
            2)
                TEMPLATE_NAME="咖啡廳"
                TEMPLATE_ID="grandcoffee"
                ;;
            3)
                TEMPLATE_NAME="甜點店"
                TEMPLATE_ID="drool"
                ;;
            *)
                echo "無效選項，結束程式"
                exit 1
                ;;
        esac
        ;;
    2)
        CATEGORY="攝影作品"
        dialog --title "執行中" --msgbox "\n您選擇的用途為『$CATEGORY』~~" 10 37
        CHOICE=$(dialog --title "風格選擇" --menu "請選擇您想要的網頁模板風格，可上下選擇" 10 50 3 \
            1 "婚紗攝影集" \
            2 "食物影像紀錄" \
            3 "攝影集網站設計" \
            2>&1 >/dev/tty)

        clear  # 清除對話框

        # 如果使用者取消選擇或按 ESC，變數會是空的
        if [[ -z "$CHOICE" ]]; then
            echo "未選擇任何選項，結束程式"
            exit 1
        fi

        # 根據選擇執行對應的程式
        case $CHOICE in
            1)
                TEMPLATE_NAME="婚紗攝影集"
                TEMPLATE_ID="photographer"
                ;;
            2)
                TEMPLATE_NAME="食物影像紀錄"
                TEMPLATE_ID="foodblog"
                ;;
            3)
                TEMPLATE_NAME="攝影集網站設計"
                TEMPLATE_ID="photosite"
                ;;
            *)
                echo "無效選項，結束程式"
                exit 1
                ;;
        esac
        ;;
    3)
        CATEGORY="買房"
        dialog --title "執行中" --msgbox "\n您選擇的用途為『$CATEGORY』~~" 10 37
        CHOICE=$(dialog --title "風格選擇" --menu "請選擇您想要的網頁模板風格，可上下選擇" 10 50 3 \
            1 "現代房地產網站" \
            2 "專業房屋仲介" \
            3 "豪宅展示網站" \
            2>&1 >/dev/tty)

        clear  # 清除對話框

        # 如果使用者取消選擇或按 ESC，變數會是空的
        if [[ -z "$CHOICE" ]]; then
            echo "未選擇任何選項，結束程式"
            exit 1
        fi

        # 根據選擇執行對應的程式
        case $CHOICE in
            1)
                TEMPLATE_NAME="現代房地產網站"
                TEMPLATE_ID="realestate1"
                ;;
            2)
                TEMPLATE_NAME="專業房屋仲介"
                TEMPLATE_ID="realestate2"
                ;;
            3)
                TEMPLATE_NAME="豪宅展示網站"
                TEMPLATE_ID="realestate3"
                ;;
            *)
                echo "無效選項，結束程式"
                exit 1
                ;;
        esac
        ;;
    *)
        echo "無效選項，結束程式"
        exit 1
        ;;
esac

# 從設定檔讀取模板資訊
get_template_info() {
    local template="$1"
    local info_type="$2"
    grep -A10 "^\[template:$template\]" "$CONFIG_FILE" | grep "^$info_type=" | cut -d= -f2- | sed 's/^ *//;s/ *$//'
}

# 取得模板資訊
TEMPLATE_URL=$(get_template_info "$TEMPLATE_ID" "url")
TEMPLATE_ZIP=$(get_template_info "$TEMPLATE_ID" "zip")
TEMPLATE_DIR=$(get_template_info "$TEMPLATE_ID" "dir")

# 檢查是否有效
if [ -z "$TEMPLATE_URL" ] || [ -z "$TEMPLATE_ZIP" ] || [ -z "$TEMPLATE_DIR" ]; then
    dialog --title "錯誤" --msgbox "\n找不到模板 $TEMPLATE_ID 的相關資訊！" 8 40
    exit 1
fi

# 顯示選擇的模板
dialog --title "執行中" --msgbox "\n您想要的『$TEMPLATE_NAME』網站即將誕生~~" 10 37

# 顯示假進度條（模擬載入效果）
(
    for i in $(seq 0 100); do
        sleep 0.05
        echo $i
    done
) | dialog --title "進度條" --gauge "正在準備安裝，請稍候..." 10 50 0

# 調用安裝腳本
if [ -f "$INSTALLER_SCRIPT" ]; then
    bash "$INSTALLER_SCRIPT" "$TEMPLATE_ID" "$TEMPLATE_URL" "$TEMPLATE_ZIP" "$TEMPLATE_DIR" "$TEMPLATE_NAME"
else
    echo "錯誤：找不到腳本 $INSTALLER_SCRIPT，請確認文件是否存在。"
    exit 1
fi