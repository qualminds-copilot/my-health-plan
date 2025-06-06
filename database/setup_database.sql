-- Master script to create all database tables in order
-- Run this script to set up the complete database schema

-- Start transaction
BEGIN;

-- 1. Users table (already exists)
\i 01_users_table.sql

-- 2. Members table
\i 02_members_table.sql

-- 3. Providers table
\i 03_providers_table.sql

-- 4. Diagnoses and DRG tables
\i 04_diagnoses_drg_tables.sql

-- 5. Main authorizations table
\i 05_authorizations_table.sql

-- 6. Authorization support tables
\i 06_authorization_support_tables.sql

-- 7. Dashboard support tables and functions
\i 07_dashboard_support_tables.sql

-- Commit transaction
COMMIT;

-- Update initial dashboard statistics
SELECT update_dashboard_stats();

-- Display summary of created tables
SELECT 
    schemaname,
    tablename,
    tableowner
FROM pg_tables 
WHERE schemaname = 'public' 
ORDER BY tablename;
