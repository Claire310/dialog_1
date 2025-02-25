NAME=$(dialog --title "資訊輸入框" --inputbox "你的名字:" 10 50 2>&1 >/dev/tty)

if [[ -z "$NAME" ]]; then
    echo "未輸入名稱，結束程式"
    exit 1
fi

SITENAME=$(dialog --title "網站設定" --inputbox "請輸入想要的網站名稱:" 10 50 2>&1 >/dev/tty)

if [[ -z "$SITENAME" ]]; then
    echo "未輸入網站名稱，結束程式"
    exit 1
fi

export SITE_NAME="$SITENAME"

dialog --title "歡迎光臨" --msgbox "\n$NAME，您好！這是我第一個Dialog專案，一起開啟Apache的世界吧！" 10 70
./choice.sh