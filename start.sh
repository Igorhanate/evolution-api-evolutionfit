#!/bin/bash
set -e

export SERVER_PORT=${PORT:-8080}
export DATABASE_URL=${DATABASE_CONNECTION_URI:-$DATABASE_URL}

# Encontra o diretório da Evolution API (tem prisma/postgresql-schema.prisma)
EVOL_DIR=""
for dir in /evolution /app /home/evolution /usr/src/app /srv; do
  if [ -f "$dir/prisma/postgresql-schema.prisma" ]; then
    EVOL_DIR="$dir"
    break
  fi
done

if [ -z "$EVOL_DIR" ]; then
  echo "ERRO: diretório da Evolution API não encontrado"
  exit 1
fi

echo "==> Evolution API em: $EVOL_DIR"
cd "$EVOL_DIR"

echo "==> Criando _prisma_migrations (evita P3005)..."
NODE_PATH="$EVOL_DIR/node_modules" node /init-db.js

echo "==> Preparando migrations..."
rm -rf ./prisma/migrations
cp -r ./prisma/postgresql-migrations ./prisma/migrations

echo "==> Aplicando migrations..."
npx prisma migrate deploy --schema ./prisma/postgresql-schema.prisma

echo "==> Iniciando Evolution API..."
npm run start:prod
