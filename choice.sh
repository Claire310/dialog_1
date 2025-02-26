#!/bin/bash

# 檢查是否安裝 dialog
if ! command -v dialog &> /dev/null; then
    echo "錯誤：dialog 未安裝，請先執行 'sudo apt install dialog' 或 'sudo yum install dialog'"
    exit 1
fi

# 主題選單
THEME=$(dialog --title "請選擇主題" --menu "請選擇您想要的網站主題" 12 50 3 \
    1 "餐廳" \
    2 "攝影作品" \
    3 "房地產租售平台" \
    2>&1 >/dev/tty)

clear  # 清除對話框

# 如果使用者取消選擇或按 ESC，變數會是空的
if [[ -z "$THEME" ]]; then
    echo "未選擇任何主題，結束程式"
    exit 1
fi

while true; do
    # 根據選擇的主題提供對應的風格選單
    case $THEME in
        1)
            STYLE=$(dialog --title "請選擇風格" --menu "請選擇餐廳網站的風格" 12 50 3 \
                1 "餐酒館" \
                2 "咖啡廳" \
                3 "甜點店" \
                2>&1 >/dev/tty)
            STYLE_NAME=$(case $STYLE in 1) echo "餐酒館" ;; 2) echo "咖啡廳" ;; 3) echo "甜點店" ;; esac)
            ;;
        2)
            STYLE=$(dialog --title "請選擇風格" --menu "請選擇攝影作品網站的風格" 12 50 3 \
                1 "婚禮網站" \
                2 "餐飲品牌" \
                3 "作品集展示" \
                2>&1 >/dev/tty)
            STYLE_NAME=$(case $STYLE in 1) echo "婚禮網站" ;; 2) echo "餐飲品牌" ;; 3) echo "作品集展示" ;; esac)
            ;;
        3)
            STYLE=$(dialog --title "請選擇風格" --menu "請選擇房地產租售平台的風格" 12 50 3 \
                1 "極簡專業" \
                2 "商業高端" \
                3 "年輕親民" \
                2>&1 >/dev/tty)
            STYLE_NAME=$(case $STYLE in 1) echo "極簡專業" ;; 2) echo "商業高端" ;; 3) echo "年輕親民" ;; esac)
            ;;
    esac

    clear  # 清除對話框

    # 如果使用者取消選擇或按 ESC，變數會是空的
    if [[ -z "$STYLE" ]]; then
        echo "未選擇任何風格，結束程式"
        exit 1
    fi

    # 執行選擇後的提示
    dialog --title "執行中" --msgbox "\n您想要的『$STYLE_NAME』即將誕生~~" 10 37

    # 這裡可以根據不同的主題與風格選擇對應的腳本
    SCRIPT="./installapache.sh"

    # 顯示進度條
    (
        for i in $(seq 0 100); do
            sleep 0.05
            echo $i
        done
    ) | dialog --title "進度條" --gauge "正在執行，請稍候..." 10 50 0

    # 檢查腳本是否存在，並執行
    if [[ -f "$SCRIPT" ]]; then
        bash "$SCRIPT"
    else
        echo "錯誤：找不到腳本 $SCRIPT，請確認文件是否存在。"
        exit 1
    fi

    # 執行完畢提示
    dialog --title "執行結束" --msgbox "\n請確認是否為您想要的風格！" 10 70

    # **執行結束後再讓使用者確認是否為想要的風格**
    dialog --title "最終確認" --yesno "您選擇的風格是『$STYLE_NAME』，結果符合您的預期嗎？\n\n選擇 [是]：結束程式\n選擇 [否]：返回重新選擇風格" 12 50

    # 如果使用者選擇 "是" (exit code 0)，則結束程式
    if [[ $? -eq 0 ]]; then
        break
    fi

    # 否則，回到風格選擇的 while 迴圈
done

dialog --title "完成" --msgbox "\n感謝您的使用！程式結束。" 10 50