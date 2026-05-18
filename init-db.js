// Cria _prisma_migrations vazio para que prisma migrate deploy rode sem P3005
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

prisma.$executeRawUnsafe(`
  CREATE TABLE IF NOT EXISTS "_prisma_migrations" (
    "id"                  VARCHAR(36)  NOT NULL,
    "checksum"            TEXT         NOT NULL,
    "finished_at"         TIMESTAMPTZ,
    "migration_name"      TEXT         NOT NULL,
    "logs"                TEXT,
    "rolled_back_at"      TIMESTAMPTZ,
    "started_at"          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    "applied_steps_count" INTEGER      NOT NULL DEFAULT 0,
    CONSTRAINT "_prisma_migrations_pkey" PRIMARY KEY ("id")
  )
`)
.then(() => { console.log('_prisma_migrations OK'); process.exit(0); })
.catch(e => { console.error('init-db error:', e.message); process.exit(0); });
