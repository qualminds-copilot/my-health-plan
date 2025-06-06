#!/bin/bash
# Database setup script - run these commands in order
# Run from the database directory: cd /Users/samanth/Project_AI/my_health_plan/database

echo "Setting up MyHealthPlan database tables..."

# Step 1: Create users table (already exists)
echo "1. Creating users table..."
psql -U postgres -d myhealthplan -f 01_users_table.sql

# Step 2: Create members table
echo "2. Creating members table..."
psql -U postgres -d myhealthplan -f 02_members_table.sql

# Step 3: Create providers table
echo "3. Creating providers table..."
psql -U postgres -d myhealthplan -f 03_providers_table.sql

# Step 4: Create diagnoses table
echo "4. Creating diagnoses table..."
psql -U postgres -d myhealthplan -f 04_diagnoses_table.sql

# Step 5: Create DRG codes table
echo "5. Creating DRG codes table..."
psql -U postgres -d myhealthplan -f 05_drg_codes_table.sql

# Step 6: Create authorizations table (main table)
echo "6. Creating authorizations table..."
psql -U postgres -d myhealthplan -f 06_authorizations_table.sql

# Step 7: Create dashboard views
echo "7. Creating dashboard views..."
psql -U postgres -d myhealthplan -f 07_dashboard_view.sql

echo "Database setup complete!"
echo ""
echo "You can now query the dashboard data with:"
echo "SELECT * FROM authorization_dashboard;"
echo "SELECT * FROM dashboard_summary;"
