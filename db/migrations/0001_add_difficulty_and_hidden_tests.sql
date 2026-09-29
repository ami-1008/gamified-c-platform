-- Migration 0001: add difficulty (enum-like constrained text) and hidden_test_cases (jsonb) to Exercise
-- Idempotent: checks for column existence before altering.

DO $$
BEGIN
    -- Add difficulty column if not exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'Exercise' AND column_name = 'difficulty'
    ) THEN
        ALTER TABLE "Exercise"
        ADD COLUMN difficulty TEXT CHECK (difficulty IN ('Easy', 'Medium', 'Hard'));
    END IF;

    -- Add hidden_test_cases column if not exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'Exercise' AND column_name = 'hidden_test_cases'
    ) THEN
        ALTER TABLE "Exercise"
        ADD COLUMN hidden_test_cases JSONB;
    END IF;
END $$;

-- Optionally, create an index for hidden_test_cases if queries will search it (not created by default).
-- CREATE INDEX IF NOT EXISTS idx_exercise_hidden_tests ON "Exercise" USING gin (hidden_test_cases);
