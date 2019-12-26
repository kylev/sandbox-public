.PHONY: package

package:
	pip install -t .package -r requirements.txt
	pip install -t .package .
	(cd .package ; zip -q9r ~/lambda.zip .)

	zip -q9r ~/lambda.zip opsbot
