-- stage-5-unit-1: idempotent seed for Unit 1 (Loops)
-- Inserts Exercises and QuizQuestions for Lab 4 (Loops)
-- Safe to re-run. Uses UPSERTs and existence checks.

DO $$
DECLARE
    unit_id bigint;
    skill_id bigint;
BEGIN
    -- Find Unit id for 'Loops'
    SELECT id INTO unit_id FROM "Unit" WHERE title = 'Loops';
    IF unit_id IS NULL THEN
        RAISE EXCEPTION 'Unit "Loops" not found. Ensure schema.sql seed ran.';
    END IF;

    -- Upsert a Skill for this unit
    INSERT INTO "Skill" (unit_id, title)
    VALUES (unit_id, 'Loops')
    ON CONFLICT (unit_id, title) DO UPDATE SET title = EXCLUDED.title
    RETURNING id INTO skill_id;

    IF skill_id IS NULL THEN
        -- If RETURNING didn't run (existing row), fetch id
        SELECT id INTO skill_id FROM "Skill" WHERE unit_id = unit_id AND title = 'Loops';
    END IF;

    -- Helper: insert exercise if not exists by (unit_id, exercise_order)

    -- Problem 1: Number Classifier via Loop
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 1: Number Classifier via Loop',
    $$Write a program that takes a positive integer from the user. In a single pass (one loop), calculate and print:
    - The total number of digits.
    - The sum of the digits.
    - The reverse of the number.

    Sample I/O (visible test):
    Input: 452
    Output:
    Digits: 3
    Sum: 11
    Reversed: 254

    Hidden test cases (for HackerRank upload - do NOT expose to students):
    1) Input: 1 => Digits: 1, Sum:1, Reversed:1  (single-digit boundary)
    2) Input: 1000 => Digits:4, Sum:1, Reversed:1  (trailing zeros)
    3) Input: 9 => Digits:1, Sum:9, Reversed:9
    4) Input: 1234567890 => Digits:10, Sum:45, Reversed:0987654321 (ensure handling of large counts)
    $$,
    'Use a loop that extracts digits with % and /, remember to initialize accumulators (sum, count) before the loop.',
    15,
    'HACKERRANK_URL_PLACEHOLDER: Problem 1',
    1
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 1);

    -- Problem 2: Decimal-to-Binary Converter and Bit Counter
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 2: Decimal-to-Binary Converter and Bit Counter',
    $$Write a program that asks the user for a positive decimal integer. Use loops to compute its binary representation and print the digits in the correct order (most significant bit first).
    As a second part of the problem, count and print how many of those bits are 1.

    Sample I/O (visible test):
    Input: 23
    Output:
    Binary representation: 10111
    Number of 1 bits: 4

    Hidden test cases:
    1) Input: 1 => Binary:1, Count:1 (smallest positive)
    2) Input: 2 => Binary:10, Count:1 (power of two)
    3) Input: 1023 => Binary:1111111111, Count:10 (all ones)
    4) Input: 0 is outside spec (positive integer) but if supported ensure behavior documented
    $$,
    'Build binary by collecting remainders then reverse them; or find highest power of two then iterate down. Don\'t forget to handle 1-bit numbers.',
    15,
    'HACKERRANK_URL_PLACEHOLDER: Problem 2',
    2
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 2);

    -- Problem 3: The Digital Root
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 3: The Digital Root',
    $$Write a program that takes a positive integer from the user, calculates its digital root (repeatedly sum digits until a single digit), and prints the intermediate sums along the way.

    Sample I/O (visible test):
    Input: 987
    Output:
    Intermediate sum: 24
    Intermediate sum: 6
    Digital root: 6

    Hidden test cases:
    1) Input: 9 => Intermediate sums none, Digital root:9 (already single digit)
    2) Input: 10 => Intermediate sum:1, Digital root:1 (with carry)
    3) Input: 1999999999 => ensure multiple iterations and performance for larger inputs
    $$,
    'Apply a loop to sum digits; if the sum is > 9, repeat the process. Print each intermediate sum when > 9.',
    15,
    'HACKERRANK_URL_PLACEHOLDER: Problem 3',
    3
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 3);

    -- Problem 4: PIN Validator with Limited Attempts
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 4: PIN Validator with Limited Attempts',
    $$Write a program that simulates a locked phone or ATM. Store a fixed correct PIN (1234). Prompt the user repeatedly to enter the PIN using a do-while loop. If they enter the wrong PIN, tell them to try again. After 3 failed attempts, stop and print a lockout message. If they enter the correct PIN before attempts run out, print success.

    Sample I/O (visible test - success):
    Input sequence: 1111 1234
    Output:
    Incorrect. Try again.
    Access granted!

    Hidden tests:
    1) Three wrong attempts followed by lockout message
    2) Correct on third attempt => Access granted
    3) Correct on first attempt => Access granted (do-while ensures prompt at least once)
    $$,
    'Use a do-while loop so the user is prompted at least once; track attempt count and break on success.',
    15,
    'HACKERRANK_URL_PLACEHOLDER: Problem 4',
    4
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 4);

    -- Problem 5: The Smart Guesser Simulation
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 5: The Smart Guesser Simulation',
    $$Write a program that simulates binary-search guessing of a hidden number between 1 and 1000. Set the hidden number in code (e.g., 714). Using a while loop, keep low and high bounds, compute the midpoint guess each iteration, print the guess and whether it is too low/too high/correct, and finally print total guesses.

    Sample I/O (visible test):
    Target number is 714.
    Guessing 500... Too low!
    Guessing 750... Too high!
    Guessing 625... Too low!
    ...
    Guessing 714... Correct!
    Found in 9 guesses.

    Hidden tests:
    1) Target = 1 (lower bound)
    2) Target = 1000 (upper bound)
    3) Target = 512 (power-of-two midpoints)
    $$,
    'Simulate binary search correctly updating low/high; compute midpoint as low + (high - low)/2 to avoid overflow.',
    15,
    'HACKERRANK_URL_PLACEHOLDER: Problem 5',
    5
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 5);

    -- Problem 6: Approximating Pi (harder)
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 6: Approximating Pi (Leibniz series)',
    $$Write a program that asks the user for a number of terms N. Use a loop to calculate the Gregory-Leibniz series up to N terms, multiply the sum by 4 to approximate pi, and print the approximation, the actual pi (use acos(-1.0) if available), and the percentage error.

    Sample I/O (visible test):
    Input: 10000
    Output:
    Approximate pi: 3.141493
    Actual pi: 3.141593
    Percentage error: 0.003183%

    Hidden tests:
    1) Small N = 1 (check sign/term handling)
    2) N = 100 (observe decreasing error)
    3) N = 100000 (performance; numeric stability)
    $$,
    'Alternate adding and subtracting terms with odd denominators; use a double and guard sign flips. For large N watch performance.',
    20,
    'HACKERRANK_URL_PLACEHOLDER: Problem 6',
    6
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 6);

    -- Problem 7: Star Pattern Menu
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 7: Star Pattern Menu',
    $$Write a program that shows a menu (1: Right Triangle, 2: Inverted Right Triangle, 3: Square). After selection, read size and print the chosen pattern using loops.

    Sample I/O (visible test):
    Select pattern: 2
    Enter size: 4
    Output:
    ****
    ***
    **
    *

    Hidden tests:
    1) Size = 1 (smallest)
    2) Size = 5 (typical)
    3) Choice = 3 (square)
    $$,
    'Use nested loops: outer loop for rows, inner for columns; adjust limits by pattern choice.',
    15,
    'HACKERRANK_URL_PLACEHOLDER: Problem 7',
    7
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 7);

    -- Debugging Exercises (type Debugging) 1..5
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
    SELECT unit_id, skill_id, 'Debugging', 'Debugging 1: Multiplication table off-by-one',
    $$This debugging task is from the lab: the code below is intended to print multiplication table for 5 up to 5 x 10 but contains a logic error.
    Code:
    int n = 5;
    for(int i = 1; i < 10; i++) {
        printf("%d x %d = %d\n", n, i, n * i);
    }
    Task: Explain and fix the condition so it prints up to 5 x 10.
    $$,
    'The loop condition should include i <= 10. Off-by-one.',
    10,
    'HACKERRANK_URL_PLACEHOLDER: Debugging 1',
    101
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 101);

    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
    SELECT unit_id, skill_id, 'Debugging', 'Debugging 2: Digit counter infinite loop',
    $$Code:
    int num = 459;
    int count = 0;
    while(num > 0) {
        count++;
    }
    printf("Digits: %d\n", count);
    Task: What is missing and why does this freeze?
    $$,
    'Missing num /= 10; inside loop. Update step missing leads to infinite loop.',
    10,
    'HACKERRANK_URL_PLACEHOLDER: Debugging 2',
    102
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 102);

    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
    SELECT unit_id, skill_id, 'Debugging', 'Debugging 3: Uninitialized accumulator',
    $$Code:
    int sum;
    for(int i = 1; i <= 5; i++) {
        sum = sum + i;
    }
    printf("Sum is %d\n", sum);
    Task: Explain why output is incorrect and fix the bug.
    $$,
    'Initialize sum = 0 before the loop to avoid garbage values.',
    10,
    'HACKERRANK_URL_PLACEHOLDER: Debugging 3',
    103
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 103);

    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
    SELECT unit_id, skill_id, 'Debugging', 'Debugging 4: Nested loop index bug (square vs triangle)',
    $$Code:
    int n = 4;
    for(int i = 1; i <= n; i++) {
        for(int j = 1; j <= n; j++) {
            printf("*");
        }
        printf("\n");
    }
    Task: Program prints a square but should print a right-angled triangle. Change exactly one variable in one condition to fix the pattern.
    $$,
    'Inner loop should run j <= i instead of j <= n to create increasing row lengths.',
    10,
    'HACKERRANK_URL_PLACEHOLDER: Debugging 4',
    104
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 104);

    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
    SELECT unit_id, skill_id, 'Debugging', 'Debugging 5: Floating point equality (thermostat glitch)',
    $$Code (excerpt):
    float current = 0.1;
    float adjustment = 0.2;
    float target = 0.3;

    if (current + adjustment == target) { printf("Calibrated\n"); } else { printf("Drift detected\n"); }
    if (current + adjustment == 0.3) { printf("Matches spec\n"); } else { printf("Off spec\n"); }

    Task: Predict the output of both checks and explain why two checks that look identical may not agree.
    $$,
    'Floating point representation causes current + adjustment to not equal 0.3 exactly. Use an epsilon or compare within tolerance.',
    10,
    'HACKERRANK_URL_PLACEHOLDER: Debugging 5',
    105
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 105);

    -- Challenge: Calendar Day Counter (Hard)
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
    SELECT unit_id, skill_id, 'Challenge', 'Challenge: Calendar Day Counter',
    $$Write a program that takes two dates (each as DD MM YYYY). Calculate and print the total number of days between the two dates.
    Requirements (from lab):
    - Handle leap years correctly (use Lab 3 rule).
    - Advance through ends of months correctly.
    - Roll over from Dec 31 to Jan 1 of the next year.

    Sample I/O (visible test):
    Input:
    Start: 28 2 2024
    End: 2 3 2024
    Output:
    Total days between: 3

    Hidden test cases (for HackerRank):
    1) Same day (0 days)
    2) Across multiple years including leap year boundaries
    3) End before start (specify expected behavior in test harness)
    $$,
    'Advance date by one day in a loop, carefully handling month lengths and leap-year rule. Test zero-days and cross-year cases.',
    30,
    'HACKERRANK_URL_PLACEHOLDER: Challenge Calendar Day Counter',
    200
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 200);

