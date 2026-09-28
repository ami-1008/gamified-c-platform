export default function DashboardPage() {
  return (
    <main className="page shell">
      <section className="card">
        <p className="eyebrow">Dashboard</p>
        <h1>Current unit</h1>
        <div className="stats-grid">
          <div className="stat-box">
            <span className="stat-label">Current streak</span>
            <strong>7 days</strong>
          </div>
          <div className="stat-box">
            <span className="stat-label">Points</span>
            <strong>310</strong>
          </div>
          <div className="stat-box">
            <span className="stat-label">Badges</span>
            <strong>4 earned</strong>
          </div>
        </div>
      </section>
    </main>
  );
}
