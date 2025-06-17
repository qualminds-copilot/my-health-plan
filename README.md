# MyHealthPlan - Demo Web Application

A streamlined healthcare plan management demo with modern UI and developer-friendly workflow.

## 🚀 Quick Start

### Prerequisites
- Node.js (v16+)
- PostgreSQL (running locally or remotely)

### Setup & Run (2 commands)
```bash
npm run install:all    # Install dependencies
npm start              # Start both frontend & backend (auto-setup database)
```

**That's it!** 🎉
- The database will be automatically created and seeded on first run
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
- ✅ **Auto-setup**: Database automatically created and seeded on first run
- ✅ **Migration System**: Versioned database schema management
- ✅ **Health check**: `/api/health` endpoint with DB connectivity test
- ✅ **Cross-platform**: Works on Windows, macOS, Linux
- ✅ **Single command**: Everything starts with `npm start`

## Database Migration System

This project uses a **lightweight, SQL-based migration system** for reliable database management without external dependencies.

### Key Features
- ✅ **Lightweight**: Pure SQL migrations, no complex ORMs
- ✅ **Versioned**: Timestamp-based migration versioning
- ✅ **Trackable**: Migration history stored in database
- ✅ **Transactional**: Each migration runs in a transaction
- ✅ **CI/CD Ready**: Automatic deployment integration

### Quick Commands
```bash
# Database setup (first time)
npm run db:setup         # Creates DB + runs migrations + seeds

# Daily development
npm run db:status        # Check migration status
npm run db:migrate       # Run pending migrations
cd server && npm run db:create "description"  # Create new migration

# Production (runs automatically in CI/CD)
npm run db:migrate       # Safe for production deployment
```

### Migration Workflow

1. **Create a migration:**
   ```bash
   cd server
   npm run db:create "add_user_preferences"
   ```

2. **Edit the generated file:**
   ```sql
   -- server/db/migrations/20241217120000_add_user_preferences.sql
   CREATE TABLE user_preferences (
       id SERIAL PRIMARY KEY,
       user_id INTEGER NOT NULL,
       preference_key VARCHAR(100) NOT NULL,
       preference_value TEXT,
       created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
       FOREIGN KEY (user_id) REFERENCES users(id)
   );
   ```

3. **Run the migration:**
   ```bash
   npm run db:migrate
   ```

### Migration System Structure
```
server/db/
├── migrator.js                          # Migration engine
├── migrations/
│   └── YYYYMMDDHHMMSS_description.sql   # Migration files
└── seeds/
    └── 001_initial_data.sql             # Seed data
```

### Environment Variables
```env
# Development (.env file)
DB_HOST=localhost
DB_PORT=5432
DB_NAME=my_health_plan
DB_USER=postgres
DB_PASSWORD=your_password

# Production (Railway/Heroku)
DATABASE_URL=postgresql://user:pass@host:port/db
```

### Production Deployment
Migrations run **automatically** in GitHub Actions:
- ✅ Zero-downtime deployments
- ✅ Automatic rollback on failure
- ✅ Transaction safety
- ✅ No manual intervention needed

### Troubleshooting
- **Connection issues**: Ensure PostgreSQL is running
- **Permission errors**: Check database user privileges  
- **Migration conflicts**: Use `npm run db:status` to check state

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

## 📁 Project Structure

### Overview
This is a full-stack healthcare management application with a React frontend and Node.js/Express backend.

### Root Directory
```
my-health-plan/
├── client/                 # React frontend application
├── server/                 # Node.js backend application
├── package.json           # Root package configuration
└── README.md             # Project documentation
```

### Client Structure (React Frontend)
```
client/
├── public/               # Static assets
├── src/
│   ├── components/       # React components
│   │   ├── Dashboard.js
│   │   ├── Header.js
│   │   ├── Login.js
│   │   └── Member.js
│   ├── constants/        # Application constants
│   │   └── index.js
│   ├── hooks/           # Custom React hooks
│   │   └── useAuth.js
│   ├── services/        # API service layer
│   │   ├── apiService.js
│   │   ├── authService.js
│   │   └── memberService.js
│   ├── utils/           # Utility functions
│   │   └── helpers.js
│   ├── App.js           # Main App component
│   ├── App.css          # Application styles
│   └── index.js         # Application entry point
└── package.json         # Client dependencies
```

