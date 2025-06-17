# GitHub Copilot Instructions for MyHealthPlan

This file provides context and coding guidelines for GitHub Copilot when working on the MyHealthPlan project.

## Project Overview

MyHealthPlan is a **healthcare plan management MVP (Minimum Viable Product) demo application** with:
- **Purpose**: Proof-of-concept for healthcare authorization management
- **Scope**: Core features only - authentication, dashboard, member lookup, authorization tracking
- **Target**: Demo/prototype to validate concept and gather feedback
- **Frontend**: React with Bootstrap 5, functional components, hooks
- **Backend**: Node.js/Express with PostgreSQL 
- **Authentication**: JWT-based with bcrypt password hashing
- **Database**: Custom SQL-based migration system (no ORM)
- **Architecture**: Clean separation of concerns, MVC pattern

## Core Technologies & Versions

- **Node.js**: v16+
- **React**: Latest with hooks and functional components
- **PostgreSQL**: Latest with connection pooling
- **Express**: v4.18+
- **JWT**: jsonwebtoken v9.0+
- **bcrypt**: v5.1+ (10 salt rounds)
- **Bootstrap**: v5 for styling

## Project Structure Conventions

```
my-health-plan/
├── client/src/
│   ├── components/     # React functional components
│   ├── services/       # API service layer
│   ├── hooks/          # Custom React hooks
│   ├── constants/      # Application constants
│   └── utils/          # Helper functions
└── server/
    ├── routes/         # Express routes (contains route handlers)
    ├── models/         # Database models (BaseModel pattern)
    ├── middleware/     # Express middleware
    ├── db/            # Database connection & migrations
    ├── scripts/       # Utility scripts (db.js CLI)
    └── utils/         # Server utilities
```

## Coding Standards & Best Practices

### General Guidelines
- **MVP First**: Prioritize working features over perfect code
- **ES6+**: Use modern JavaScript features (async/await, destructuring, arrow functions)
- **Error Handling**: Basic try-catch blocks for async operations, user-friendly messages
- **Logging**: Use console.log with emojis for better visibility (🚀, ✅, ❌, 🔄)
- **Comments**: Add JSDoc comments for complex functions only
- **Security**: Basic security measures, environment variables for secrets
- **Demo-Ready**: Code should work reliably for demonstrations

### Frontend (React) Guidelines
- **MVP Simplicity**: Functional components with hooks, avoid complex state management
- **Bootstrap First**: Use Bootstrap 5 classes extensively, minimal custom CSS
- **Service Layer**: Use the service layer (apiService.js, authService.js) for API calls
- **Demo UX**: Focus on working functionality over pixel-perfect design
- **Error Handling**: Display user-friendly error messages with fallbacks
- **Authentication**: Use the useAuth hook for auth state management

### Backend (Node.js/Express) Guidelines
- **MVP Architecture**: Simple routes with direct database queries, avoid over-abstraction
- **Models**: Extend BaseModel class for common operations, keep business logic minimal
- **Routes**: Use express.Router() and middleware (route handlers are in routes/, not controllers/)
- **Database**: Use the pool connection, avoid complex ORM patterns
- **Validation**: Basic input validation, sanitize data for demo safety
- **Responses**: Use consistent response format with appropriate HTTP status codes
- **Authentication**: Use JWT middleware for protected routes, simple role checking

### Database Guidelines
- **MVP Migration Strategy**: Use the custom CLI for schema changes (`npm run db:create "description"`)
- **SQL**: Write clean, readable SQL focused on core functionality, basic indexing
- **Transactions**: Use transactions for multi-step operations where data integrity matters
- **Naming**: Use snake_case for database columns, camelCase in JavaScript
- **Foreign Keys**: Define relationships for core entities, avoid over-normalization
- **Demo Data**: Seed with realistic sample data for effective demonstrations

## Authentication System