END $$;

-- Dry-Run exercises (must be type DryRun and cannot have hackerrank_url per schema trigger)
-- Each DryRun gets a QuizQuestion row. Use the Stage-4 options_json shape.

-- Dry Run 1
INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
SELECT u.id, s.id, 'DryRun', 'Dry Run 1: break in for-loop',
$$Predict the output of the following code (no compilation):
for(int i = 1; i <= 5; i++) {
    if (i == 4) break;
    printf("%d ", i);
}

Question: What is the output?$$,
'Remember that break exits the loop immediately when encountered.',
5, NULL, 301
FROM "Unit" u JOIN "Skill" s ON s.unit_id = u.id AND s.title = 'Loops'
WHERE u.title = 'Loops' AND NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = u.id AND e.exercise_order = 301);

-- Insert corresponding QuizQuestion for Dry Run 1
DO $$
DECLARE ex_id bigint;
BEGIN
    SELECT id INTO ex_id FROM "Exercise" WHERE exercise_order = 301 AND unit_id = (SELECT id FROM "Unit" WHERE title='Loops');
    IF ex_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM "QuizQuestion" q WHERE q.exercise_id = ex_id) THEN
        INSERT INTO "QuizQuestion" (exercise_id, code_snippet, options_json, answer_format, correct_answer, explanation)
        VALUES (
            ex_id,
            $$for(int i = 1; i <= 5; i++) { if (i == 4) break; printf("%d ", i); }$$,
            -- options_json follows Stage 4 shape
            ('{"kind":"mcq","prompt":"What is the output?","choices":["1 2 3 ","1 2 3 4 ","1 2 3 4 5 ","2 3 4 "],"correctIndex":0,"answerText":"1 2 3 ","explanation":"Correct: break stops loop when i==4 so the printed values are 1,2,3. Wrong choices reflect misconceptions: including 4 (off-by-one), printing all iterations (missing break), or skipping first value (index shift)."}')::jsonb,
            'mcq',
            '1 2 3 ',
            'break stops the loop when i==4, so numbers 1..3 are printed; 4 is not printed.'
        );
    END IF;
