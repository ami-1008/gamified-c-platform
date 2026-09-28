import React from 'react';

export default function QuizPage({ params }: { params: { exerciseId: string } }) {
  return React.createElement(
    'main',
    { className: 'page shell' },
    React.createElement(
      'section',
      { className: 'card quiz-card' },
      React.createElement('p', { className: 'eyebrow' }, 'Quiz widget'),
      React.createElement('h1', null, `Dry-run question #${params.exerciseId}`),
      React.createElement(
        'div',
        { className: 'quiz-box' },
        React.createElement('pre', null, 'for (int i = 0; i < 3; i++) { printf("%d ", i); }'),
        React.createElement(
          'ul',
          null,
          React.createElement('li', null, '0 1 2'),
          React.createElement('li', null, '1 2 3'),
          React.createElement('li', null, '0 1 2 3'),
          React.createElement('li', null, '1 0 1')
        )
      )
    )
  );
}
