// Garante que _prisma_migrations existe e está VAZIO para que migrate deploy crie as tabelas
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

(async () => {
  await prisma.$executeRawUnsafe(`
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
  `);

  // Verifica se as tabelas da Evolution API existem
  const rows = await prisma.$queryRawUnsafe(`
    SELECT COUNT(*) AS cnt FROM information_schema.tables
    WHERE table_schema = 'public' AND table_name = 'Instance'
  `);
  const cnt = Number(rows[0]?.cnt ?? 0);

  if (cnt === 0) {
    // Tabelas não existem: limpa histórico de migrations para rodar tudo do zero
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE "_prisma_migrations"`);
    console.log('_prisma_migrations limpo — migrations vão criar as tabelas');
  } else {
    console.log('Tabelas Evolution API já existem — mantendo histórico');
  }
  process.exit(0);
})().catch(e => { console.error('init-db:', e.message); process.exit(0); });
