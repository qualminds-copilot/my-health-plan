#!/usr/bin/env node

/**
 * Database Management CLI
 * Unified tool for database operations in MyHealthPlan
 * 
 * Usage:
 *   npm run db:migrate     - Run pending migrations
 *   npm run db:seed        - Run database seeds
 *   npm run db:status      - Show migration status
 *   npm run db:create      - Create new migration
 *   npm run db:setup       - Full database setup
 *   npm run db:check       - Health check
 */

const fs = require('fs').promises;
const path = require('path');
const { Client } = require('pg');
const pool = require('../db/connection');
require('dotenv').config();

class DatabaseCLI {
    constructor() {
        this.migrationsDir = path.join(__dirname, '..', 'db', 'migrations');
        this.seedsDir = path.join(__dirname, '..', 'db', 'seeds');
        this.dbConfig = {
            host: process.env.DB_HOST || 'localhost',
            port: process.env.DB_PORT || 5432,
            user: process.env.DB_USER || 'postgres',
            password: process.env.DB_PASSWORD,
        };
        this.dbName = process.env.DB_NAME || 'my_health_plan';
    }

    /**
     * Initialize migration system
     */
    async initialize() {
        const client = await pool.connect();
        try {
            await client.query(`
                CREATE TABLE IF NOT EXISTS schema_migrations (
                    id SERIAL PRIMARY KEY,
                    version VARCHAR(255) NOT NULL UNIQUE,
                    name VARCHAR(255) NOT NULL,
                    executed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                    checksum VARCHAR(64),
                    execution_time_ms INTEGER
                );
                
                CREATE INDEX IF NOT EXISTS idx_schema_migrations_version 
                ON schema_migrations(version);
            `);
        } finally {
            client.release();
        }
    }

    /**
     * Get migration files
     */
    async getMigrationFiles() {
        try {
            const files = await fs.readdir(this.migrationsDir);
            return files
                .filter(file => file.endsWith('.sql'))
                .sort()
                .map(file => ({
                    filename: file,
                    version: file.split('_')[0],
                    name: file.replace(/^\d+_/, '').replace('.sql', ''),
                    filepath: path.join(this.migrationsDir, file)
                }));
        } catch (error) {
            if (error.code === 'ENOENT') {
                await fs.mkdir(this.migrationsDir, { recursive: true });
                return [];
            }
            throw error;
        }
    }

    /**
     * Get executed migrations
     */
    async getExecutedMigrations() {
        const client = await pool.connect();
        try {
            const result = await client.query(
                'SELECT version, name, executed_at FROM schema_migrations ORDER BY version'
            );
            return result.rows;
        } catch (error) {
            if (error.code === '42P01') return [];
            throw error;
        } finally {
            client.release();
        }
    }

    /**
     * Calculate checksum
     */
    calculateChecksum(content) {
        const crypto = require('crypto');
        return crypto.createHash('sha256').update(content).digest('hex');
    }

    /**
     * Execute migration
     */
    async executeMigration(migration) {
        const client = await pool.connect();
        const startTime = Date.now();

        try {
            await client.query('BEGIN');
            const content = await fs.readFile(migration.filepath, 'utf8');
            const checksum = this.calculateChecksum(content);

            console.log(`🔄 Executing: ${migration.version}_${migration.name}`);
            await client.query(content);

            const executionTime = Date.now() - startTime;
            await client.query(`
                INSERT INTO schema_migrations (version, name, checksum, execution_time_ms)
                VALUES ($1, $2, $3, $4)
            `, [migration.version, migration.name, checksum, executionTime]);

            await client.query('COMMIT');
            console.log(`✅ Completed: ${migration.version}_${migration.name} (${executionTime}ms)`);
        } catch (error) {
            await client.query('ROLLBACK');
            console.error(`❌ Failed: ${migration.version}_${migration.name} - ${error.message}`);
            throw error;
        } finally {
            client.release();
        }
    }

    /**
     * Command: migrate
     */
    async migrate() {
        console.log('🚀 Running database migrations...');
        await this.initialize();

        const allMigrations = await this.getMigrationFiles();
        const executedMigrations = await this.getExecutedMigrations();
        const executedVersions = new Set(executedMigrations.map(m => m.version));

        const pendingMigrations = allMigrations.filter(
            migration => !executedVersions.has(migration.version)
        );

        if (pendingMigrations.length === 0) {
            console.log('✅ No pending migrations');
            return;
        }

        console.log(`📋 Found ${pendingMigrations.length} pending migration(s)`);
        for (const migration of pendingMigrations) {
            await this.executeMigration(migration);
        }
        console.log('🎉 All migrations completed');
    }

    /**
     * Command: seed
     */
    async seed() {
        console.log('🌱 Running database seeds...');

        try {
            const files = await fs.readdir(this.seedsDir);
            const seedFiles = files.filter(file => file.endsWith('.sql')).sort();

            if (seedFiles.length === 0) {
                console.log('📁 No seed files found');
                return;
            }

            const client = await pool.connect();
            try {
                for (const seedFile of seedFiles) {
                    console.log(`🔄 Running: ${seedFile}`);
                    const content = await fs.readFile(path.join(this.seedsDir, seedFile), 'utf8');
                    await client.query(content);
                    console.log(`✅ Completed: ${seedFile}`);
                }
                console.log('🎉 All seeds completed');
            } finally {
                client.release();
            }
        } catch (error) {
            if (error.code === 'ENOENT') {
                await fs.mkdir(this.seedsDir, { recursive: true });
                console.log('✅ Seeds directory created');
                return;
            }
            throw error;
        }
    }

