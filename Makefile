#
# Firefox/Chrome用 廃れるバックグラウンド拡張機能
#
js:
	coffee -c sutare.coffee

#
# Firefox拡張機能用のxpiを作る
#
XPIFILES=manifest.json sutare.js jquery-2.1.4.min.js privacy.html
xpi: js
	/bin/rm -f sutare.xpi
	zip -r sutare.xpi ${XPIFILES}

#
# Chromeエクステンション公開用のzipを作る
#
ZIPFILES=manifest.json sutare.js jquery-2.1.4.min.js icons/sutare-48.png icons/sutare-96.png
zip: js
	/bin/rm -f sutare.zip
	zip -r sutare.zip ${ZIPFILES}

# Firefox拡張機能を署名する
# manifest.json中のバージョン番号を更新してから動かすこと
#
# 審査してもらうときこれでうまくいくのか不明...
#
sign: xpi
	web-ext sign --api-key $(MOZILLA_USER) --api-secret $(MOZILLA_SECRET)
	/bin/cp web-ext-artifacts/`ls -1 -t web-ext-artifacts | head -1` sutare.xpi

clean:
	/bin/rm -f *~
	/bin/rm -f sutare.js
	/bin/rm -f sutare.xpi
	/bin/rm -f sutare.zip
	/bin/rm -f sutare.crx
