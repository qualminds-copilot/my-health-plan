#!/usr/bin/env node

/**
 * Database Setup Script with Migration System
 * Creates database and runs migrations/seeds if needed
 */

const { Client } = require('pg');
const Migrator = require('../db/migrator');
require('dotenv').config();

const config = {
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD,
};

const dbName = process.env.DB_NAME || 'my_health_plan';

async function setupDatabase() {
    // Step 1: Create database if not exists
    const adminClient = new Client(config);

    try {
        await adminClient.connect();
        console.log('🔍 Checking database existence...');

        const result = await adminClient.query(
            'SELECT 1 FROM pg_database WHERE datname = $1',
            [dbName]
        );

        if (result.rows.length === 0) {
            await adminClient.query(`CREATE DATABASE "${dbName}"`);
            console.log(`✅ Database ${dbName} created successfully`);
        } else {
            console.log(`✅ Database ${dbName} already exists`);
        }
    } catch (error) {
        console.error('❌ Error creating database:', error.message);
        if (error.code === 'ECONNREFUSED') {
            console.error('💡 Make sure PostgreSQL is running on your system');
            console.error('   Windows: Check if PostgreSQL service is started');
            console.error('   Mac: brew services start postgresql');
            console.error('   Linux: sudo systemctl start postgresql');
        } else if (error.code === '28P01') {
            console.error('💡 Authentication failed - check your database credentials in server/.env');
        }
        process.exit(1);
    } finally {
        await adminClient.end();
    }

    // Step 2: Run migrations
    console.log('\n🚀 Running database migrations...');
    const migrator = new Migrator();

    try {
        await migrator.migrate();

        // Step 3: Run seeds (only if no data exists)
        console.log('\n🌱 Checking if seeding is needed...');
        await migrator.seed();

        console.log('\n🎉 Database setup completed successfully!');
    } catch (error) {
        console.error('❌ Database setup failed:', error.message);
        process.exit(1);
    }
}

if (require.main === module) {
    setupDatabase().catch(error => {
        console.error('Fatal error:', error);
        process.exit(1);
    });
}

module.exports = { setupDatabase };
