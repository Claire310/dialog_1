# variable檔案說明

## 分支程式

```
html_install.sh
```

為 **選項** 的程式碼進行更動，主要更動部分：
1. 增加選項
2. 新增變數

## apache安裝

```
installapache.sh
```

為 **安裝apache** 的程式碼進行更動，主要更動部分：
1. 新增變數

## 變數檔案

```
htmls.conf
```

網站模板設定檔，為變數的保存位置。

格式說明：

1. [template:模板ID] - 定義一個模板
2. description=顯示名稱
3. url=下載URL
4. zip=ZIP檔名
5. dir=解壓縮後的目錄名稱