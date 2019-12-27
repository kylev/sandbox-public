.PHONY: package

package:
	pip install -t .package -r requirements.txt
	(cd .package ; zip -q9r lambda.zip .)

	zip -q9r lambda.zip opsbot
