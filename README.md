# Apache 網站安裝工具

這是一個基於 dialog 的互動式網站安裝工具，可以讓使用者快速安裝並客製化 Apache 網站。

## 功能特色

1. 互動式操作界面
2. 三種網站風格選擇：
   - 海邊度假風
   - 可愛動物風
   - 文青咖啡風
3. 支援網站標題客製化
4. 即時進度顯示
5. 完整的安裝與移除功能

## 檔案說明

- `mydialog.sh`: 主程式入口，處理使用者名稱與網站標題輸入
- `choice.sh`: 網站風格選擇介面
- `installapache.sh`: 海邊度假風網站安裝腳本
- `installapache_dog.sh`: 可愛動物風網站安裝腳本
- `installapache_coffee.sh`: 文青咖啡風網站安裝腳本
- `removeapache.sh`: Apache 移除工具

## 使用方式

1. 確保系統已安裝 dialog：
   ```bash
   sudo apt install dialog
   ```

2. 執行主程式：
   ```bash
   ./mydialog.sh
   ```

3. 依照提示輸入：
   - 使用者名稱
   - 自訂網站標題

4. 選擇喜愛的網站風格

5. 等待安裝完成

## 移除方式

如果要移除網站，執行：
```bash
./removeapache.sh
```

## 系統需求

- Ubuntu/Debian 作業系統
- dialog 套件
- Apache2
- 網路連線（用於下載模板）

## 注意事項

1. 需要 root 權限安裝 Apache
2. 會覆蓋 /var/www/html 目錄下的檔案
3. 請確保有穩定的網路連線