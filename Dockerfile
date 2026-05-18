FROM atendai/evolution-api:v2.2.3

# Render injeta $PORT dinamicamente; Evolution API usa SERVER_PORT
# DATABASE_URL é o que o Prisma precisa; aceitamos DATABASE_CONNECTION_URI também
ENTRYPOINT ["/bin/bash", "-c", "\
  export SERVER_PORT=${PORT:-8080} && \
  export DATABASE_URL=${DATABASE_CONNECTION_URI:-$DATABASE_URL} && \
  . ./Docker/scripts/deploy_database.sh && \
  npm run start:prod"]
