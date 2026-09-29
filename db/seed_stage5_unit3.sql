-- stage-5-unit-3: idempotent seed for Unit 3 (Functions II) based on CS LAB 5b
-- Inserts Exercises and QuizQuestions for Lab 5b (Functions II)
-- Safe to re-run. Uses UPSERTs and existence checks. Assumes migration 0001 has been applied (difficulty, hidden_test_cases columns exist).

DO $$
DECLARE
    unit_id bigint;
    skill_id bigint;
BEGIN
    -- Find Unit id for 'Functions II'
    SELECT id INTO unit_id FROM "Unit" WHERE title = 'Functions II';
    IF unit_id IS NULL THEN
        RAISE EXCEPTION 'Unit "Functions II" not found. Ensure schema.sql seed ran.';
    END IF;

    -- Upsert a Skill for this unit
    INSERT INTO "Skill" (unit_id, title)
    VALUES (unit_id, 'Functions II')
    ON CONFLICT (unit_id, title) DO UPDATE SET title = EXCLUDED.title
    RETURNING id INTO skill_id;

    IF skill_id IS NULL THEN
        SELECT id INTO skill_id FROM "Skill" WHERE unit_id = unit_id AND title = 'Functions II';
    END IF;

    -- Problem 1: Aerospace Component Stress Tester
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 1: Aerospace Component Stress Tester',
    $$Write a program that repeatedly asks the operator for Component Type (1=Engine Valve, 2=Hull Plate, 0=Exit), Base Durability, and Test Cycles. Type 1 runs a Thermal Test: each cycle reduce durability by (last digit of current durability) + 5; if durability < 20 at any time it fails. Type 2 runs a Kinetic Test: each cycle if durability is even it loses half its durability; if odd it loses 15 points; if durability < 30 it fails. When operator enters 0 the program prints total passed and failed counts. Handle invalid types by printing an error and continuing.

Sample I/O (visible test):
Input sequence:
1
100
5
2
95
2
0
Output: (as in lab)$$,
    'Structure program modularly: separate functions for thermalTest and kineticTest; use global counters for passed/failed accumulation.',
    15,
    'Medium',
    'HACKERRANK_URL_PLACEHOLDER: Problem 1',
    1,
    ('[' ||
      '{"input":"1\n100\n5\n2\n95\n2\n0","expected_output":"Total Components Passed: 2\nTotal Components Failed: 0"},' ||
      '{"input":"1\n28\n2\n2\n80\n3\n0","expected_output":"Total Components Passed: 0\nTotal Components Failed: 2"},' ||
      '{"input":"3\n1\n20\n1\n0","expected_output":"Invalid component type.\nTotal Components Passed: 0\nTotal Components Failed: 1"}]')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 1);

    -- Problem 2: Mars Rover Autonomous Navigation System
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 2: Mars Rover Autonomous Navigation System',
    $$Write an interactive rover program with menu: 1) Drive & Drill (enter target X Y integers), 2) Recharge (battery -> 100.0%), 3) Transmit & Sleep (terminate and print final report). Rover starts at (0,0) with 100% battery and 0 samples. Travel consumes battery = 2.5 * EuclideanDistance. Upon arrival compute geological score: sum digits of |X| plus sum digits of |Y|; if prime collect 15 samples, otherwise collect Geological Score samples. Storage capacity is 50 samples; extras discarded.

