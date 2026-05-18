#!/bin/bash
set -e

export SERVER_PORT=${PORT:-8080}

# Usa schema 'evolution' para isolar tabelas do Prisma das tabelas Alembic (public)
BASE_URL=${DATABASE_CONNECTION_URI:-$DATABASE_URL}
export DATABASE_URL="${BASE_URL}?schema=evolution"

echo "==> Preparando migrations..."
rm -rf ./prisma/migrations
cp -r ./prisma/postgresql-migrations ./prisma/migrations

echo "==> Aplicando migrations no schema 'evolution'..."
npx prisma migrate deploy --schema ./prisma/postgresql-schema.prisma

echo "==> Iniciando Evolution API..."
npm run start:prod
