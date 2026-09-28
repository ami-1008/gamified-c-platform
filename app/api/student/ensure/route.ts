import { randomUUID } from 'crypto';
import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/app/lib/db';

async function createStudentResponse(token: string, studentName = 'Student') {
  if (!db) {
    return NextResponse.json({
      error: 'DATABASE_URL is not configured. Add a Postgres provider connection string in .env.local.'
    }, { status: 500 });
  }

  const result = await db.query(
    `
      INSERT INTO "Student" (platform_id, display_name)
      VALUES ($1, $2)
      ON CONFLICT (platform_id) DO NOTHING
      RETURNING id, platform_id, display_name
    `,
    [token, studentName]
  );

  const student = result.rows[0] ?? (await db.query(
    `SELECT id, platform_id, display_name FROM "Student" WHERE platform_id = $1 LIMIT 1`,
    [token]
  )).rows[0];

  const response = NextResponse.json({
    student_id: student.id,
    platform_id: student.platform_id,
    display_name: student.display_name,
    token
  });

  response.cookies.set('student_token', token, {
    httpOnly: true,
    sameSite: 'lax',
    path: '/',
    maxAge: 60 * 60 * 24 * 365
  });

  return response;
}

export async function GET(request: NextRequest) {
  const token = request.cookies.get('student_token')?.value;

  if (!token) {
    return createStudentResponse(randomUUID());
  }

  if (!db) {
    return NextResponse.json({
      error: 'DATABASE_URL is not configured. Add a Postgres provider connection string in .env.local.'
    }, { status: 500 });
  }

  const result = await db.query(
    `SELECT id, platform_id, display_name FROM "Student" WHERE platform_id = $1 LIMIT 1`,
    [token]
  );

  const student = result.rows[0];
  if (!student) {
    return createStudentResponse(randomUUID());
  }

  const response = NextResponse.json({
    student_id: student.id,
    platform_id: student.platform_id,
    display_name: student.display_name,
    token
  });

  response.cookies.set('student_token', token, {
    httpOnly: true,
    sameSite: 'lax',
    path: '/',
    maxAge: 60 * 60 * 24 * 365
  });

  return response;
}
