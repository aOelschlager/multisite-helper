# Helper function to generate keys for the user to use in their docker-compose.env.yml
.PHONY: download-default-certs
.SILENT: download-default-certs
download-default-certs:
	mkdir -p certs
	if [ ! -f certs/cert.pem ]; then \
		curl http://traefik.me/fullchain.pem -o certs/cert.pem; \
	fi
	if [ ! -f certs/privkey.pem ]; then \
		curl http://traefik.me/privkey.pem -o certs/privkey.pem; \
	fi
