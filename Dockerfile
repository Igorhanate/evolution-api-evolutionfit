FROM atendai/evolution-api:v2.2.3

# Render injeta $PORT; Evolution API usa SERVER_PORT
# Usa db push em vez de migrate deploy para lidar com schema existente sem histórico de migrations
ENTRYPOINT ["/bin/bash", "-c", "\
  export SERVER_PORT=${PORT:-8080} && \
  export DATABASE_URL=${DATABASE_CONNECTION_URI:-$DATABASE_URL} && \
  echo 'Sincronizando schema do banco...' && \
  rm -rf ./prisma/migrations && \
  cp -r ./prisma/postgresql-migrations ./prisma/migrations && \
  npx prisma db push --schema ./prisma/postgresql-schema.prisma --skip-generate 2>&1 && \
  npm run start:prod"]