- **Password**: All demo users use `password123`
- **Hashing**: bcrypt with 10 salt rounds
- **Tokens**: JWT with 24h expiration
- **Demo Users**:
  - `admin@myhealthplan.com` (Admin)
  - `maria.hartsell@myhealthplan.com` (Admin)
  - `john.doe@myhealthplan.com` (User)
  - `jane.smith@myhealthplan.com` (User)

## Database Migration System

- **CLI Tool**: `server/scripts/db.js` handles all database operations
- **Commands**:
  - `npm run db:setup` - Full database setup
  - `npm run db:migrate` - Run pending migrations
  - `npm run db:create "name"` - Create new migration
  - `npm run db:status` - Check migration status
- **File Format**: `YYYYMMDDHHMMSS_description.sql`
- **Tracking**: Uses `schema_migrations` table for versioning

## API Conventions

### Endpoints Structure
- **Auth**: `/api/auth/*` (login, logout, me)
- **Dashboard**: `/api/dashboard/*` (stats, authorizations, member details)
- **Health**: `/api/health` (system health check)
- **Members**: `/api/dashboard/member/:memberNumber` (member details)
- **Authorizations**: `/api/dashboard/authorizations/:id` (authorization details)

### Response Format
```javascript
// Success Response
{
  success: true,
  data: {...},
  message: "Operation completed successfully"
}

// Error Response
{
  success: false,
  error: "Error message",
  details: {...}
}
```

### HTTP Status Codes
- **200**: Success
- **201**: Created
- **400**: Bad Request
- **401**: Unauthorized
- **404**: Not Found
- **500**: Internal Server Error

## Environment Configuration

### Development (.env)
```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=my_health_plan
DB_USER=postgres
DB_PASSWORD=your_password
JWT_SECRET=your_jwt_secret_key
```

### Production
- Use `DATABASE_URL` for PostgreSQL connection
- Set `NODE_ENV=production`
- Configure SSL for database connections

## Common Patterns & Examples

### Database Model Pattern
```javascript
class ExampleModel extends BaseModel {
    constructor() {
        super('table_name');
    }
    
    async customMethod(params) {
        const query = `SELECT * FROM ${this.tableName} WHERE condition = $1`;
        return await this.query(query, [params]);
    }
}
```

### React Component Pattern
```javascript
import { useState, useEffect } from 'react';
import { useAuth } from '../hooks/useAuth';
import apiService from '../services/apiService';

const ExampleComponent = () => {
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(true);
    const { user } = useAuth();

    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await apiService.get('/endpoint');
                setData(response.data);
            } catch (error) {
                console.error('Failed to fetch data:', error);
            } finally {
                setLoading(false);
            }
        };
        fetchData();
    }, []);

    return (
        <div className="container-fluid">
            {/* Component content */}
        </div>
    );
};
```

### Express Route Pattern
```javascript
const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const Model = require('../models/Model');

router.get('/endpoint', auth, async (req, res) => {
    try {
        const data = await Model.findAll();
        res.json({
            success: true,
            data,
            message: 'Data retrieved successfully'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
});
```

## Testing Guidelines

- **Unit Tests**: Test individual functions and components
- **Integration Tests**: Test API endpoints and database operations
- **Error Cases**: Always test error handling paths
- **Authentication**: Test both authenticated and unauthenticated scenarios

## MVP Testing Guidelines

- **Manual Testing Priority**: Focus on manual testing of core workflows over automated tests
- **Happy Path Testing**: Ensure main user journeys work reliably
- **Demo Scenarios**: Test with realistic demo data that tells a story
- **Error Scenarios**: Basic error handling, graceful degradation
- **Browser Testing**: Test in Chrome/Firefox, mobile responsive design
- **Performance**: Ensure reasonable load times for demo purposes

## Security Considerations

- **Input Validation**: Validate and sanitize all user inputs
- **SQL Injection**: Use parameterized queries only
- **XSS Prevention**: Escape HTML content
- **CORS**: Configure proper CORS policies
- **Rate Limiting**: Implement rate limiting for API endpoints
- **Environment Variables**: Never commit secrets to version control

## MVP Security Considerations