END $$;

-- Dry Run 2
INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
SELECT u.id, s.id, 'DryRun', 'Dry Run 2: while(0) vs do-while',
$$Predict the output:
int x = 5;
while(0) { x++; }
do { x++; } while(0);
printf("%d", x);

Question: What is the output?$$,
'Note: while(0) never executes its body; do-while executes body once before checking condition.',
5, NULL, 302
FROM "Unit" u JOIN "Skill" s ON s.unit_id = u.id AND s.title = 'Loops'
WHERE u.title = 'Loops' AND NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = u.id AND e.exercise_order = 302);

DO $$
DECLARE ex_id bigint;
BEGIN
    SELECT id INTO ex_id FROM "Exercise" WHERE exercise_order = 302 AND unit_id = (SELECT id FROM "Unit" WHERE title='Loops');
    IF ex_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM "QuizQuestion" q WHERE q.exercise_id = ex_id) THEN
        INSERT INTO "QuizQuestion" (exercise_id, code_snippet, options_json, answer_format, correct_answer, explanation)
        VALUES (
            ex_id,
            $$int x = 5; while(0) { x++; } do { x++; } while(0); printf("%d", x);$$,
            ('{"kind":"mcq","prompt":"What is the output?","choices":["5","6","7","0"],"correctIndex":1,"answerText":"6","explanation":"Correct: while(0) never runs, do-while runs once, so x increments from 5 to 6. Wrong choices: 5 (misses do-while), 7 (double increment), 0 (nonsense)."}')::jsonb,
            'mcq',
            '6',
            'while(0) skips body; do-while executes body once.'
        );
    END IF;
