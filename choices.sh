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

# 從設定檔讀取模板資訊
get_template_info() {
    local template="$1"
    local info_type="$2"
    grep -A10 "^\[template:$template\]" "$CONFIG_FILE" | grep "^$info_type=" | head -n 1 | cut -d= -f2- | sed 's/^ *//;s/ *$//'
}

# 主要迴圈，允許使用者重複選擇
while true; do
    # 清理舊檔案
    rm -rf *.zip
    rm -rf html &> /dev/null
    sudo rm -rf /var/www/html/* &> /dev/null

    # 使用 dialog 建立選單，並將選擇結果存入變數 USE
    USE=$(dialog --title "＊.°· 請選擇想要的網站用途 ＊.°" --menu "\n可上下選擇:" 15 60 3 \
        1 "餐廳" \
        2 "攝影作品" \
        3 "房地產租售平台" \
        2>&1 >/dev/tty)

    clear  # 清除對話框

    # 如果使用者取消選擇或按 ESC，變數會是空的
    if [[ -z "$USE" ]]; then
        echo "未選擇任何選項，結束程式"
        exit 0
    fi

    # 檢查是否選擇退出
    if [[ "$USE" == "4" ]]; then
        echo "您選擇結束程式，謝謝使用！"
        exit 0
    fi

    # 根據選擇執行對應的程式
    case $USE in
        1)
            CATEGORY="餐廳"
            dialog --title "＊.°· 執行中 ＊.°· " --msgbox "\n您選擇的用途為『$CATEGORY』~" 10 40
            CHOICE=$(dialog --title "＊.°· 請選擇想要的網頁模板風格 ＊.°·" --menu "\n可上下選擇:" 15 50 3 \
                1 "餐酒館" \
                2 "咖啡廳" \
                3 "甜點店" \
                2>&1 >/dev/tty)

            clear  # 清除對話框

            # 如果使用者取消選擇或按 ESC，變數會是空的
            if [[ -z "$CHOICE" ]]; then
                echo "未選擇任何選項，返回主選單"
                continue
            fi

            # 根據選擇執行對應的程式
            case $CHOICE in
                1)
                    TEMPLATE_NAME="餐酒館"
                    TEMPLATE_ID="restaurant"
                    ;;
                2)
                    TEMPLATE_NAME="咖啡廳"
                    TEMPLATE_ID="antique_cafe"
                    ;;
                3)
                    TEMPLATE_NAME="甜點店"
                    TEMPLATE_ID="klassy_cafe"
                    ;;
                *)
                    echo "無效選項，返回主選單"
                    continue
                    ;;
            esac
            ;;
        2)
            CATEGORY="攝影作品"
            dialog --title "＊.°· 執行中 ＊.°· " --msgbox "\n您選擇的用途為『$CATEGORY』~" 10 40
            CHOICE=$(dialog --title "＊.°· 請選擇想要的網頁模板風格 ＊.°· " --menu "\n可上下選擇:" 15 50 3 \
                1 "婚紗攝影集" \
                2 "食物影像紀錄" \
                3 "攝影集網站設計" \
                2>&1 >/dev/tty)

            clear  # 清除對話框

            # 如果使用者取消選擇或按 ESC，變數會是空的
            if [[ -z "$CHOICE" ]]; then
                echo "未選擇任何選項，返回主選單"
                continue
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
                    echo "無效選項，返回主選單"
                    continue
                    ;;
            esac
            ;;
        3)
            CATEGORY="房地產租售平台"
            dialog --title "＊.°· 執行中 ＊.°· " --msgbox "\n您選擇的用途為『$CATEGORY』~" 10 40
            CHOICE=$(dialog --title "＊.°· 請選擇想要的網頁模板風格 ＊.°· " --menu "\n可上下選擇:" 15 50 3 \
                1 "極簡專業" \
                2 "商業高端" \
                3 "年輕親民" \
                2>&1 >/dev/tty)

            clear  # 清除對話框

            # 如果使用者取消選擇或按 ESC，變數會是空的
            if [[ -z "$CHOICE" ]]; then
                echo "未選擇任何選項，返回主選單"
                continue
            fi

            # 根據選擇執行對應的程式
            case $CHOICE in
                1)
                    TEMPLATE_NAME="極簡專業風格"
                    TEMPLATE_ID="simple"
                    ;;
                2)
                    TEMPLATE_NAME="商業高端風格"
                    TEMPLATE_ID="business"
                    ;;
                3)
                    TEMPLATE_NAME="年輕親民風格"
                    TEMPLATE_ID="young"
                    ;;
                *)
                    echo "無效選項，返回主選單"
                    continue
                    ;;
            esac
            ;;
        *)
            echo "無效選項，返回主選單"
            continue
            ;;
    esac

    # 取得模板資訊
    TEMPLATE_URL=$(get_template_info "$TEMPLATE_ID" "url")
    TEMPLATE_ZIP=$(get_template_info "$TEMPLATE_ID" "zip")
    TEMPLATE_DIR=$(get_template_info "$TEMPLATE_ID" "dir")

    # 檢查是否有效
    if [ -z "$TEMPLATE_URL" ] || [ -z "$TEMPLATE_ZIP" ] || [ -z "$TEMPLATE_DIR" ]; then
        dialog --title "錯誤" --msgbox "\n找不到模板 $TEMPLATE_ID 的相關資訊！" 8 40
        continue
    fi

    # 顯示選擇的模板
    dialog --title "＊.°· 執行中 ＊.°· " --msgbox "\n您想要的『$TEMPLATE_NAME』網站即將誕生 " 10 50

    # 調用安裝腳本
    if [ -f "$INSTALLER_SCRIPT" ]; then
        bash "$INSTALLER_SCRIPT" "$TEMPLATE_ID" "$TEMPLATE_URL" "$TEMPLATE_ZIP" "$TEMPLATE_DIR" "$TEMPLATE_NAME" "$SITE_NAME"
    else
        echo "錯誤：找不到腳本 $INSTALLER_SCRIPT，請確認文件是否存在。"
        exit 1
    fi

    # 詢問使用者是否要繼續安裝其他模板
    dialog --title "＊.°· 繼續安裝 ＊.°· " --yesno "\n是否要安裝其他網站模板？" 8 40
    CONTINUE=$?
    clear

    if [ $CONTINUE -ne 0 ]; then
        echo "感謝使用，程式結束！"
        exit 0
    fi
done