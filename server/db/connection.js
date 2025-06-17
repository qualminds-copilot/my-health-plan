const { Pool } = require('pg');
require('dotenv').config();

let pool;

if (process.env.NODE_ENV === 'production') {
  console.log('🚀 Using production database configuration');
  pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: {
      rejectUnauthorized: false
    }
  });
} else {
  console.log('🏠 Using development database configuration');
  pool = new Pool({
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME || 'my_health_plan',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD,
  });
}

module.exports = pool;
