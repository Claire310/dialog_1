#!/bin/bash

# 檢查是否安裝 dialog
if ! command -v dialog &> /dev/null; then
    echo "錯誤：dialog 未安裝，請先執行 'sudo apt install dialog' 或 'sudo yum install dialog'"
    exit 1
fi

# 使用 dialog 建立選單，並將選擇結果存入變數 CHOICE
CHOICE=$(dialog --title "請選擇想要的網頁模板風格" --menu "可上下選擇" 10 50 3 \
    1 "海邊度假風" \
    2 "可愛動物風" \
    3 "文青風" \
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
        dialog --title "執行中" --msgbox "\n您想要的『海邊度假風』即將誕生~~" 10 37
        SCRIPT="./installapache.sh"
        ;;
    2)
        dialog --title "執行中" --msgbox "\n您想要的『可愛動物風』即將誕生~~" 10 37
        SCRIPT="./installapache_dog.sh"
        ;;
    3)
        dialog --title "執行中" --msgbox "\n您想要的『文青風』即將誕生~~" 10 37
        SCRIPT="./installapache_coffee.sh"
        ;;
    *)
        echo "無效選項，結束程式"
        exit 1
        ;;
esac

# 顯示進度條
(
    for i in $(seq 0 100); do
        sleep 0.05
        echo $i
    done
) | dialog --title "進度條" --gauge "正在執行，請稍候..." 10 50 0

# 檢查腳本是否存在
if [[ -f "$SCRIPT" ]]; then
    bash "$SCRIPT"
else
    echo "錯誤：找不到腳本 $SCRIPT，請確認文件是否存在。"
    exit 1
fi
