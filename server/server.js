const express = require('express');
const cors = require('cors');
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

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
