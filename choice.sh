#!/bin/bash

# 設定檔路徑
CONFIG_FILE="htmls.conf"
# 安裝腳本路徑
INSTALLER_SCRIPT="html_install.sh"

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

# 主題選單
THEME=$(dialog --title "網站用途" --menu "請選擇您想要的網站用途" 12 50 3 \
    1 "餐廳" \
    2 "攝影作品" \
    3 "房地產租售平台" \
    2>&1 >/dev/tty)

clear  # 清除對話框

# 如果使用者取消選擇或按 ESC，變數會是空的
if [[ -z "$THEME" ]]; then
    echo "未選擇任何選項，結束程式"
    exit 1
fi

while true; do
    # 根據選擇的主題提供對應的風格選單
    case $THEME in
        1)
            CATEGORY="餐廳"
            STYLE=$(dialog --title "風格選擇" --menu "請選擇您想要的網頁模板風格" 12 50 3 \
                1 "餐酒館" \
                2 "咖啡廳" \
                3 "甜點店" \
                2>&1 >/dev/tty)
            TEMPLATE_NAME=$(case $STYLE in 1) echo "餐酒館" ;; 2) echo "咖啡廳" ;; 3) echo "甜點店" ;; esac)
            TEMPLATE_ID=$(case $STYLE in 1) echo "browny" ;; 2) echo "grandcoffee" ;; 3) echo "drool" ;; esac)
            ;;
        2)
            CATEGORY="攝影作品"
            STYLE=$(dialog --title "風格選擇" --menu "請選擇您想要的網頁模板風格" 12 50 3 \
                1 "婚紗攝影集" \
                2 "食物影像紀錄" \
                3 "攝影集網站設計" \
                2>&1 >/dev/tty)
            TEMPLATE_NAME=$(case $STYLE in 1) echo "婚紗攝影集" ;; 2) echo "食物影像紀錄" ;; 3) echo "攝影集網站設計" ;; esac)
            TEMPLATE_ID=$(case $STYLE in 1) echo "photographer" ;; 2) echo "foodblog" ;; 3) echo "photosite" ;; esac)
            ;;
        3)
            CATEGORY="房地產租售平台"
            STYLE=$(dialog --title "風格選擇" --menu "請選擇您想要的網頁模板風格" 12 50 3 \
                1 "現代房地產網站" \
                2 "專業房屋仲介" \
                3 "豪宅展示網站" \
                2>&1 >/dev/tty)
            TEMPLATE_NAME=$(case $STYLE in 1) echo "現代房地產網站" ;; 2) echo "專業房屋仲介" ;; 3) echo "豪宅展示網站" ;; esac)
            TEMPLATE_ID=$(case $STYLE in 1) echo "realestate1" ;; 2) echo "realestate2" ;; 3) echo "realestate3" ;; esac)
            ;;
    esac

    clear  # 清除對話框

    # 如果使用者取消選擇或按 ESC，變數會是空的
    if [[ -z "$STYLE" ]]; then
        echo "未選擇任何選項，結束程式"
        exit 1
    fi

    # 讀取模板資訊
    get_template_info() {
        local template="$1"
        local info_type="$2"
        grep -A10 "^\[template:$template\]" "$CONFIG_FILE" | grep "^$info_type=" | cut -d= -f2- | sed 's/^ *//;s/ *$//'
    }

    # 取得模板資訊
    TEMPLATE_URL=$(get_template_info "$TEMPLATE_ID" "url")
    TEMPLATE_ZIP=$(get_template_info "$TEMPLATE_ID" "zip")
    TEMPLATE_DIR=$(get_template_info "$TEMPLATE_ID" "dir")

    # 檢查模板資訊
    if [ -z "$TEMPLATE_URL" ] || [ -z "$TEMPLATE_ZIP" ] || [ -z "$TEMPLATE_DIR" ]; then
        dialog --title "錯誤" --msgbox "\n找不到模板 $TEMPLATE_ID 的相關資訊！" 8 40
        exit 1
    fi

    # 顯示進度條
    (
        for i in $(seq 0 100); do
            sleep 0.05
            echo $i
        done
    ) | dialog --title "進度條" --gauge "正在準備安裝，請稍候..." 10 50 0

    # 執行安裝腳本並確保不會影響後續流程
    if [ -f "$INSTALLER_SCRIPT" ]; then
        bash "$INSTALLER_SCRIPT" "$TEMPLATE_ID" "$TEMPLATE_URL" "$TEMPLATE_ZIP" "$TEMPLATE_DIR" "$TEMPLATE_NAME"
        INSTALL_RESULT=$?
    else
        echo "錯誤：找不到腳本 $INSTALLER_SCRIPT，請確認文件是否存在。"
        exit 1
    fi

    # 確保安裝腳本執行成功，才顯示安裝完成訊息
    if [[ $INSTALL_RESULT -eq 0 ]]; then
        dialog --title "安裝完成" --msgbox "\n您的網站風格『$TEMPLATE_NAME』已安裝完成，請確認。" 10 50
    else
        dialog --title "安裝失敗" --msgbox "\n安裝過程中發生錯誤，請檢查日誌。" 10 50
        exit 1
    fi

    # 最終確認
    dialog --title "最終確認" --yesno "您的網站風格為『$TEMPLATE_NAME』。\n這是您想要的嗎？\n\n選擇 [是]：結束程式\n選擇 [否]：重新選擇風格" 12 50

    # 如果使用者選擇「是」，則結束
    if [[ $? -eq 0 ]]; then
        break
    fi

    # 否則，回到選擇風格的 while 迴圈
done

dialog --title "完成" --msgbox "\n感謝您的使用！程式結束。" 10 50
