const units = [
  { title: 'Loops', status: 'in progress' },
  { title: 'Functions I', status: 'not started' },
  { title: 'Functions II', status: 'not started' },
  { title: 'Arrays', status: 'locked' },
  { title: 'Strings', status: 'locked' }
];

export default function LearningPathPage() {
  return (
    <main className="page shell">
      <section className="card">
        <p className="eyebrow">Learning path</p>
        <h1>Units</h1>
        <div className="unit-list">
          {units.map((unit) => (
            <a href={`/unit/${unit.title.toLowerCase().replace(/\s+/g, '-')}`} key={unit.title} className="unit-card">
              <div>
                <strong>{unit.title}</strong>
                <small>{unit.status}</small>
              </div>
              <span>→</span>
            </a>
          ))}
        </div>
      </section>
    </main>
  );
}
