# MyHealthPlan - Demo Web Application

A streamlined healthcare plan management demo with modern UI and developer-friendly workflow.

## 🚀 Quick Start

### Prerequisites
- Node.js (v16+)
- PostgreSQL (running)

### Setup & Run (3 commands)
```bash
npm run install:all    # Install dependencies
npm run db:setup       # Setup database (one-time)
npm start              # Start both frontend & backend
```

**That's it!** 🎉
- Frontend: http://localhost:3000
- Backend: http://localhost:5000/api/health

## Tech Stack
- **Frontend**: React + Bootstrap 5
- **Backend**: Node.js + Express
- **Database**: PostgreSQL
- **Auth**: JWT + bcrypt

## Demo Login
All users use the password: **password123**

- **admin@myhealthplan.com** (System Administrator - Admin)
- **maria.hartsell@myhealthplan.com** (Maria Hartsell - Admin)  
- **john.doe@myhealthplan.com** (John Doe - User)
- **jane.smith@myhealthplan.com** (Jane Smith - User)

## Development Features
- ✅ **Auto-reload**: Both frontend and backend restart on file changes
- ✅ **Hot reload**: React Fast Refresh for instant UI updates
- ✅ **Health check**: `/api/health` endpoint with DB connectivity test
- ✅ **Cross-platform**: Works on Windows, macOS, Linux
- ✅ **Single command**: Everything starts with `npm start`

## Environment Setup
Create `server/.env` with your database credentials:
```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=my_health_plan
DB_USER=your_username
DB_PASSWORD=your_password
JWT_SECRET=your_jwt_secret_key
```

## Available Commands
```bash
npm start                    # Start both servers with auto-reload
npm run install:all          # Install all dependencies
npm run db:setup             # Setup database schema & demo data
npm run client:dev           # Frontend only
npm run server:dev           # Backend only
npm run client:build         # Build for production
npm run passwords:generate   # Regenerate user password hashes
```

## Project Structure
```
my-health-plan/
├── client/            # React frontend
├── server/            # Express backend
├── database/          # SQL schema & demo data
└── README.md
```

## Features
- User authentication with JWT
- Responsive Bootstrap UI
- Clean header navigation with icons
- User profile dropdown
- Modern blue theme
- Mobile-friendly design

## Development Workflow
1. Edit files in `client/` or `server/`
2. Changes auto-reload instantly
3. Check http://localhost:5000/api/health for backend status
4. Use browser dev tools for frontend debugging

## Troubleshooting

**Database connection issues?**
- Ensure PostgreSQL is running
- Check credentials in `server/.env`
- Try: `npm run db:setup`

**Port conflicts?**
- Default ports: 3000 (frontend), 5000 (backend)
- Kill existing processes or change ports in config

**Auto-reload not working?**
- Save files (Ctrl+S)
- Check terminal for errors
- Restart: Ctrl+C then `npm start`

## Password Management

### 🔒 Simple Password System
All users share the same password: **`password123`**

### 🛠️ Password Commands
```bash
npm run passwords:generate   # Regenerate password hashes if needed
```

### 🔧 How It Works
- Uses bcrypt with 10 salt rounds for security
- Automatically updates `database/data.sql` when regenerated
- All users get the same password for simplicity

### 🚨 When to Regenerate
- If you change the default password in the script
- If login authentication stops working
- After modifying the user list in the script

---
Created: June 2025 | Optimized for developer experience