- **Basic Security**: Input validation, SQL injection prevention, XSS protection
- **Demo Credentials**: Fixed demo passwords, clear user instructions
- **Environment Separation**: Clear development vs. demo environment setup
- **CORS**: Properly configured for demo hosting
- **Authentication**: JWT tokens with reasonable expiration times
- **Data Protection**: Demo data only, no real sensitive information

## Performance Guidelines

- **Database**: Use indexes for frequently queried columns
- **Queries**: Avoid N+1 query problems
- **Caching**: Implement caching where appropriate
- **Bundle Size**: Keep client bundle size optimized
- **Connection Pooling**: Use connection pooling for database

## MVP Performance Guidelines

- **Demo Performance**: Optimize for smooth demo experience
- **Database Queries**: Keep queries simple and fast for demo data
- **Loading States**: Show loading indicators for better UX
- **Error Feedback**: Quick error recovery and clear messages
- **Mobile Responsive**: Works well on tablets and phones for demos
- **Fast Load Times**: Optimize bundle size for quick initial load

## Deployment Considerations

- **Environment Variables**: Set all required environment variables
- **Database Migrations**: Run migrations before deployment
- **Health Checks**: Ensure health endpoint returns proper status
- **Logging**: Implement proper logging for production debugging
- **Error Monitoring**: Set up error tracking and monitoring

## Development Workflow

1. **MVP Feature Development**:
   - Focus on user-visible functionality first
   - Create database migrations only if needed for core features
   - Implement backend API endpoints with basic validation
   - Create/update React components with Bootstrap styling
   - Add basic error handling and user feedback
   - Test core user workflows (login → dashboard → member lookup)

2. **Database Changes**:
   - Use `npm run db:create "description"` for schema changes
   - Write clean SQL focused on essential functionality
   - Test migrations with demo data
   - Update seed data to support new features

3. **MVP Testing Strategy**:
   - Manual testing of core user workflows
   - Test with demo data and edge cases
   - Verify authentication and navigation flows
   - Check responsive design on different screen sizes
   - Ensure error states are user-friendly

## Common Issues & Solutions

- **Database Connection**: Check PostgreSQL service and credentials
- **Authentication Failures**: Verify JWT secret and token expiration
- **CORS Issues**: Configure CORS middleware properly
- **Migration Errors**: Check SQL syntax and database permissions
- **Port Conflicts**: Use different ports or kill existing processes

## File Naming Conventions

- **React Components**: PascalCase (`Dashboard.js`, `LoginForm.js`)
- **Services/Utilities**: camelCase (`apiService.js`, `authHelper.js`)
- **Database Files**: snake_case (`20241217000000_initial_schema.sql`)
- **Constants**: UPPER_SNAKE_CASE for values, camelCase for files

## Code Quality Standards

- **Linting**: Follow ESLint rules
- **Formatting**: Use consistent code formatting
- **Documentation**: Add JSDoc comments for complex functions
- **Error Messages**: Provide clear, actionable error messages
- **Logging**: Use structured logging with appropriate log levels

## Database Schema Overview

### Core Business Tables
- **users**: Authentication and user management
- **members**: Healthcare plan members with demographics
- **authorizations**: Healthcare authorization requests (main business entity)
- **providers**: Healthcare providers and facilities
- **diagnoses**: Medical diagnoses with ICD codes
- **drg_codes**: Diagnosis-Related Group codes for billing

### Reference Tables
- **priority_levels**: Authorization priority levels (High, Medium, Low)
- **review_types**: Types of review processes
- **status_types**: Authorization status tracking
- **dashboard_stats**: Cached dashboard statistics

### Key Relationships
- Members have multiple authorizations
- Authorizations link to providers, diagnoses, and DRG codes
- All entities have proper foreign key constraints
- Indexes optimized for dashboard queries

---

*This file provides comprehensive guidance for GitHub Copilot when working on MyHealthPlan. Follow these conventions to maintain code quality and consistency across the project. Remember: this is an MVP - prioritize working features and demo readiness over production perfection.*
