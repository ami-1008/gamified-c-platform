export default function LandingPage() {
  return (
    <main className="page shell">
      <section className="card hero">
        <p className="eyebrow">CS U111 • Computational Thinking and Programming</p>
        <h1>Learn by doing.</h1>
        <p className="lead">
          Practice loops, functions, arrays, and strings with HackerRank-backed exercises and a
          lightweight gamified learning flow.
        </p>
        <div className="stack-row">
          <a href="/dashboard" className="button primary">Start</a>
          <a href="/onboarding" className="button secondary">HackerRank onboarding</a>
        </div>
      </section>
    </main>
  );
}
