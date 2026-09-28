export default function ProfilePage() {
  return (
    <main className="page shell">
      <section className="card">
        <p className="eyebrow">Profile</p>
        <h1>Achievements</h1>
        <div className="stats-grid">
          <div className="stat-box">
            <span className="stat-label">Best streak</span>
            <strong>12 days</strong>
          </div>
          <div className="stat-box">
            <span className="stat-label">Completed units</span>
            <strong>1 / 5</strong>
          </div>
          <div className="stat-box">
            <span className="stat-label">Total points</span>
            <strong>310</strong>
          </div>
        </div>
      </section>
    </main>
  );
}
