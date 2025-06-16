# MyHealthPlan - Simple Setup Guide

## Quick Start (3 Steps)

### 1. Prerequisites
- Node.js (v14+)
- PostgreSQL (v12+)

### 2. Install & Configure
```bash
# Clone and install
git clone <your-repo-url>
cd my-health-plan
npm run install:all

# Setup environment
cd server
cp .env.example .env
# Edit .env with your PostgreSQL credentials
```

### 3. Run
```bash
# Setup database (run once)
npm run setup

# Start application
npm run dev
```

**That's it!** 🎉

- Frontend: http://localhost:3000
- Backend: http://localhost:5000

## Environment Setup (.env file)

Only edit these in `/server/.env`:
```
DB_USER=postgres
DB_PASSWORD=your_password
```

Everything else has defaults:
- DB_HOST=localhost
- DB_PORT=5432  
- DB_NAME=my_health_plan
- PORT=5000

## Production Deployment

### Option 1: Simple Server
```bash
# On your server
git clone <repo>
cd my-health-plan
npm run install:all
cd server
# Set environment variables or create .env
npm run db:setup
cd ..
npm run client:build
npm start
```

### Option 2: Platform Deployment (Heroku, Railway, etc.)
Just set these environment variables:
```
DATABASE_URL=postgresql://user:pass@host:port/db
NODE_ENV=production
```

The app will automatically create the database and schema on first run.

## What It Does

1. **Database Setup**: Creates PostgreSQL database if it doesn't exist
2. **Schema Creation**: Sets up all tables, indexes, and relationships  
3. **Sample Data**: Loads realistic test data for immediate use
4. **Auto Migration**: Future schema changes are handled automatically

## Sample Login
- Username: `admin`
- Password: `password`

## Adding Database Changes

For future schema changes, just edit:
- `/database/schema.sql` - for structure changes
- `/database/data.sql` - for new sample data

Then run: `npm run setup`

## Troubleshooting

**Database connection fails?**
- Check PostgreSQL is running
- Verify credentials in `.env`
- Ensure user has database creation rights

**Setup fails?**
- Check PostgreSQL logs
- Try manual database creation: `createdb my_health_plan`
- Run setup again: `npm run setup`

That's all you need for your MVP! 🚀
