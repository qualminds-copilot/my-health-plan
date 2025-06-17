const express = require('express');
const cors = require('cors');
const { errorHandler, notFound } = require('./middleware/errorHandler');
const DatabaseCLI = require('./scripts/db');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/dashboard', require('./routes/dashboard'));

// Enhanced health check with database connectivity
app.get('/api/health', async (req, res) => {
  const health = {
    status: 'OK',
    timestamp: new Date().toISOString(),
    server: 'Running',
    database: 'Unknown'
  };

  try {
    // Test database connection
    const pool = require('./db/connection');
    const result = await pool.query('SELECT 1 as test');
    health.database = 'Connected';
    health.database_test = result.rows[0].test === 1 ? 'Passed' : 'Failed';
  } catch (error) {
    health.status = 'WARNING';
    health.database = 'Disconnected';
    health.database_error = error.message;
  }

  res.json(health);
});

// Catch-all for API routes not found - should be after specific API routes
app.use('/api/*', (req, res) => {
  res.status(404).json({ error: 'API endpoint not found' });
});

// Error handling middleware
app.use(notFound);
app.use(errorHandler);

// Graceful shutdown handler
const gracefulShutdown = () => {
  console.log('Received shutdown signal, closing HTTP server...');
  const pool = require('./db/connection');
  pool.end(() => {
    console.log('Database connection pool closed.');
    process.exit(0);
  });
};

process.on('SIGTERM', gracefulShutdown);
process.on('SIGINT', gracefulShutdown);

// Initialize database and start server
async function startServer() {
  try {
    console.log('🚀 Starting MyHealthPlan server...');
    console.log('Environment:', process.env.NODE_ENV || 'development');
    console.log('Port:', PORT);

    // Auto-setup database on first run
    console.log('🗄️  Checking database setup...');
    const db = new DatabaseCLI();
    await db.setup();

    app.listen(PORT, () => {
      console.log(`✅ Server running on port ${PORT}`);
      console.log(`📊 Health check: http://localhost:${PORT}/api/health`);
    });
  } catch (error) {
    console.error('❌ Failed to start server:', error.message);
    console.error('Error stack:', error.stack);
    console.error('💡 Database connection issue. Check DATABASE_URL in production or .env in development');
    process.exit(1);
  }
}

startServer();