### Server Structure (Node.js Backend)
```
server/
├── controllers/         # Request handlers (organized by feature)
├── db/                 # Database layer
│   ├── connection.js   # Database connection
│   ├── migrator.js     # Migration engine
│   ├── migrations/     # SQL migration files
│   │   └── YYYYMMDDHHMMSS_description.sql
│   └── seeds/          # Database seed data
│       └── 001_initial_data.sql
├── middleware/         # Express middleware
│   ├── auth.js        # Authentication middleware
│   └── errorHandler.js # Error handling middleware
├── models/            # Data models
│   ├── BaseModel.js   # Base model class
│   ├── User.js        # User model
│   └── Member.js      # Member model
├── routes/            # API routes
│   ├── auth.js        # Authentication routes
│   └── dashboard.js   # Dashboard routes
├── scripts/           # Database & utility scripts
│   ├── db-setup.js    # Database setup & initialization
│   ├── migrate.js     # Migration runner
│   ├── seed.js        # Seed data runner
│   ├── migration-manager.js  # Create migrations & status
│   ├── migration-check.js    # System health check
│   └── generate-user-hashes.js # Password utilities
│   ├── db-setup.js    # Database setup
│   └── generate-user-hashes.js # Password hashing
├── utils/             # Utility functions
│   ├── constants.js   # Server constants
│   └── helpers.js     # Helper functions
├── server.js          # Main server file
└── package.json       # Server dependencies
```

## 🏗️ Architecture & Features

### Frontend (React)
- **Modern React**: Uses hooks, functional components
- **Service Layer**: Centralized API calls with error handling
- **Authentication**: JWT-based authentication with auto-refresh
- **Constants**: Centralized configuration and constants
- **Utilities**: Common helper functions
- **Responsive Design**: Bootstrap-based responsive UI

### Backend (Node.js/Express)
- **MVC Architecture**: Organized controllers, models, and routes
- **Database Layer**: PostgreSQL with connection pooling
- **Authentication**: JWT tokens with refresh capability
- **Error Handling**: Centralized error handling middleware
- **Security**: Input validation, rate limiting, CORS
- **Modular Design**: Reusable models and utilities

## 🔧 Available Scripts

### Root Level Commands
```bash
npm start                    # Start both frontend and backend in development mode
npm run dev                  # Same as npm start
npm run install:all          # Install all dependencies (client + server)
npm run client:dev           # Start only the frontend
npm run server:dev           # Start only the backend
npm run client:build         # Build React app for production
npm run client:build:watch   # Build with watch mode
npm run db:setup             # Initialize database with schema and seed data
npm run passwords:generate   # Regenerate user password hashes
npm run dev:debug            # Start with server debugging enabled
npm run watch                # Watch mode for client builds
npm run test                 # Run all tests
npm run test:server          # Run server tests
npm run lint                 # Run linting on both client and server
npm run clean                # Clean all build artifacts and node_modules
npm run heroku-postbuild     # Production build for deployment
```

### Client-Specific Commands
```bash
cd client
npm start                    # Start React development server
npm run build                # Create production build
npm run build:watch          # Build with file watching
npm test                     # Run React tests
npm run test:watch           # Run tests in watch mode
npm run test:coverage        # Run tests with coverage report
npm run lint                 # Run ESLint
npm run lint:fix             # Fix ESLint issues automatically
npm run format               # Format code with Prettier
```

### Server-Specific Commands
```bash
cd server
npm start                    # Start production server
npm run dev                  # Start with nodemon for development
npm run debug                # Start with debugging enabled
npm run db:setup             # Setup database
npm run db:migrate           # Run database migrations
npm run db:seed              # Seed database with test data
npm test                     # Run server tests
npm run test:watch           # Run tests in watch mode
npm run test:coverage        # Run tests with coverage
npm run lint                 # Run ESLint on server code
npm run lint:fix             # Fix ESLint issues
```

## 🌐 Environment Configuration

### Development
- **Frontend:** http://localhost:3000
- **Backend:** http://localhost:5000
- **Database:** PostgreSQL on localhost:5432

### Production
- Environment variables configured via .env files
- Database connection via DATABASE_URL
- JWT secrets properly configured
- CORS origins restricted

## 🔒 Security Features
- Passwords hashed with bcrypt (12 rounds)
- JWT tokens with expiration
- Input validation and sanitization
- CORS properly configured
- Rate limiting on API endpoints
- Environment variables for sensitive data

## 🗄️ Database Schema
- **Users table** for authentication
- **Members table** for healthcare member data
- **Authorizations table** for healthcare authorizations
- Proper foreign key relationships
- Indexes for performance optimization

## 🚀 API Endpoints
- `POST /api/auth/login` - User authentication
- `POST /api/auth/logout` - User logout
- `GET /api/dashboard/stats` - Dashboard statistics
- `GET /api/dashboard/authorizations` - List authorizations
- `GET /api/dashboard/member/:id` - Get member details
- `GET /api/health` - Health check with database connectivity

## 🧪 Testing
- Unit tests for React components
- API endpoint testing
- Database model testing
- Integration tests for full workflows

## 🚢 Deployment
- **Frontend:** Optimized build for static hosting
- **Backend:** Node.js server with PM2 process management
- **Database:** PostgreSQL with connection pooling
- **Environment:** Docker containers for consistency

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
- Outputs SQL for manual database updates or migration creation
- All users get the same password for simplicity

### 🚨 When to Regenerate
- If you change the default password in the script
- If login authentication stops working
- After modifying the user list in the script

---
Created: June 2025 | Optimized for developer experience
