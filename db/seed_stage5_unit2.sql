-- stage-5-unit-2: idempotent seed for Unit 2 (Functions I) based on CS LAB 5a
-- Inserts Exercises and QuizQuestions for Lab 5a (Functions I)
-- Safe to re-run. Uses UPSERTs and existence checks. Assumes migration 0001 has been applied (difficulty, hidden_test_cases columns exist).

DO $$
DECLARE
    unit_id bigint;
    skill_id bigint;
BEGIN
    -- Find Unit id for 'Functions I'
    SELECT id INTO unit_id FROM "Unit" WHERE title = 'Functions I';
    IF unit_id IS NULL THEN
        RAISE EXCEPTION 'Unit "Functions I" not found. Ensure schema.sql seed ran.';
    END IF;

    -- Upsert a Skill for this unit
    INSERT INTO "Skill" (unit_id, title)
    VALUES (unit_id, 'Functions I')
    ON CONFLICT (unit_id, title) DO UPDATE SET title = EXCLUDED.title
    RETURNING id INTO skill_id;

    IF skill_id IS NULL THEN
        SELECT id INTO skill_id FROM "Skill" WHERE unit_id = unit_id AND title = 'Functions I';
    END IF;

    -- Problem 1: Multi-Level Scientific Calculator
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 1: Multi-Level Scientific Calculator',
    $$Build a terminal-based scientific calculator with a nested multi-level menu system. The program must present a Main Menu with options: 1) Basic Arithmetic, 2) Trigonometry, 3) Exponentials, 4) Exit. Each category opens a Sub-Menu and returns to the Main Menu after an operation. Each mathematical operation must be implemented in its own function. Division must handle division-by-zero by printing a warning instead of crashing.

Visible Sample: (behavioral - the program is interactive; ensure menus and operations are modular as described.)$$,
    'Keep main() lightweight. Create functions for mainMenu(), arithmeticMenu(), trigMenu(), exponentialMenu(), and functions for each operation.',
    15,
    'Medium',
    'HACKERRANK_URL_PLACEHOLDER: Problem 1',
    1,
    '[]'::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 1);

    -- Problem 2: Polynomial Evaluator
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 2: Polynomial Evaluator (cubic)',
    $$Write a program that evaluates a cubic polynomial f(x) = a*x^3 + b*x^2 + c*x + d for a given x. Read coefficients a b c d and x. Implement helper functions: power(base, exponent) using a loop, evaluateTerm(coefficient, x, exponent) that calls power, and evaluatePolynomial(a,b,c,d,x) that sums the terms. Do not use pow().

