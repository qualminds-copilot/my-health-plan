#!/bin/bash

# Database setup script for MyHealthPlan
# This script will create all necessary tables and populate them with sample data

echo "Setting up MyHealthPlan database..."

# Database connection parameters
DB_NAME="my_health_plan"
DB_USER="postgres"
DB_HOST="localhost"
DB_PORT="5432"

# Check if PostgreSQL is running
if ! pg_isready -h $DB_HOST -p $DB_PORT; then
    echo "Error: PostgreSQL is not running on $DB_HOST:$DB_PORT"
    echo "Please start PostgreSQL and try again."
    exit 1
fi

# Navigate to database directory
cd "$(dirname "$0")"

echo "Creating database tables..."

# Run each SQL file in order
echo "1. Creating users table..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f 01_users_table.sql

echo "2. Creating members table..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f 02_members_table.sql

echo "3. Creating providers table..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f 03_providers_table.sql

echo "4. Creating diagnoses and DRG tables..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f 04_diagnoses_drg_tables.sql

echo "5. Creating authorizations table..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f 05_authorizations_table.sql

echo "6. Creating authorization support tables..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f 06_authorization_support_tables.sql

echo "7. Creating dashboard support tables..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f 07_dashboard_support_tables.sql

echo "8. Updating dashboard statistics..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT update_dashboard_stats();"

echo ""
echo "Database setup complete!"
echo ""
echo "Tables created:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT 
    tablename,
    schemaname
FROM pg_tables 
WHERE schemaname = 'public' 
ORDER BY tablename;"

echo ""
echo "Sample data summary:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT 
    'Members' as table_name, COUNT(*) as record_count FROM members
UNION ALL
SELECT 'Providers', COUNT(*) FROM providers
UNION ALL
SELECT 'Diagnoses', COUNT(*) FROM diagnoses
UNION ALL
SELECT 'DRG Codes', COUNT(*) FROM drg_codes
UNION ALL
SELECT 'Authorizations', COUNT(*) FROM authorizations
UNION ALL
SELECT 'Users', COUNT(*) FROM users
ORDER BY table_name;"
