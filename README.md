# Gamified C Platform

A lightweight Next.js app for a C learning platform with a persistent student token linked to a hosted Postgres database.

## Provider choice
This scaffold is designed for Supabase Postgres because it gives a simple hosted Postgres experience with a very small setup footprint and excellent compatibility with the Stage 3 schema.

## Local setup
1. Copy `.env.example` to `.env.local`.
2. Add a hosted Postgres connection string, for example:
   `DATABASE_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT_REF].supabase.co:5432/postgres`
3. Run:
   - `npm install`
   - `npm run dev`

## Student identity flow
- On first visit, the app issues an opaque UUID stored in a `Student.platform_id` row.
- That token is persisted in a cookie on the client and also stored in the database as the source of truth.
- Subsequent visits resolve the token from the cookie and look up the matching student.
- No password auth is used for the platform identity layer.