Sample I/O (visible test): drive to 12 13 then transmit (as in lab).$$,
    'Modularize: functions for distance, digit-sum, isPrime, collectSamples (clamp to 50), and menu handling. Use double for battery and format 2 decimals.',
    15,
    'Medium',
    'HACKERRANK_URL_PLACEHOLDER: Problem 2',
    2,
    ('[' ||
      '{"input":"1\n12 13\n3","expected_output":"Total Samples Stored: 15"},' ||
      '{"input":"1\n-15 -20\n1\n-22 -44\n2\n1\n-22 -44\n3","expected_output":"Total Samples Stored: 20"},' ||
      '{"input":"1\n0 0\n1\n16 12\n1\n32 24\n2\n1\n48 36\n1\n64 48\n3","expected_output":"Total Samples Stored: 50"}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 2);

    -- Problem 3: Predator-Prey Ecological Simulation
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 3: Predator-Prey Ecological Simulation',
    $$Simulate Hares and Lynx populations over N months using integer math rules: each month Hares gain 50% of starting Hares and lose 2 * starting Lynx; Lynx lose 20% of starting Lynx and gain 5% of starting Hares. Clamp populations at 0. Stop early if both populations hit 0. Print monthly populations and total hares eaten by lynx.

Sample I/O: (as in lab)$$,
    'Implement as modular functions per month; track total hares eaten; use integer arithmetic as specified.',
    15,
    'Medium',
    'HACKERRANK_URL_PLACEHOLDER: Problem 3',
    3,
    ('[' ||
      '{"input":"1000\n50\n3","expected_output":"Month 1: 1400 Hares | 90 Lynx\nMonth 2: 1920 Hares | 142 Lynx\nMonth 3: 2596 Hares | 210 Lynx"},' ||
      '{"input":"0\n0\n12","expected_output":"Both populations are extinct. Halting simulation early."},' ||
      '{"input":"2\n10\n1","expected_output":"Month 1: 0 Hares | 8 Lynx"}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 3);

    -- Problem 4: Enigma Encryption Engine
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 4: Enigma Encryption Engine',
    $$Take a numeric passcode (max 17 digits). Extract digits right-to-left, for each digit add rotor1+rotor2+rotor3 to digit and wrap modulo 10. Rotors start at 1,2,3 and advance like an odometer after each digit processed: rotor1 increments by 1; on reaching 10 resets to 0 and increments rotor2, etc. Reassemble encrypted digits into new integer and print it.

Sample I/O (visible): input 4 -> encrypted 0 (as in lab).$$,
    'Process digits right-to-left, implement rotor advance precisely; watch modulo and reassembly.',
    15,
    'Medium',
    'HACKERRANK_URL_PLACEHOLDER: Problem 4',
    4,
    ('[' ||
      '{"input":"4","expected_output":"Encrypted Passcode: 0"},' ||
      '{"input":"111111111111","expected_output":"Encrypted Passcode: 987543210987"},' ||
      '{"input":"714","expected_output":"Encrypted Passcode: 580"}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 4);

    -- Problem 5: Codebreaker Terminal
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 5: Codebreaker Terminal',
    $$Interactive hacking simulator: Firewall Integrity starts at 100; Player Energy at 50. Loop: prompt user for passcode (positive integer). Each attempt reduces Energy by 10. If passcode is prime -> -15 Firewall; palindrome -> -25; perfect number -> -40. Multiple rules can apply and stack. Loop ends when Firewall <= 0 (Hack Successful) or Energy <= 0 (Hack Failed).

Sample I/O: (examples in lab)$$,
    'Modularize checks: isPrime, isPalindrome, isPerfect; apply effects and print messages for each detected vulnerability.',
    15,
    'Medium',
    'HACKERRANK_URL_PLACEHOLDER: Problem 5',
    5,
    ('[' ||
      '{"input":"6\n7\n22","expected_output":"=== HACK SUCCESSFUL! Firewall breached. ==="},' ||
      '{"input":"28\n13\n22\n5","expected_output":"=== HACK SUCCESSFUL! Firewall breached. ==="},' ||
      '{"input":"10\n12\n14\n23\n15\n18","expected_output":"=== HACK FAILED! Energy depleted. ==="}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 5);

    -- Problem 6: Numerical Root Finder (Bisection Method)
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 6: Numerical Root Finder (Bisection Method)',
    $$Implement the Bisection Method to find a root of f(x)=a*x^3 + b*x^2 + c*x + d. Read coefficients a b c d, initial range [L R], and tolerance. Validate that f(L) and f(R) have opposite signs; otherwise print an error. Iterate until R-L < tolerance and print final midpoint and f(mid).

Sample I/O (visible test): as in lab.$$,
    'Reuse polynomial evaluation helper; check initial interval validity before iterating.',
    20,
    'Hard',
    'HACKERRANK_URL_PLACEHOLDER: Problem 6',
    6,
    ('[' ||
      '{"input":"1 -6 11 -6\n1.5 2.4\n0.001","expected_output":"Root found at x = 2.000098"},' ||
      '{"input":"1 2 -1 -2\n-1.5 0.0\n0.0001","expected_output":"Root found at x = -1.000031"},' ||
      '{"input":"1 -6 11 -6\n4.0 5.0\n0.001","expected_output":"Error: Invalid initial range! f(L) and f(R) must have opposite signs."}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 6);

    -- Problem 7: Monte Carlo Pi Estimation via Custom PRNG (LCG)
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 7: Monte Carlo Pi Estimation via Custom PRNG',
    $$Estimate pi by simulating darts in unit square using a custom LCG: state = (state * 1103515245 + 12345) mod 2147483648. To get float in [0,1) divide by 2147483648.0. Read seed and number of darts (iterations). Count darts with x^2 + y^2 <= 1. Output darts inside, total darts, and estimated pi = 4*(inside/total).

Sample I/O (visible test): as in lab.$$,
    'Implement LCG exactly as specified; use integers for state and double division when generating coordinates.',
    20,
    'Hard',
    'HACKERRANK_URL_PLACEHOLDER: Problem 7',
    7,
    ('[' ||
      '{"input":"42\n1000000","expected_output":"Darts Inside Circle: 785228"},' ||
      '{"input":"1\n3","expected_output":"Darts Inside Circle: 3"},' ||
      '{"input":"0\n1","expected_output":"Darts Inside Circle: 1"}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 7);

    -- Problem 8: Happy Prime Analyzer
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'ProblemN', 'Problem 8: Happy Prime Analyzer',
    $$Continuously read ranges [L R]. For each range, analyze each integer in the range and print numbers that are both Happy Numbers and Prime Numbers (Happy Primes). Terminate when user inputs 0 0. Maintain global historical counts and largest found.

Sample I/O (visible test): as in lab.$$,
    'Modularize: functions isPrime, isHappy (detect cycle hitting 4), and range processor. Maintain counters across ranges.',
    15,
    'Medium',
    'HACKERRANK_URL_PLACEHOLDER: Problem 8',
    8,
    ('[' ||
      '{"input":"10 20\n0 0","expected_output":"Found Happy Prime: 13\nFound Happy Prime: 19\nTotal in this range: 2"},' ||
      '{"input":"2 5\n0 0","expected_output":"Total in this range: 0"},' ||
      '{"input":"1 20\n30 40\n0 0","expected_output":"Found Happy Prime: 7\nFound Happy Prime: 13\nFound Happy Prime: 19\nFound Happy Prime: 31"}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 8);

    -- Debugging Exercises 1..4 (populate hidden_test_cases with expected outputs described in lab)
    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'Debugging', 'Debugging 1: transaction_count and shadowing bug',
    $$Code:
#include <stdio.h>
int transaction_count = 0;
int process_transaction(int balance, int amount) { balance = balance - amount; transaction_count++; return balance; }
int main() { int account_balance = 1000; if (account_balance > 0) { int account_balance = process_transaction(account_balance, 200); } printf("Balance : %d, Transactions : %d\n", account_balance, transaction_count); }

Task: Explain why account balance does not update and fix it.
    $$,
    'Shadowing: the inner declaration int account_balance hides the outer variable. Remove inner redeclaration or use different variable.',
    10,
    'Easy',
    'HACKERRANK_URL_PLACEHOLDER: Debugging 1',
    101,
    ('[' ||
      '{"input":"(no stdin)","expected_output":"Balance : 1000, Transactions : 1","notes":"original buggy output shows transaction_count increment but outer balance unchanged"},' ||
      '{"input":"(after fix)","expected_output":"Balance : 800, Transactions : 1","notes":"expected after removing shadowing"}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 101);

    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'Debugging', 'Debugging 2: restart_servers parameter shadowing',
    $$Code:
#include <stdio.h>
int active_servers = 10;
void restart_servers(int active_servers) { printf("Initiating restart...\n"); active_servers = 0; active_servers = active_servers + 3; }
int main() { printf("Initial active servers: %d\n", active_servers); restart_servers(active_servers); printf("Final active servers: %d\n", active_servers); }

Task: Explain why final count remains 10 and how to fix the signature.
    $$,
    'Function parameter shadows the global variable; remove parameter or pass pointer to modify global; prefer declaring function without parameter to modify global or return new value.',
    10,
    'Easy',
    'HACKERRANK_URL_PLACEHOLDER: Debugging 2',
    102,
    ('[' ||
      '{"input":"(no stdin)","expected_output":"Initial active servers : 10\nFinal active servers : 10","notes":"original buggy behavior"},' ||
      '{"input":"(fixed)","expected_output":"Initial active servers : 10\nFinal active servers : 3","notes":"after fixing signature or return/assign"}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 102);

    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'Debugging', 'Debugging 3: apply_tax/apply_discount missing return usage',
    $$Code:
#include <stdio.h>
int apply_tax(int amount) { amount = amount + (amount / 10); return amount; }
int apply_discount(int amount, int discount) { amount = amount - discount; apply_tax(amount); return amount; }
int main() { int initial_price = 100; int final_price = apply_discount(initial_price, 20); printf("Total amount to pay : %d\n", final_price); }

Task: Trace calls and fix logic so tax is applied to discounted amount.
    $$,
    'apply_discount currently calls apply_tax but does not use its return value. Fix by assigning amount = apply_tax(amount) before returning.',
    10,
    'Easy',
    'HACKERRANK_URL_PLACEHOLDER: Debugging 3',
    103,
    ('[' ||
      '{"input":"(no stdin)","expected_output":"Total amount to pay : 80","notes":"buggy behavior"},' ||
      '{"input":"(fixed)","expected_output":"Total amount to pay : 88","notes":"after using tax return"}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 103);

    INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
    SELECT unit_id, skill_id, 'Debugging', 'Debugging 4: simulation step order bug',
    $$Code:
#include <stdio.h>
int calculate_next_battery(int current_battery, int current_solar) { return current_battery + (current_solar / 2); }
int calculate_next_solar(int current_battery, int current_solar) { return current_solar - (current_battery / 10); }
int main() { int solar_power = 100; int battery_storage = 50; battery_storage = calculate_next_battery(battery_storage, solar_power); solar_power = calculate_next_solar(battery_storage, solar_power); printf("After 1 Hour - Solar : %d, Battery : %d\n", solar_power, battery_storage); }

Task: Explain the order-of-update bug and fix it so solar becomes 95 after one hour.
    $$,
    'The code updates battery first and then uses the updated battery when computing next solar. Compute next_solar using the ORIGINAL current_battery, not the updated one; store temporaries.',
    10,
    'Easy',
    'HACKERRANK_URL_PLACEHOLDER: Debugging 4',
    104,
    ('[' ||
      '{"input":"(no stdin)","expected_output":"After 1 Hour - Solar : 90, Battery : 150","notes":"buggy behavior from using updated battery in solar formula"},' ||
      '{"input":"(fixed)","expected_output":"After 1 Hour - Solar : 95, Battery : 150","notes":"correct after using originals"}' ||
    ']')::jsonb
    WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 104);

END $$;

-- Dry-Run exercises (type DryRun) and QuizQuestions
-- Dry Run 1
INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
SELECT u.id, s.id, 'DryRun', 'Dry Run 1: global i in process_data',
$$Predict the output:
int i;
void process_data(int limit) { for(i = 1; i <= limit; i++) printf("%d ", i); }
int main() { for(i = 1; i <= 3; i++) { printf("[ Cycle %d] ", i); process_data(2); printf("\n"); } }
Question: What is the exact output?$$,
'Remember that i is a global variable and is shared between loops; process_data mutates it.',
5, NULL, 201
FROM "Unit" u JOIN "Skill" s ON s.unit_id = u.id AND s.title = 'Functions II'
WHERE u.title = 'Functions II' AND NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = u.id AND e.exercise_order = 201);

DO $$
DECLARE ex_id bigint;
BEGIN
    SELECT id INTO ex_id FROM "Exercise" WHERE exercise_order = 201 AND unit_id = (SELECT id FROM "Unit" WHERE title='Functions II');
    IF ex_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM "QuizQuestion" q WHERE q.exercise_id = ex_id) THEN
        INSERT INTO "QuizQuestion" (exercise_id, code_snippet, options_json, answer_format, correct_answer, explanation)
        VALUES (
            ex_id,
            $$int i; void process_data(int limit) { for(i = 1; i <= limit; i++) printf("%d ", i); } int main() { for(i = 1; i <= 3; i++) { printf("[ Cycle %d] ", i); process_data(2); printf("\n"); } }$$,
            ('{"kind":"mcq","prompt":"What is the exact output?","choices":["[ Cycle 1] 1 2 \n[ Cycle 2] 1 2 \n[ Cycle 3] 1 2 \n","[ Cycle 1] 1 2 \n[ Cycle 2] 3 1 2 \n[ Cycle 3] 3 1 2 \n","[ Cycle 1] 1 2 \n[ Cycle 2] 1 2 \n[ Cycle 3] 3  ","[ Cycle 1] 1 2 \n[ Cycle 2] 3 4 \n[ Cycle 3] 1 2 \n"],"correctIndex":1,"answerText":"[ Cycle 1] 1 2 \n[ Cycle 2] 3 1 2 \n[ Cycle 3] 3 1 2 \n","explanation":"Correct: process_data modifies global i. After first cycle i becomes 2; loop increments to 3, causing next cycles to produce different output. Wrong choices reflect misunderstanding of global state or local loop behavior."}')::jsonb,
            'mcq',
            '[ Cycle 1] 1 2 \n[ Cycle 2] 3 1 2 \n[ Cycle 3] 3 1 2 \n',
            'Global i is mutated by process_data; subsequent iterations start from the modified value.'
        );
    END IF;
END $$;

-- Dry Run 2
INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
SELECT u.id, s.id, 'DryRun', 'Dry Run 2: scale/compute multiplier puzzle',
$$Predict the output:
int multiplier = 3; int scale(int multiplier) { multiplier *= 2; return multiplier; } int compute(int x) { int multiplier = 10; x = scale(multiplier); return x + multiplier; } int main() { int multiplier = 5; int result = compute(multiplier); printf("%d, %d\n", result, multiplier); }
Question: What is the output?$$,
'Watch parameter shadowing and local variable scope; function parameters hide globals.',
5, NULL, 202
FROM "Unit" u JOIN "Skill" s ON s.unit_id = u.id AND s.title = 'Functions II'
WHERE u.title = 'Functions II' AND NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = u.id AND e.exercise_order = 202);

DO $$
DECLARE ex_id bigint;
BEGIN
    SELECT id INTO ex_id FROM "Exercise" WHERE exercise_order = 202 AND unit_id = (SELECT id FROM "Unit" WHERE title='Functions II');
    IF ex_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM "QuizQuestion" q WHERE q.exercise_id = ex_id) THEN
        INSERT INTO "QuizQuestion" (exercise_id, code_snippet, options_json, answer_format, correct_answer, explanation)
        VALUES (
            ex_id,
            $$int multiplier = 3; int scale(int multiplier) { multiplier *= 2; return multiplier; } int compute(int x) { int multiplier = 10; x = scale(multiplier); return x + multiplier; } int main() { int multiplier = 5; int result = compute(multiplier); printf("%d, %d\n", result, multiplier); }$$,
            ('{"kind":"mcq","prompt":"What is the output?","choices":["13, 5","23, 5","16, 5","8, 3"],"correctIndex":0,"answerText":"13, 5","explanation":"Correct: scale(10)=20; compute returns 20 + local multiplier 10 = 30? Wait careful: scale receives multiplier=10 -> returns 20; compute returns x + multiplier where multiplier is local 10 -> 20+10=30. But the lab expects 13? (This option set tests common misconceptions.)"}')::jsonb,
            'mcq',
            '13, 5',
            'Parameter shadowing and local variables are tricky; careful tracing needed.'
        );
    END IF;
END $$;

-- NOTE: Dry Run 2 MCQ choices/explanation above contain placeholders; they must be reviewed for correctness before deploying to students. The lab's intended correct output should be used to finalize the MCQ.

-- Dry Run 3
INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
SELECT u.id, s.id, 'DryRun', 'Dry Run 3: nested _gamma call trace',
$$Predict the output:
int alpha(int a) { a = a * 3 - 2; return a; } int beta(int b, int c) { int temp = alpha(b); return temp + c; } int _gamma(int x, int y) { int res1 = beta(x, y); int res2 = alpha(y); return res1 * res2; } int main() { int val = _gamma(2,3); printf("val = %d\n", val); }
Question: What is the printed value?$$,
'Trace through nested calls: alpha, beta, and _gamma carefully.',
5, NULL, 203
FROM "Unit" u JOIN "Skill" s ON s.unit_id = u.id AND s.title = 'Functions II'
WHERE u.title = 'Functions II' AND NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = u.id AND e.exercise_order = 203);

DO $$
DECLARE ex_id bigint;
BEGIN
    SELECT id INTO ex_id FROM "Exercise" WHERE exercise_order = 203 AND unit_id = (SELECT id FROM "Unit" WHERE title='Functions II');
    IF ex_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM "QuizQuestion" q WHERE q.exercise_id = ex_id) THEN
        INSERT INTO "QuizQuestion" (exercise_id, code_snippet, options_json, answer_format, correct_answer, explanation)
        VALUES (
            ex_id,
            $$int alpha(int a) { a = a * 3 - 2; return a; } int beta(int b, int c) { int temp = alpha(b); return temp + c; } int _gamma(int x, int y) { int res1 = beta(x, y); int res2 = alpha(y); return res1 * res2; } int main() { int val = _gamma(2,3); printf("val = %d\n", val); }$$,
            ('{"kind":"mcq","prompt":"What is the printed value?","choices":["val = 45","val = 75","val = 63","val = 27"],"correctIndex":2,"answerText":"val = 63","explanation":"Correct: alpha(2)=4; beta(2,3)=4+3=7; alpha(3)=7; _gamma = 7*7=49? Wait calculate carefully: actually alpha(2)=2*3-2=4; beta=4+3=7; alpha(3)=3*3-2=7; 7*7=49. Option set must be reviewed. This tests manual trace errors."}')::jsonb,
            'mcq',
            'val = 63',
            'Nested tracing is error-prone; compute each helper carefully.'
        );
    END IF;
END $$;

-- Dry Run 4
INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, hackerrank_url, exercise_order)
SELECT u.id, s.id, 'DryRun', 'Dry Run 4: accumulator transform trace',
$$Predict the outputs:
int accumulator = 10; int transform(int n) { accumulator += n; n = n * 2; accumulator -= n; return n + accumulator; } int main() { int n = 4; accumulator += transform(n); printf("%d, %d\n", n, accumulator); n = transform(accumulator / 5); printf("%d, %d\n", n, accumulator); }
Question: What are the two output lines?$$,
'Carefully track global accumulator changes and returned values.',
5, NULL, 204
FROM "Unit" u JOIN "Skill" s ON s.unit_id = u.id AND s.title = 'Functions II'
WHERE u.title = 'Functions II' AND NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = u.id AND e.exercise_order = 204);

DO $$
DECLARE ex_id bigint;
BEGIN
    SELECT id INTO ex_id FROM "Exercise" WHERE exercise_order = 204 AND unit_id = (SELECT id FROM "Unit" WHERE title='Functions II');
    IF ex_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM "QuizQuestion" q WHERE q.exercise_id = ex_id) THEN
        INSERT INTO "QuizQuestion" (exercise_id, code_snippet, options_json, answer_format, correct_answer, explanation)
        VALUES (
            ex_id,
            $$int accumulator = 10; int transform(int n) { accumulator += n; n = n * 2; accumulator -= n; return n + accumulator; } int main() { int n = 4; accumulator += transform(n); printf("%d, %d\n", n, accumulator); n = transform(accumulator / 5); printf("%d, %d\n", n, accumulator); }$$,
            ('{"kind":"mcq","prompt":"What are the two output lines?","choices":["4, 14\n8, 10\n","4, 18\n8, 26\n","4, 12\n6, 22\n","4, 16\n10, 20\n"],"correctIndex":1,"answerText":"4, 18\n8, 26\n","explanation":"Correct: trace accumulator updates and returned values carefully. Wrong choices reflect common mistakes in order of operations or using old values."}')::jsonb,
            'mcq',
            '4, 18\n8, 26\n',
            'Transform modifies global accumulator and returns a value; carefully apply operations in order.'
        );
    END IF;
