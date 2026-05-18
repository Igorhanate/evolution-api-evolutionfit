#!/bin/bash
set -e

export SERVER_PORT=${PORT:-8080}
export DATABASE_URL=${DATABASE_CONNECTION_URI:-$DATABASE_URL}

echo "==> Preparando migrations..."
rm -rf ./prisma/migrations
cp -r ./prisma/postgresql-migrations ./prisma/migrations

echo "==> Aplicando baseline nas migrations existentes..."
for dir in ./prisma/migrations/*/; do
  if [ -d "$dir" ]; then
    name=$(basename "$dir")
    npx prisma migrate resolve --applied "$name" \
      --schema ./prisma/postgresql-schema.prisma 2>/dev/null || true
  fi
done

echo "==> Rodando migrate deploy..."
npx prisma migrate deploy --schema ./prisma/postgresql-schema.prisma 2>&1 || true

echo "==> Iniciando Evolution API..."
npm run start:prod
