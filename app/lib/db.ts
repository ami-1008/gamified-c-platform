import { Pool } from 'pg';

const connectionString = process.env.DATABASE_URL;

export const db = connectionString
  ? new Pool({
      connectionString,
      ssl: connectionString.includes('supabase') || connectionString.includes('neon')
        ? { rejectUnauthorized: false }
        : undefined
    })
  : null;
