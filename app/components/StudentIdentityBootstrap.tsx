'use client';

import { useEffect } from 'react';

export function StudentIdentityBootstrap() {
  useEffect(() => {
    fetch('/api/student/ensure', { credentials: 'include' }).catch(() => {
      // Silent fail: the app can still render while the DB is being configured or when offline.
    });
  }, []);

  return null;
}
