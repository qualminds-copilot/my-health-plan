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

## Setup Instructions

### Prerequisites
- Node.js (v14 or higher)
- PostgreSQL
- npm or yarn

### Database Setup
1. Create a PostgreSQL database named `my_health_plan`
2. Run the SQL script: `database/01_users_table.sql`

### Backend Setup
1. Navigate to server directory: `cd server`
2. Install dependencies: `npm install`
3. Create `.env` file with your database credentials
4. Start server: `npm start` (runs on port 5000)

### Frontend Setup
1. Navigate to client directory: `cd client`
2. Install dependencies: `npm install`
3. Start development server: `npm start` (runs on port 3000)

## Environment Variables

Create a `.env` file in the `server` directory:

```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=my_health_plan
DB_USER=your_username
DB_PASSWORD=your_password
JWT_SECRET=your_jwt_secret_key
PORT=5000
```

## Usage

1. Start the backend server (port 5000)
2. Start the frontend development server (port 3000)
3. Open browser to `http://localhost:3000`
4. Login with any demo user credentials
5. Explore the dashboard and navigation

## Design Features

- **Header**: Blue navbar with MyHealthPlan logo, navigation menu, and user controls
- **Navigation**: Bold active menu item, faded inactive items, no background highlighting
- **Icons**: Notification, message, settings, and help icons in header
- **User Dropdown**: Clean design without borders, includes logout functionality
- **Responsive**: Mobile-friendly Bootstrap layout
- **Modals**: Blurred background logout confirmation

## Development

This is a demo application focused on visual presentation and navigation. The backend provides basic authentication and user data, while the frontend demonstrates modern React/Bootstrap UI patterns.

Created: June 2025
