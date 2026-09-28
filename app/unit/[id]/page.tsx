export default function UnitPage({ params }: { params: { id: string } }) {
  return (
    <main className="page shell">
      <section className="card">
        <p className="eyebrow">Unit</p>
        <h1>{decodeURIComponent(params.id).replace(/-/g, ' ')}</h1>
        <p className="lead">Objectives, concept references, join contest prompt, and unit exercise list.</p>
        <div className="unit-actions">
          <a href="/exercise/1" className="button primary">Open first exercise</a>
        </div>
      </section>
    </main>
  );
}
