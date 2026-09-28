import './globals.css';
import type { Metadata } from 'next';
import { AppShell } from '@/app/components/AppShell';
import { StudentIdentityBootstrap } from '@/app/components/StudentIdentityBootstrap';

export const metadata: Metadata = {
  title: 'Gamified C Learning Platform',
  description: 'Course platform for C learning, HackerRank flow, and gamification'
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <StudentIdentityBootstrap />
        <AppShell>{children}</AppShell>
      </body>
    </html>
  );
}
