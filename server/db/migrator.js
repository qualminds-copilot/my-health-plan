/**
 * Database Migration System
 * Lightweight, SQL-based migration runner for MyHealthPlan MVP
 */

const fs = require('fs').promises;
const path = require('path');
const pool = require('./connection');

class Migrator {
    constructor() {
        this.migrationsDir = path.join(__dirname, 'migrations');
        this.seedsDir = path.join(__dirname, 'seeds');
    }

    /**
     * Initialize migration system by creating migrations table
     */
    async initialize() {
        const client = await pool.connect();
        try {
            // Create migrations tracking table if it doesn't exist
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

            console.log('✅ Migration system initialized');
        } catch (error) {
            console.error('❌ Failed to initialize migration system:', error.message);
            throw error;
        } finally {
            client.release();
        }
    }

    /**
     * Get all migration files sorted by version
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
                console.log('📁 Migrations directory not found, creating...');
                await fs.mkdir(this.migrationsDir, { recursive: true });
                return [];
            }
            throw error;
        }
    }

    /**
     * Get executed migrations from database
     */
    async getExecutedMigrations() {
        const client = await pool.connect();
        try {
            const result = await client.query(
                'SELECT version, name, executed_at FROM schema_migrations ORDER BY version'
            );
            return result.rows;
        } catch (error) {
            // If table doesn't exist, return empty array
            if (error.code === '42P01') {
                return [];
            }
            throw error;
        } finally {
            client.release();
        }
    }

    /**
     * Calculate SHA-256 checksum of migration content
     */
    async calculateChecksum(content) {
        const crypto = require('crypto');
        return crypto.createHash('sha256').update(content).digest('hex');
    }

    /**
     * Execute a single migration
     */
    async executeMigration(migration) {
        const client = await pool.connect();
        const startTime = Date.now();

        try {
            await client.query('BEGIN');

            // Read and execute migration content
            const content = await fs.readFile(migration.filepath, 'utf8');
            const checksum = await this.calculateChecksum(content);

            console.log(`🔄 Executing migration: ${migration.version}_${migration.name}`);

            // Execute the migration SQL
            await client.query(content);

            // Record the migration
            const executionTime = Date.now() - startTime;
            await client.query(`
                INSERT INTO schema_migrations (version, name, checksum, execution_time_ms)
                VALUES ($1, $2, $3, $4)
            `, [migration.version, migration.name, checksum, executionTime]);

            await client.query('COMMIT');

            console.log(`✅ Migration completed: ${migration.version}_${migration.name} (${executionTime}ms)`);
        } catch (error) {
            await client.query('ROLLBACK');
            console.error(`❌ Migration failed: ${migration.version}_${migration.name}`);
            console.error('Error:', error.message);
            throw error;
        } finally {
            client.release();
        }
    }

    /**
     * Run all pending migrations
     */
    async migrate() {
        console.log('🚀 Starting database migration...');

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

        console.log('🎉 All migrations completed successfully');
    }

    /**
     * Get migration status
     */
    async status() {
        try {
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

        } catch (error) {
            console.error('❌ Error getting migration status:', error.message);
            throw error;
        }
    }

    /**
     * Run database seeds
     */
    async seed() {
        console.log('🌱 Starting database seeding...');

        try {
            const files = await fs.readdir(this.seedsDir);
            const seedFiles = files
                .filter(file => file.endsWith('.sql'))
                .sort();

            if (seedFiles.length === 0) {
                console.log('📁 No seed files found');
                return;
            }

            const client = await pool.connect();

            try {
                for (const seedFile of seedFiles) {
                    console.log(`🔄 Running seed: ${seedFile}`);
                    const seedPath = path.join(this.seedsDir, seedFile);
                    const content = await fs.readFile(seedPath, 'utf8');

                    await client.query(content);
                    console.log(`✅ Seed completed: ${seedFile}`);
                }

                console.log('🎉 All seeds completed successfully');
            } finally {
                client.release();
            }

        } catch (error) {
            if (error.code === 'ENOENT') {
                console.log('📁 Seeds directory not found, creating...');
                await fs.mkdir(this.seedsDir, { recursive: true });
                console.log('✅ Seeds directory created');
                return;
            }
            console.error('❌ Seeding failed:', error.message);
            throw error;
        }
    }

    /**
     * Create a new migration file
     */
    async createMigration(name) {
        if (!name) {
            throw new Error('Migration name is required');
        }

        // Generate timestamp-based version
        const timestamp = new Date().toISOString()
            .replace(/[-:]/g, '')
            .replace(/\..+/, '')
            .replace('T', '');

        const filename = `${timestamp}_${name.toLowerCase().replace(/\s+/g, '_')}.sql`;
        const filepath = path.join(this.migrationsDir, filename);

        // Create migrations directory if it doesn't exist
        await fs.mkdir(this.migrationsDir, { recursive: true });

        // Create migration file with template
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
        return filename;
    }
}

module.exports = Migrator;
