FROM atendai/evolution-api:v2.2.3

# Copia script de baseline antes de iniciar
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
