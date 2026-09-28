const steps = [
  'Join the unit contest once on HackerRank.',
  'Open the direct challenge links from the platform.',
  'Submit code and check all tests pass.',
  'Return to the platform and mark complete.',
  'Answer the first-try prompt honestly.'
];

export default function OnboardingPage() {
  return (
    <main className="page shell">
      <section className="card">
        <p className="eyebrow">HackerRank onboarding</p>
        <h1>How it works</h1>
        <ol className="steps">
          {steps.map((step, index) => (
            <li key={step}>{index + 1}. {step}</li>
          ))}
        </ol>
      </section>
    </main>
  );
}
