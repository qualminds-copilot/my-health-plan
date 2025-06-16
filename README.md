# MyHealthPlan - Demo Web Application

A simple, read-only demo web application for healthcare plan management with a modern, responsive UI.

## Tech Stack

- **Frontend**: React with Bootstrap 5 styling
- **Backend**: Node.js with Express
- **Database**: PostgreSQL
- **Authentication**: JWT tokens with bcrypt password hashing

## Features

- User authentication (login/logout)
- Responsive dashboard with Bootstrap components
- Clean header navigation with icons
- User dropdown with profile information
- Modern UI with blue header theme
- Demo data pre-populated in database

## Demo Users

All demo users use the password: `password123`

- admin@example.com (Admin)
- manager@example.com (Manager) 
- user@example.com (User)

## Project Structure

```
my_health_plan/
├── client/          # React frontend
├── server/          # Express backend API
├── database/        # SQL schema and demo data
└── README.md
```

## Quick Start (One Command Setup)

### Prerequisites
- Node.js (v16 or higher)
- PostgreSQL server running
- npm

### Simple Development Setup

1. **Clone and navigate to the project**:
   ```bash
   cd my-health-plan
   ```

2. **Install all dependencies**:
   ```bash
   npm run install:all
   ```

3. **Setup database** (one-time only):
   ```bash
   npm run db:setup
   ```

4. **Start development environment**:
   ```bash
   npm start
   ```

That's it! This single command will:
- Start the backend server on port 5000 with auto-reload
- Start the frontend development server on port 3000 with auto-reload
- Enable hot reloading for both frontend and backend changes

### Health Check
- Backend health check (includes DB connectivity): http://localhost:5000/api/health
- Frontend application: http://localhost:3000

## Environment Configuration

The server will automatically look for a `.env` file in the `server` directory. Create one with your database credentials:

```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=my_health_plan
DB_USER=your_username
DB_PASSWORD=your_password
JWT_SECRET=your_jwt_secret_key
PORT=5000
```

## Available Scripts

From the root directory:

- `npm start` - Start both frontend and backend with auto-reload
- `npm run install:all` - Install dependencies for root, client, and server
- `npm run db:setup` - Setup database schema and demo data (one-time)
- `npm run client:dev` - Start only the frontend
- `npm run server:dev` - Start only the backend
- `npm run client:build` - Build frontend for production

## Development Workflow

1. Make changes to either frontend (`client/` folder) or backend (`server/` folder)
2. Changes are automatically detected and servers restart/reload
3. No need to manually restart servers during development
4. Use the health check endpoint to verify backend and database connectivity

## Design Features

- **Header**: Blue navbar with MyHealthPlan logo, navigation menu, and user controls
- **Navigation**: Bold active menu item, faded inactive items, no background highlighting
- **Icons**: Notification, message, settings, and help icons in header
- **User Dropdown**: Clean design without borders, includes logout functionality
- **Responsive**: Mobile-friendly Bootstrap layout
- **Modals**: Blurred background logout confirmation

## Development

This is a streamlined demo application focused on developer experience and modern UI patterns. The development workflow has been optimized for:

- **Single Command Start**: Everything runs with `npm start`
- **Auto-reload**: Both frontend and backend restart automatically on file changes  
- **Health Monitoring**: Built-in health check with database connectivity verification
- **Cross-platform**: Works seamlessly on Windows, macOS, and Linux
- **Modern Stack**: React frontend with Express backend and PostgreSQL database

The application demonstrates modern React/Bootstrap UI patterns with a focus on clean architecture and developer-friendly workflows.

Created: June 2025
