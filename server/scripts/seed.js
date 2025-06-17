#!/usr/bin/env node

/**
 * Database Seeding Script
 * Run database seeds
 */

const Migrator = require('../db/migrator');

async function runSeeds() {
    const migrator = new Migrator();

    try {
        console.log('🌱 Starting seeding process...');
        await migrator.seed();
        console.log('✅ Seeding process completed');
        process.exit(0);
    } catch (error) {
        console.error('❌ Seeding failed:', error.message);
        process.exit(1);
    }
}

if (require.main === module) {
    runSeeds();
}

module.exports = { runSeeds };