END $$;

-- Dry Run 3
INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
SELECT u.id, s.id, 'DryRun', 'Dry Run 3: nested loops printing',
$$Predict the exact string printed by:
for(int i = 1; i <= 3; i++) {
    for(int j = 1; j <= 2; j++) {
        printf("%d", j);
    }
    printf("-");
}

Question: What is the exact string printed?$$,
'Inner loop prints j for j=1..2; outer loop repeats this three times, with a - after each inner loop.',
5, NULL, 303
FROM "Unit" u JOIN "Skill" s ON s.unit_id = u.id AND s.title = 'Loops'
WHERE u.title = 'Loops' AND NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = u.id AND e.exercise_order = 303);

DO $$
DECLARE ex_id bigint;
BEGIN
    SELECT id INTO ex_id FROM "Exercise" WHERE exercise_order = 303 AND unit_id = (SELECT id FROM "Unit" WHERE title='Loops');
    IF ex_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM "QuizQuestion" q WHERE q.exercise_id = ex_id) THEN
        INSERT INTO "QuizQuestion" (exercise_id, code_snippet, options_json, answer_format, correct_answer, explanation)
        VALUES (
            ex_id,
            $$for(int i = 1; i <= 3; i++) { for(int j = 1; j <= 2; j++) { printf("%d", j); } printf("-"); }$$,
            ('{"kind":"mcq","prompt":"What is the exact string printed?","choices":["12-12-12-","12-12-12","121212-","12-12-"],"correctIndex":0,"answerText":"12-12-12-","explanation":"Correct: inner prints '12' then outer prints '-' leading to '12-'; repeated 3 times yields '12-12-12-'. Wrong choices reflect misunderstandings about the placement of '-' or concatenation."}')::jsonb,
            'mcq',
            '12-12-12-',
            'Each inner loop prints 1 then 2, then a dash after the inner loop; repeated 3 times.'
        );
    END IF;
