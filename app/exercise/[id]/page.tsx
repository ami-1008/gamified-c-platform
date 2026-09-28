export default function ExercisePage({ params }: { params: { id: string } }) {
  return (
    <main className="page shell">
      <section className="card">
        <p className="eyebrow">Exercise</p>
        <h1>Exercise #{params.id}</h1>
        <p className="lead">Problem statement, hints, direct HackerRank link, and completion controls.</p>
        <div className="stack-row">
          <a href="/quiz/1" className="button primary">Preview quiz widget</a>
          <button className="button secondary" type="button">Mark complete</button>
        </div>
      </section>
    </main>
  );
}