    /**
     * Command: status
     */
    async status() {
        await this.initialize();
        const allMigrations = await this.getMigrationFiles();
        const executedMigrations = await this.getExecutedMigrations();
        const executedVersions = new Set(executedMigrations.map(m => m.version));

        console.log('\n📊 Migration Status:');
        console.log('==================');

        if (allMigrations.length === 0) {
            console.log('No migration files found');
            return;
        }

        allMigrations.forEach(migration => {
            const status = executedVersions.has(migration.version) ? '✅' : '⏳';
            const executed = executedMigrations.find(m => m.version === migration.version);
            const timestamp = executed ? ` (${executed.executed_at})` : '';
            console.log(`${status} ${migration.version}_${migration.name}${timestamp}`);
        });

        const pending = allMigrations.filter(m => !executedVersions.has(m.version));
        console.log(`\n📈 Total: ${allMigrations.length}, Executed: ${executedMigrations.length}, Pending: ${pending.length}`);
    }

    /**
     * Command: create
     */
    async create(name) {
        if (!name) {
            console.error('❌ Migration name required');
            console.log('Usage: npm run db:create <migration_name>');
            return;
        }

        const timestamp = new Date().toISOString()
            .replace(/[-:]/g, '')
            .replace(/\..+/, '')
            .replace('T', '');

        const filename = `${timestamp}_${name.toLowerCase().replace(/\s+/g, '_')}.sql`;
        const filepath = path.join(this.migrationsDir, filename);

        await fs.mkdir(this.migrationsDir, { recursive: true });

        const template = `-- Migration: ${name}
-- Created: ${new Date().toISOString()}
-- Description: Add your migration description here

-- Add your SQL statements below
-- Example:
-- CREATE TABLE example (
--     id SERIAL PRIMARY KEY,
--     name VARCHAR(255) NOT NULL,
--     created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
-- );

`;

        await fs.writeFile(filepath, template);
        console.log(`✅ Created migration: ${filename}`);
    }

    /**
     * Command: setup
     */
    async setup() {
        console.log('🔧 Setting up database...');

        // Create database if needed
        const adminClient = new Client(this.dbConfig);
        try {
            await adminClient.connect();
            const result = await adminClient.query(
                'SELECT 1 FROM pg_database WHERE datname = $1', [this.dbName]
            );

            if (result.rows.length === 0) {
                console.log(`🔨 Creating database: ${this.dbName}`);
                await adminClient.query(`CREATE DATABASE "${this.dbName}"`);
                console.log(`✅ Database created: ${this.dbName}`);
            } else {
                console.log(`✅ Database exists: ${this.dbName}`);
            }
        } finally {
            await adminClient.end();
        }

        // Run migrations and seeds
        await this.migrate();
        await this.seed();
        console.log('🎉 Database setup completed');
    }

    /**
     * Command: check
     */
    async check() {
        console.log('🔄 MyHealthPlan Database Check');
        console.log('===============================\n');

        try {
            // Check database connection
            const client = await pool.connect();
            client.release();
            console.log('✅ Database connection successful');

            // Check migration system
            await this.initialize();
            const migrations = await this.getMigrationFiles();
            const seeds = await fs.readdir(this.seedsDir).catch(() => []);

            console.log(`📁 Found ${migrations.length} migration(s)`);
            console.log(`🌱 Found ${seeds.filter(f => f.endsWith('.sql')).length} seed file(s)`);

            console.log('\n🚀 Available Commands:');
            console.log('====================');
            console.log('npm run db:migrate    - Run pending migrations');
            console.log('npm run db:seed       - Run database seeds');
            console.log('npm run db:status     - Show migration status');
            console.log('npm run db:create     - Create new migration');
            console.log('npm run db:setup      - Full database setup');

            console.log('\n🎉 Database system is ready!');
        } catch (error) {
            console.error('❌ Database check failed:', error.message);
            throw error;
        }
    }

    /**
     * Main CLI handler
     */
    async run() {
        const command = process.argv[2];
        const arg = process.argv[3];

        try {
            switch (command) {
                case 'migrate': await this.migrate(); break;
                case 'seed': await this.seed(); break;
                case 'status': await this.status(); break;
                case 'create': await this.create(arg); break;
                case 'setup': await this.setup(); break;
                case 'check': await this.check(); break;
                default:
                    console.log('Database Management CLI');
                    console.log('======================');
                    console.log('Commands:');
                    console.log('  migrate  - Run pending migrations');
                    console.log('  seed     - Run database seeds');
                    console.log('  status   - Show migration status');
                    console.log('  create   - Create new migration');
                    console.log('  setup    - Full database setup');
                    console.log('  check    - Health check');
            }
            process.exit(0);
        } catch (error) {
            console.error('❌ Command failed:', error.message);
            process.exit(1);
        }
    }
}

// Run CLI if called directly
if (require.main === module) {
    const cli = new DatabaseCLI();
    cli.run();
}

module.exports = DatabaseCLI;