END $$;

-- Dry Run 4
INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
SELECT u.id, s.id, 'DryRun', 'Dry Run 4: continue in for-loop',
$$Predict the output:
for(int i = 1; i <= 5; i++) {
    if (i % 2 == 0) continue;
    printf("%d ", i);
}

Question: What is the output?$$,
'continue skips even iterations; only odd i are printed.',
5, NULL, 304
FROM "Unit" u JOIN "Skill" s ON s.unit_id = u.id AND s.title = 'Loops'
WHERE u.title = 'Loops' AND NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = u.id AND e.exercise_order = 304);

DO $$
DECLARE ex_id bigint;
BEGIN
    SELECT id INTO ex_id FROM "Exercise" WHERE exercise_order = 304 AND unit_id = (SELECT id FROM "Unit" WHERE title='Loops');
    IF ex_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM "QuizQuestion" q WHERE q.exercise_id = ex_id) THEN
        INSERT INTO "QuizQuestion" (exercise_id, code_snippet, options_json, answer_format, correct_answer, explanation)
        VALUES (
            ex_id,
            $$for(int i = 1; i <= 5; i++) { if (i % 2 == 0) continue; printf("%d ", i); }$$,
            ('{"kind":"mcq","prompt":"What is the output?","choices":["1 3 5 ","1 2 3 4 5 ","2 4 ","1 3 5  "],"correctIndex":0,"answerText":"1 3 5 ","explanation":"Correct: continue skips even iterations, printing only 1,3,5. Wrong choices represent including evens, printing only evens, or spacing confusion."}')::jsonb,
            'mcq',
            '1 3 5 ',
            'continue makes the loop skip the rest of the body for even i; only odd numbers printed.'
        );
    END IF;
END $$;

-- End of seed

-- NOTE: Hidden test cases were previously included only as SQL comments. They have now been migrated into the database in the hidden_test_cases JSONB column for the ProblemN and Challenge exercises. After running the migration (db/migrations/0001_add_difficulty_and_hidden_tests.sql), the following idempotent UPDATEs will backfill difficulty and hidden_test_cases for Unit 'Loops'.

-- Backfill difficulty and hidden_test_cases for Problems 1..7 and Challenge (idempotent updates)
-- Problems: difficulties taken from stage-5-unit-1-summary.md

-- Problem 1
UPDATE "Exercise" e
SET difficulty = 'Easy',
    hidden_test_cases = (
        '[{"input":"452","expected_output":"Digits: 3\nSum: 11\nReversed: 254"},
          {"input":"1","expected_output":"Digits: 1\nSum: 1\nReversed: 1"},
          {"input":"1000","expected_output":"Digits: 4\nSum: 1\nReversed: 1"},
          {"input":"1234567890","expected_output":"Digits: 10\nSum: 45\nReversed: 0987654321"}]'
    )::jsonb
FROM "Unit" u
WHERE e.unit_id = u.id AND u.title = 'Loops' AND e.exercise_order = 1;

-- Problem 2
UPDATE "Exercise" e
SET difficulty = 'Medium',
    hidden_test_cases = (
        '[{"input":"23","expected_output":"Binary representation: 10111\nNumber of 1 bits: 4"},
          {"input":"1","expected_output":"Binary representation: 1\nNumber of 1 bits: 1"},
          {"input":"2","expected_output":"Binary representation: 10\nNumber of 1 bits: 1"},
          {"input":"1023","expected_output":"Binary representation: 1111111111\nNumber of 1 bits: 10"}]'
    )::jsonb
FROM "Unit" u
WHERE e.unit_id = u.id AND u.title = 'Loops' AND e.exercise_order = 2;

