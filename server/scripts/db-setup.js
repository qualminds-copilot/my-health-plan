#!/usr/bin/env node

/**
 * Simple Database Setup Script
 * Creates database, runs schema, and seeds data if needed
 */

const { Client } = require('pg');
const fs = require('fs');
const path = require('path');
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
        console.log('Creating database if needed...');

        const result = await adminClient.query(
            'SELECT 1 FROM pg_database WHERE datname = $1',
            [dbName]
        );

        if (result.rows.length === 0) {
            await adminClient.query(`CREATE DATABASE "${dbName}"`);
            console.log(`✅ Database ${dbName} created`);
        } else {
            console.log(`✅ Database ${dbName} already exists`);
        }
    } catch (error) {
        console.error('❌ Error creating database:', error.message);
        throw error;
    } finally {
        await adminClient.end();
    }

    // Step 2: Setup schema and data
    const dbClient = new Client({ ...config, database: dbName });

    try {
        await dbClient.connect();

        // Check if already setup
        const tableCheck = await dbClient.query(
            "SELECT 1 FROM information_schema.tables WHERE table_name = 'users'"
        );

        if (tableCheck.rows.length === 0) {
            console.log('Setting up database schema...');

            // Run schema
            const schemaPath = path.join(__dirname, '..', '..', 'database', 'schema.sql');
            if (fs.existsSync(schemaPath)) {
                const schema = fs.readFileSync(schemaPath, 'utf8');
                await dbClient.query(schema);
                console.log('✅ Schema created');
            }

            // Run seed data
            const dataPath = path.join(__dirname, '..', '..', 'database', 'data.sql');
            if (fs.existsSync(dataPath)) {
                const data = fs.readFileSync(dataPath, 'utf8');
                await dbClient.query(data);
                console.log('✅ Sample data loaded');
            }

            console.log('🎉 Database setup completed!');
        } else {
            console.log('✅ Database already setup');
        }

    } catch (error) {
        console.error('❌ Setup failed:', error.message);
        throw error;
    } finally {
        await dbClient.end();
    }
}

async function main() {
    try {
        await setupDatabase();
        process.exit(0);
    } catch (error) {
        console.error('Setup failed:', error.message);
        process.exit(1);
    }
}

if (require.main === module) {
    main();
}

module.exports = { setupDatabase };
