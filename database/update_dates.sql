-- Update authorization dates to current dates (June 6, 2025)
-- This will make exactly 8 authorizations due today

-- Update received_date to today's date with different times
UPDATE authorizations 
SET received_date = CURRENT_DATE + (INTERVAL '1 hour' * (id % 24)) + (INTERVAL '1 minute' * (id * 15 % 60));

-- Update admission_date to today or yesterday
UPDATE authorizations 
SET admission_date = CASE 
    WHEN id % 2 = 0 THEN CURRENT_DATE 
    ELSE CURRENT_DATE - INTERVAL '1 day'
END;

-- Update next_review_date to make exactly 8 due today
UPDATE authorizations 
SET next_review_date = CASE 
    WHEN id <= 8 THEN CURRENT_DATE + (INTERVAL '1 hour' * (id % 12)) + (INTERVAL '1 minute' * (id * 15 % 60))  -- First 8 due today
    WHEN id % 4 = 1 THEN CURRENT_DATE + INTERVAL '1 day' + (INTERVAL '1 hour' * (id % 24))  -- Some due tomorrow
    WHEN id % 4 = 2 THEN CURRENT_DATE + INTERVAL '2 days' + (INTERVAL '1 hour' * (id % 24))  -- Some due in 2 days
    ELSE CURRENT_DATE - INTERVAL '1 day' + (INTERVAL '1 hour' * (id % 24))  -- Some overdue
END;

-- Update created_at to recent dates
UPDATE authorizations 
SET created_at = CURRENT_DATE - (INTERVAL '1 day' * (id % 7));

-- Update updated_at to current timestamp
UPDATE authorizations 
SET updated_at = CURRENT_TIMESTAMP;

-- Verify exactly 8 are due today
SELECT 
    COUNT(*) as due_today_count
FROM authorizations 
WHERE next_review_date::date = CURRENT_DATE;

-- Show the 8 authorizations due today
SELECT 
    authorization_number,
    received_date,
    admission_date,
    next_review_date,
    priority
FROM authorizations 
WHERE next_review_date::date = CURRENT_DATE
ORDER BY next_review_date;

-- Show summary of all due dates
SELECT 
    next_review_date::date as due_date,
    COUNT(*) as count
FROM authorizations 
GROUP BY next_review_date::date
ORDER BY due_date;
