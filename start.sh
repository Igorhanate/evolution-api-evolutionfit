#!/bin/bash
set -e

export SERVER_PORT=${PORT:-8080}
export DATABASE_URL=${DATABASE_CONNECTION_URI:-$DATABASE_URL}

echo "==> Iniciando _prisma_migrations (evita P3005)..."
node /init-db.js

echo "==> Preparando migrations..."
rm -rf ./prisma/migrations
cp -r ./prisma/postgresql-migrations ./prisma/migrations

echo "==> Aplicando migrations..."
npx prisma migrate deploy --schema ./prisma/postgresql-schema.prisma

echo "==> Iniciando Evolution API..."
npm run start:prod
