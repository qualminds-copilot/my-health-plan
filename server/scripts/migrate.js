#!/usr/bin/env node

/**
 * Migration Runner Script
 * Run database migrations
 */

const Migrator = require('../db/migrator');

async function runMigrations() {
    const migrator = new Migrator();

    try {
        console.log('🚀 Starting migration process...');
        await migrator.migrate();
        console.log('✅ Migration process completed');
        process.exit(0);
    } catch (error) {
        console.error('❌ Migration failed:', error.message);
        process.exit(1);
    }
}

if (require.main === module) {
    runMigrations();
}

module.exports = { runMigrations };