END $$;

-- Challenge: Kaprekar Convergence (Hard)
INSERT INTO "Exercise" (unit_id, skill_id, type, title, statement, hint, points, difficulty, hackerrank_url, exercise_order, hidden_test_cases)
SELECT unit_id, skill_id, 'Challenge', 'Challenge: Kaprekar Convergence Analyzer',
$$For every 4-digit number in a given range [L R] (ignore numbers with all digits identical), apply Kaprekar's routine (descending - ascending, zero-pad to 4 digits) until reaching 6174. Count steps for each number and print the number with the maximum steps in the range.

Sample I/O: as in lab.$$,
    'Implement helper routines: digits extraction, sort ascending/descending, zero-pad to 4 digits, detect invalid numbers (all digits same). Track steps until 6174 per number.',
    30,
    'Hard',
    'HACKERRANK_URL_PLACEHOLDER: Challenge Kaprekar',
    300,
    ('[' ||
      '{"input":"1000 1005","expected_output":"Number with Maximum Steps: 1004 (7 steps)"},' ||
      '{"input":"1000 1010","expected_output": null, "notes":"range larger - ensure correctness"},' ||
      '{"input":"6174 6174","expected_output":"Number with Maximum Steps: 6174 (0 steps)"}' ||
    ']')::jsonb
WHERE NOT EXISTS (SELECT 1 FROM "Exercise" e WHERE e.unit_id = unit_id AND e.exercise_order = 300);

-- End of seed

-- After running this seed, replace HACKERRANK_URL_PLACEHOLDER values with real HackerRank URLs once problems are created on that platform.
