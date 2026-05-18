FROM atendai/evolution-api:v2.2.3

COPY init-db.js /init-db.js
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
