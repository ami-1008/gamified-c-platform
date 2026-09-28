-- Gamified C LMS schema
-- PostgreSQL DDL for the gamification/data model described in the Gamified_C document.

BEGIN;

CREATE TABLE "Student" (
    id BIGSERIAL PRIMARY KEY,
    platform_id TEXT NOT NULL UNIQUE,
    display_name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE "Unit" (
    id SMALLSERIAL PRIMARY KEY,
    title TEXT NOT NULL UNIQUE,
    unit_order SMALLINT NOT NULL UNIQUE,
    lab_reference TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE "Skill" (
    id BIGSERIAL PRIMARY KEY,
    unit_id BIGINT NOT NULL REFERENCES "Unit"(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    UNIQUE (unit_id, title)
);

CREATE TABLE "Exercise" (
    id BIGSERIAL PRIMARY KEY,
    unit_id BIGINT NOT NULL REFERENCES "Unit"(id) ON DELETE CASCADE,
    skill_id BIGINT NOT NULL REFERENCES "Skill"(id) ON DELETE RESTRICT,
    type TEXT NOT NULL CHECK (type IN ('ProblemN', 'Debugging', 'Challenge', 'DryRun')),
    title TEXT NOT NULL,
    statement TEXT,
    hint TEXT,
    points INTEGER NOT NULL CHECK (points >= 0),
    hackerrank_url TEXT,
    exercise_order INTEGER NOT NULL,
    UNIQUE (unit_id, exercise_order),
    CHECK (
        (type = 'DryRun' AND hackerrank_url IS NULL)
        OR (type IN ('ProblemN', 'Debugging', 'Challenge') AND hackerrank_url IS NOT NULL)
    )
);

CREATE TABLE "QuizQuestion" (
    exercise_id BIGINT PRIMARY KEY REFERENCES "Exercise"(id) ON DELETE CASCADE,
    code_snippet TEXT,
    options_json JSONB,
    answer_format TEXT,
    correct_answer TEXT NOT NULL,
    explanation TEXT NOT NULL
);

CREATE TABLE "CompletionRecord" (
    student_id BIGINT NOT NULL REFERENCES "Student"(id) ON DELETE CASCADE,
    exercise_id BIGINT NOT NULL REFERENCES "Exercise"(id) ON DELETE CASCADE,
    completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    first_try BOOLEAN NOT NULL,
    PRIMARY KEY (student_id, exercise_id)
);

CREATE TABLE "QuizAttempt" (
    id BIGSERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL REFERENCES "Student"(id) ON DELETE CASCADE,
    exercise_id BIGINT NOT NULL REFERENCES "Exercise"(id) ON DELETE CASCADE,
    submitted_answer TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL,
    attempted_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE "PointsLedger" (
    student_id BIGINT NOT NULL REFERENCES "Student"(id) ON DELETE CASCADE,
    exercise_id BIGINT NOT NULL REFERENCES "Exercise"(id) ON DELETE CASCADE,
    points_awarded INTEGER NOT NULL CHECK (points_awarded > 0),
    awarded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (student_id, exercise_id)
);

CREATE TABLE "Badge" (
    id BIGSERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL REFERENCES "Student"(id) ON DELETE CASCADE,
    unit_id BIGINT NOT NULL REFERENCES "Unit"(id) ON DELETE CASCADE,
    tier TEXT NOT NULL CHECK (tier IN ('silver', 'gold')),
    earned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (student_id, unit_id, tier)
);

CREATE TABLE "Streak" (
    student_id BIGINT PRIMARY KEY REFERENCES "Student"(id) ON DELETE CASCADE,
    current_streak INTEGER NOT NULL CHECK (current_streak >= 0),
    best_streak INTEGER NOT NULL CHECK (best_streak >= 0),
    last_active_date DATE NOT NULL
);

CREATE TABLE "ContestJoin" (
    student_id BIGINT NOT NULL REFERENCES "Student"(id) ON DELETE CASCADE,
    unit_id BIGINT NOT NULL REFERENCES "Unit"(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (student_id, unit_id)
);

CREATE OR REPLACE FUNCTION validate_quizquestion_exercise_type()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM "Exercise" e
        WHERE e.id = NEW.exercise_id
          AND e.type = 'DryRun'
    ) THEN
        RAISE EXCEPTION 'QuizQuestion can only be created for a DryRun exercise';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_quizquestion_exercise_type
BEFORE INSERT OR UPDATE ON "QuizQuestion"
FOR EACH ROW
EXECUTE FUNCTION validate_quizquestion_exercise_type();

CREATE OR REPLACE FUNCTION prevent_pointsledger_mutation()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'PointsLedger is append-only; UPDATE and DELETE are forbidden.';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_pointsledger_append_only
BEFORE UPDATE OR DELETE ON "PointsLedger"
FOR EACH ROW
EXECUTE FUNCTION prevent_pointsledger_mutation();

-- Seed the five units required by the project scope.
-- Exercise rows are intentionally left empty to keep the data model ready for later content import.
INSERT INTO "Unit" (title, unit_order, lab_reference)
VALUES
    ('Loops', 1, 'Lab 4'),
    ('Functions I', 2, 'Lab 5A'),
    ('Functions II', 3, 'Lab 5B'),
    ('Arrays', 4, 'Lab 6'),
    ('Strings', 5, 'Lab 7');

COMMIT;
