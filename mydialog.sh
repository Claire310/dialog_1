NAME=$(dialog --title "＊.°·˚歡迎光臨 架站小幫手＊.°·˚" --inputbox "\n請輸入你的名字: " 10 50 2>&1 >/dev/tty)

if [[ -z "$NAME" ]]; then
    echo "未輸入名稱，結束程式"
    exit 1
fi

SITENAME=$(dialog --title "＊.°·˚ 網站設定 *｡＊.°" --inputbox "\n請輸入想要的網站名稱: " 10 60 2>&1 >/dev/tty)

if [[ -z "$SITENAME" ]]; then
    echo "未輸入網站名稱，結束程式"
    exit 1
fi

export SITE_NAME="$SITENAME"

dialog --title "＊.°· 歡迎光臨 ＊.°·＊ " --msgbox "\n $NAME，您好！\n\n我是你的架站小幫手！" 10 70
./choices.sh
dialog --title "＊.°· 執行結束 ＊.°·＊ " --msgbox "\n恭喜 $NAME 有屬於自己的網頁了！\n\n感謝您的使用 ！" 10 60