-- Problem 3
UPDATE "Exercise" e
SET difficulty = 'Easy',
    hidden_test_cases = (
        '[{"input":"987","expected_output":"Intermediate sum: 24\nIntermediate sum: 6\nDigital root: 6"},
          {"input":"9","expected_output":"Digital root: 9"},
          {"input":"10","expected_output":"Intermediate sum: 1\nDigital root: 1"},
          {"input":"1999999999","expected_output": null, "notes":"ensure multiple iterations/performance"}]'
    )::jsonb
FROM "Unit" u
WHERE e.unit_id = u.id AND u.title = 'Loops' AND e.exercise_order = 3;

-- Problem 4
UPDATE "Exercise" e
SET difficulty = 'Easy',
    hidden_test_cases = (
        '[{"input":"1111\n1234","expected_output":"Incorrect. Try again.\nAccess granted!", "notes":"success path example"},
          {"input":"1111\n9999\n0000","expected_output":"Incorrect. Try again.\nIncorrect. Try again.\nAccount locked. Too many failed attempts.", "notes":"lockout path"},
          {"input":"1111\n1111\n1234","expected_output":"Incorrect. Try again.\nIncorrect. Try again.\nAccess granted!", "notes":"correct on third attempt"}]'
    )::jsonb
FROM "Unit" u
WHERE e.unit_id = u.id AND u.title = 'Loops' AND e.exercise_order = 4;

-- Problem 5
UPDATE "Exercise" e
SET difficulty = 'Medium',
    hidden_test_cases = (
        '[{"input":"714","expected_output": null, "notes":"target number 714 example - expect sequence of guesses and final count"},
          {"input":"1","expected_output": null, "notes":"lower bound target"},
          {"input":"1000","expected_output": null, "notes":"upper bound target"},
          {"input":"512","expected_output": null, "notes":"power-of-two midpoints"}]'
    )::jsonb
FROM "Unit" u
WHERE e.unit_id = u.id AND u.title = 'Loops' AND e.exercise_order = 5;

-- Problem 6 (harder)
UPDATE "Exercise" e
SET difficulty = 'Hard',
    hidden_test_cases = (
        '[{"input":"1","expected_output": null, "notes":"N=1 small term check"},
          {"input":"100","expected_output": null, "notes":"N=100 accuracy check"},
          {"input":"100000","expected_output": null, "notes":"N=100000 performance/stability check"}]'
    )::jsonb
FROM "Unit" u
WHERE e.unit_id = u.id AND u.title = 'Loops' AND e.exercise_order = 6;

-- Problem 7
UPDATE "Exercise" e
SET difficulty = 'Medium',
    hidden_test_cases = (
        '[{"input":"2\n4","expected_output":"****\n***\n**\n*\n", "notes":"inverted right triangle example (choice 2, size 4)"},
          {"input":"1\n1","expected_output":"*\n", "notes":"size 1"},
          {"input":"3\n5","expected_output": null, "notes":"square choice 3, size 5"}]'
    )::jsonb
FROM "Unit" u
WHERE e.unit_id = u.id AND u.title = 'Loops' AND e.exercise_order = 7;

-- Challenge: Calendar Day Counter
UPDATE "Exercise" e
SET difficulty = 'Hard',
    hidden_test_cases = (
        '[{"input":"28 2 2024\n2 3 2024","expected_output":"Total days between: 3"},
          {"input":"1 1 2020\n1 1 2020","expected_output":"Total days between: 0", "notes":"same day"},
          {"input":"31 12 2019\n1 1 2020","expected_output":"Total days between: 1", "notes":"year rollover and leap-year boundaries"}]'
    )::jsonb
FROM "Unit" u
WHERE e.unit_id = u.id AND u.title = 'Loops' AND e.exercise_order = 200;

-- Note: Debugging exercises (exercise_order 101..105) were not accompanied by hidden test case comments in the original seed and therefore are left with hidden_test_cases NULL. If you want those populated with concrete input/expected-output pairs, provide the exact test cases to store here.

-- After running the migration and this seed script, confirm the new columns exist and the values are populated.

-- END backfill

-- NOTE: HackerRank hidden test cases were moved into the DB for the above exercises. Replace the HACKERRANK_URL_PLACEHOLDER values with real problem URLs after creating problems on HackerRank.