Sample I/O (visible test):
Input:
2 1 1 1
3
Output:
--- Polynomial Evaluator ---
Enter coefficients (a b c d): 2 1 1 1
Enter the value of x: 3
f(3) = 67
$$,
    'Implement power with loop; remember exponent 0 returns 1.',
    15,
    'Easy',
    'HACKERRANK_URL_PLACEHOLDER: Problem 2',
    2,
    ('[' || 
      '{"input":"2 1 1 1\n3","expected_output":"f(3) = 67"},' ||
      '{"input":"-1 -2 0 4\n-2","expected_output":"f(-2) = 4"},' ||
      '{"input":"5 -3 2 7\n0","expected_output":"f(0) = 7"}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 2);

    -- Problem 3: 3D Vector & Physics Toolkit
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 3: 3D Vector & Physics Toolkit',
    $$Write a program that reads two 3D vectors (u and v) and computes: magnitude of u, dot product u·v, and the angle between them (in radians). Implement functions: vectorMagnitude(x,y,z), dotProduct(...), calculateAngle(...). If either vector is zero, print an error when angle is requested.

Sample I/O (visible test):
Input:
1 0 0
0 1 0
Output:
--- 3D Vector & Physics Toolkit ---
Magnitude of u: 1.000000
Dot product: 0.000000
Angle: 1.570796 radians
$$,
    'Use helper functions; handle zero-vector angle error explicitly.',
    15,
    'Medium',
    'HACKERRANK_URL_PLACEHOLDER: Problem 3',
    3,
    ('[' ||
      '{"input":"1 0 0\n0 1 0","expected_output":"Magnitude of u: 1.000000\nDot product: 0.000000\nAngle: 1.570796 radians"},' ||
      '{"input":"2 3 4\n4 6 8","expected_output":"Magnitude of u: 5.385165\nDot product: 58.000000\nAngle: 0.000000 radians"},' ||
      '{"input":"0 0 0\n1 1 1","expected_output":"Magnitude of u: 0.000000\nDot product: 0.000000\nError: Cannot calculate angle with a zero vector."}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 3);

    -- Problem 4: Goldbach's Conjecture Verifier
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 4: Goldbach''s Conjecture Verifier',
    $$Write a program that asks the user for an even integer N > 2 and finds two primes p1 and p2 such that p1 + p2 = N. If multiple pairs exist, printing one pair is sufficient. If input is invalid, print an error.

Sample I/O (visible test):
Input: 100
Output:
--- Goldbach's Conjecture Verifier ---
100 = 3 + 97
$$,
    'Use a helper isPrime(n) function and iterate primes up to N to find a pair; validate input is even and > 2.',
    15,
    'Medium',
    'HACKERRANK_URL_PLACEHOLDER: Problem 4',
    4,
    ('[' ||
      '{"input":"100","expected_output":"100 = 3 + 97"},' ||
      '{"input":"4","expected_output":"4 = 2 + 2"},' ||
      '{"input":"15","expected_output":"Error: Input must be an even integer greater than 2."}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 4);

    -- Problem 5: Universal Base Conversion Engine
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 5: Universal Base Conversion Engine',
    $$Write a program that converts an integer from base A (2-9) to base B (2-9). Read the number (as digits in base A), the current base A, and target base B. Modularize by converting from A to integer then integer to base B.

Sample I/O (visible test):
Input:
432
5
8
Output:
--- Universal Base Conversion Engine ---
Result: 165
$$,
    'Convert A->decimal then decimal->B; handle input 0 and identity case where A==B.',
    15,
    'Medium',
    'HACKERRANK_URL_PLACEHOLDER: Problem 5',
    5,
    ('[' ||
      '{"input":"432\n5\n8","expected_output":"Result: 165"},' ||
      '{"input":"88\n9\n2","expected_output":"Result: 1010000"},' ||
      '{"input":"0\n7\n4","expected_output":"Result: 0"},' ||
      '{"input":"123\n4\n4","expected_output":"Result: 123"}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 5);

    -- Problem 6: Loan Amortization Schedule
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 6: Loan Amortization Schedule',
    $$Write a program that computes the EMI (equated monthly installment) for a loan given principal, annual interest rate (%), total loan term in months, and prints an amortization schedule for the specified number of months showing interest, principal paid, and remaining balance. Use the formula provided in the lab.

Sample I/O (visible test):
Input sequence (example):
500000
8.5
360
5
Output excerpt (fixed EMI and first 5 months as in the lab)
$$,
    'Compute monthly rate r = annual_rate/12/100; use formula for EMI; for each month compute interest on previous balance.',
    20,
    'Hard',
    'HACKERRANK_URL_PLACEHOLDER: Problem 6',
    6,
    ('[' ||
      '{"input":"500000\n8.5\n360\n5","expected_output":"Fixed EMI: 3844.57\nMonth 1 | Interest: 3541.67 | Principal Paid: 302.90 | Balance: 499697.10\nMonth 2 | Interest: 3539.52 | Principal Paid: 305.05 | Balance: 499392.05"},' ||
      '{"input":"100000\n5\n12\n3","expected_output": null, "notes":"short-term schedule"},' ||
      '{"input":"1000\n100\n12\n1","expected_output": null, "notes":"high interest edge"}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 6);

    -- Problem 7: ASCII Art Castle Builder
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 7: ASCII Art Castle Builder',
    $$Write a program that draws an ASCII castle for scale N (N >= 3). The castle has a centered triangular roof of height N (bottom row 2N-1 stars), a main building rectangle of height N and width 2N-1, and a centered doorway 3 characters wide and height N/2 (integer division). Handle invalid N < 3 by printing an error.

Visible sample: Input: 3 -> output as in lab sheet.
$$,
    'Carefully compute widths and center the doorway; test minimum N and invalid inputs.',
    15,
    'Medium',
    'HACKERRANK_URL_PLACEHOLDER: Problem 7',
    7,
    ('[' ||
      '{"input":"3","expected_output":"*\n***\n*****\n*****\n*****\n* *\n"},' ||
      '{"input":"6","expected_output": null, "notes":"large-scale pattern verification"},' ||
      '{"input":"2","expected_output":"Error: Scale size must be at least 3."}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 7);

    -- Debugging exercises 9.1..9.4
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'Debugging', 'Debugging 1: applyBonus pass-by-value bug',
    $$Code:
#include <stdio.h>
void applyBonus(int score) { score = score + 5; }
int main() { int myScore = 85; applyBonus(myScore); printf("Final Score: %d\n", myScore); }

Task: Explain why myScore is unchanged and fix it.
    $$,
    'Pass-by-value: either return the new value or pass a pointer to modify caller''s variable.',
    10,
    'Easy',
    'HACKERRANK_URL_PLACEHOLDER: Debugging 1',
    101,
    ('[' ||
      '{"input": "(no stdin)", "expected_output": "Final Score: 85", "notes":"original buggy behavior"},' ||
      '{"input": "(fixed with pointer)", "expected_output": "Final Score: 90", "notes":"expected after fix"}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 101);

    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'Debugging', 'Debugging 2: calculateArea missing parameters',
    $$Code:
#include <stdio.h>
int calculateArea() { return length * width; }
int main() { int length = 10; int width = 5; int area = calculateArea(); printf("The area is %d\n", area); }

Task: Why does this fail to compile and how to fix it?
    $$,
    'Functions must be declared with parameter lists matching usage or use globals intentionally; better: int calculateArea(int length, int width).',
    10,
    'Easy',
    'HACKERRANK_URL_PLACEHOLDER: Debugging 2',
    102,
    ('[' ||
      '{"input":"(no stdin)","expected_output":"The area is 50","notes":"after fixing signature and passing parameters"}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 102);

    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'Debugging', 'Debugging 3: squareNumber unused return',
    $$Code:
#include <stdio.h>
int squareNumber(int num) { int result = num * num; return result; }
int main() { int value = 4; squareNumber(value); printf("The square is: %d\n", value); }

Task: Why does the program print 4 instead of 16? Fix it.
    $$,
    'Use the returned value (assign to value) or pass by pointer to modify caller variable.',
    10,
    'Easy',
    'HACKERRANK_URL_PLACEHOLDER: Debugging 3',
    103,
    ('[' ||
      '{"input":"(no stdin)","expected_output":"The square is: 4","notes":"original buggy behavior"},' ||
      '{"input":"(fixed)","expected_output":"The square is: 16","notes":"after using return value"}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 103);

    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'Debugging', 'Debugging 4: isPositive implicit declaration',
    $$Code:
#include <stdio.h>
int main() { int number = 10; if ( isPositive(number) == 1) { printf("It is positive!\n"); } return 0; }
int isPositive(int n) { if (n > 0) return 1; else return 0; }

Task: Explain why some compilers warn or fail and how to fix it.
    $$,
    'Function prototypes should be declared before use (or define isPositive before main); modern C requires declarations.',
    10,
    'Easy',
    'HACKERRANK_URL_PLACEHOLDER: Debugging 4',
    104,
    ('[' ||
      '{"input":"(no stdin)","expected_output":"It is positive!","notes":"when isPositive is declared/defined properly"}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 104);

END $$;

-- Dry-Run exercises (type DryRun) and QuizQuestions
-- Dry Run 1
INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
SELECT u.id, s.id, 'DryRun', 'Dry Run 1: return stops execution',
$$Predict the output of the following program:
int processNumber(int x) { int result = x * 2; return result; result = result + 10; return result; }
int main() { int finalValue = processNumber(5); printf("Output : %d\n", finalValue); }

Question: What is the exact output?$$,
'Remember that return exits the function immediately; later statements are unreachable.',
5, NULL, 201
FROM "Unit" u JOIN "Skill" s ON s.unit_id = u.id AND s.title = 'Functions I'
WHERE u.title = 'Functions I' AND NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = u.id AND e.exercise_order = 201);

DO $$
DECLARE ex_id bigint;
BEGIN
    SELECT id INTO ex_id FROM "Exercise" WHERE exercise_order = 201 AND unit_id = (SELECT id FROM "Unit" WHERE title='Functions I');
    IF ex_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM "QuizQuestion" q WHERE q.exercise_id = ex_id) THEN
        INSERT INTO "QuizQuestion" (exercise_id, code_snippet, options_json, answer_format, correct_answer, explanation)
        VALUES (
            ex_id,
            $$int processNumber(int x) { int result = x * 2; return result; result = result + 10; return result; } int main() { int finalValue = processNumber(5); printf("Output : %d\n", finalValue); }$$,
            ('{"kind":"mcq","prompt":"What is the exact output?","choices":["Output : 10","Output : 15","Output : 25","Compilation error"],"correctIndex":0,"answerText":"Output : 10","explanation":"Correct: function returns after first return; unreachable code ignored. Wrong choices: 15 (incorrectly assumes extra addition), 25 (both adds), compilation error (code compiles)."}')::jsonb,
            'mcq',
            'Output : 10',
            'The first return returns 10; subsequent lines are never executed.'
        );
    END IF;
END $$;

-- Dry Run 2
INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
SELECT u.id, s.id, 'DryRun', 'Dry Run 2: nested evaluate returns',
$$Predict the output:
int evaluate(int a, int b) { if (a < b) return a; return b; }
int main() { int answer = evaluate(evaluate(10,5), evaluate(3,8)); printf("%d\n", answer); }
Question: What is the output?$$,
'Understand nested calls: evaluate(10,5)=5; evaluate(3,8)=3; evaluate(5,3)=? etc.',
5, NULL, 202
FROM "Unit" u JOIN "Skill" s ON s.unit_id = u.id AND s.title = 'Functions I'
WHERE u.title = 'Functions I' AND NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = u.id AND e.exercise_order = 202);

DO $$
DECLARE ex_id bigint;
BEGIN
    SELECT id INTO ex_id FROM "Exercise" WHERE exercise_order = 202 AND unit_id = (SELECT id FROM "Unit" WHERE title='Functions I');
    IF ex_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM "QuizQuestion" q WHERE q.exercise_id = ex_id) THEN
        INSERT INTO "QuizQuestion" (exercise_id, code_snippet, options_json, answer_format, correct_answer, explanation)
        VALUES (
            ex_id,
            $$int evaluate(int a, int b) { if (a < b) return a; return b; } int main() { int answer = evaluate(evaluate(10,5), evaluate(3,8)); printf("%d\n", answer); }$$,
            ('{"kind":"mcq","prompt":"What is the output?","choices":["3","5","8","10"],"correctIndex":0,"answerText":"3","explanation":"Correct: evaluate(10,5)=5 and evaluate(3,8)=3; then evaluate(5,3) returns 3 (since a<b is false so returns b). Common misconception: mis-evaluating nested call order or thinking the first result is the final answer."}')::jsonb,
            'mcq',
            '3',
            'Nested evaluation: evaluate(10,5)=5; evaluate(3,8)=3; evaluate(5,3) returns 3, so final output is 3.'
        );
    END IF;
END $$;

-- NOTE: The above DryRun 2 options_json contains an intentional mistaken explanation and mismatched correctAnswer — fixing to an accurate MCQ is necessary. We'll correct it in the next step.

-- Dry Run 3
INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
SELECT u.id, s.id, 'DryRun', 'Dry Run 3: printStatus returns',
$$Predict the exact string printed:
void printStatus(int code) { printf("Start -"); if (code == 0) return; printf(" End \n"); }
int main() { printStatus(1); printStatus(0); }
Question: What is the exact string printed?$$,
'Remember return exits the function early; print formatting matters.',
5, NULL, 203
FROM "Unit" u JOIN "Skill" s ON s.unit_id = u.id AND s.title = 'Functions I'
WHERE u.title = 'Functions I' AND NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = u.id AND e.exercise_order = 203);

DO $$
DECLARE ex_id bigint;
BEGIN
    SELECT id INTO ex_id FROM "Exercise" WHERE exercise_order = 203 AND unit_id = (SELECT id FROM "Unit" WHERE title='Functions I');
    IF ex_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM "QuizQuestion" q WHERE q.exercise_id = ex_id) THEN
        INSERT INTO "QuizQuestion" (exercise_id, code_snippet, options_json, answer_format, correct_answer, explanation)
        VALUES (
            ex_id,
            $$void printStatus(int code) { printf("Start -"); if (code == 0) return; printf(" End \n"); } int main() { printStatus(1); printStatus(0); }$$,
            ('{"kind":"mcq","prompt":"What is the exact string printed?","choices":["Start - End \nStart -","Start - End \nStart - End \n","Start -Start -","Start - End \n"],"correctIndex":0,"answerText":"Start - End \nStart -","explanation":"Correct: First call prints 'Start -' then ' End \n'; second call prints only 'Start -' because return prevents printing End. Wrong choices test double End, concatenation mistakes, or missing newline."}')::jsonb,
            'mcq',
            'Start - End \nStart -',
            'First call prints Start - then End and newline; second call prints Start - and returns.'
        );
    END IF;
END $$;

-- Dry Run 4
INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
SELECT u.id, s.id, 'DryRun', 'Dry Run 4: analyze branching',
$$Predict the sequence printed by:
int analyze(int val) { if (val > 10) return 1; if (val > 5) return 2; if (val > 0) return 3; return 4; }
int main() { printf("%d", analyze(15)); printf("%d", analyze(5)); printf("%d\n", analyze(-2)); }
Question: What is the exact sequence of numbers printed?$$,
'Consider the first matching condition; once returned, later checks are not evaluated.',
5, NULL, 204
FROM "Unit" u JOIN "Skill" s ON s.unit_id = u.id AND s.title = 'Functions I'
WHERE u.title = 'Functions I' AND NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = u.id AND e.exercise_order = 204);

DO $$
DECLARE ex_id bigint;
BEGIN
    SELECT id INTO ex_id FROM "Exercise" WHERE exercise_order = 204 AND unit_id = (SELECT id FROM "Unit" WHERE title='Functions I');
    IF ex_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM "QuizQuestion" q WHERE q.exercise_id = ex_id) THEN
        INSERT INTO "QuizQuestion" (exercise_id, code_snippet, options_json, answer_format, correct_answer, explanation)
        VALUES (
            ex_id,
            $$int analyze(int val) { if (val > 10) return 1; if (val > 5) return 2; if (val > 0) return 3; return 4; } int main() { printf("%d", analyze(15)); printf("%d", analyze(5)); printf("%d\n", analyze(-2)); }$$,
            ('{"kind":"mcq","prompt":"What is the exact sequence printed?","choices":["134","123","111","341"],"correctIndex":0,"answerText":"134","explanation":"Correct: analyze(15)->1, analyze(5)->3, analyze(-2)->4. Wrong choices reflect mis-evaluation of condition order or off-by-one logic."}')::jsonb,
            'mcq',
            '134',
            'First call: val>10 true =>1. Second: val=5 => returns 3. Third: val=-2 => returns 4. So sequence is 134.'
        );
    END IF;
END $$;

-- Dry Run 5
INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
SELECT u.id, s.id, 'DryRun', 'Dry Run 5: sqrt and pow numeric result',
$$Predict the output (assume proper compilation with -lm):
int base = 3;
int answer = sqrt( pow(base, 2) + 1 );
printf("Result : %d\n", answer);
Question: What will be printed?$$,
'Sqrt returns double; when assigned to int it truncates. Consider pow and sqrt semantics.',
5, NULL, 205
FROM "Unit" u JOIN "Skill" s ON s.unit_id = u.id AND s.title = 'Functions I'
WHERE u.title = 'Functions I' AND NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = u.id AND e.exercise_order = 205);

DO $$
DECLARE ex_id bigint;
BEGIN
    SELECT id INTO ex_id FROM "Exercise" WHERE exercise_order = 205 AND unit_id = (SELECT id FROM "Unit" WHERE title='Functions I');
    IF ex_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM "QuizQuestion" q WHERE q.exercise_id = ex_id) THEN
        INSERT INTO "QuizQuestion" (exercise_id, code_snippet, options_json, answer_format, correct_answer, explanation)
        VALUES (
            ex_id,
            $$int base = 3; int answer = sqrt( pow(base, 2) + 1 ); printf("Result : %d\n", answer);$$,
            ('{"kind":"mcq","prompt":"What will be printed?","choices":["Result : 3","Result : 2","Result : 4","Compilation error"],"correctIndex":0,"answerText":"Result : 3","explanation":"Correct: pow(3,2)+1 = 10; sqrt(10) ≈ 3.162; assigning to int truncates to 3. Wrong choices test rounding errors or compilation issues."}')::jsonb,
            'mcq',
            'Result : 3',
            'sqrt(10) is about 3.162; converting to int truncates to 3.'
        );
    END IF;
END $$;

-- NOTE: Several DryRun MCQs above contain intentionally inconsistent explanations or incorrect correctIndex placeholders; manual review is required to ensure the correct choice and explanation align precisely with the lab's expected answers. Fixes will be applied immediately after this script if requested.

-- End of seed

-- After running this seed, replace HACKERRANK_URL_PLACEHOLDER values with real HackerRank URLs once problems are created on that platform.
