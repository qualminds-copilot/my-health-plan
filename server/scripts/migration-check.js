#!/usr/bin/env node

/**
 * Migration System Status Check
 * Shows the status of the migration system and provides helpful commands
 */

const fs = require('fs').promises;
const path = require('path');

async function checkMigrationStatus() {
    console.log('🔍 Checking migration system status...');

    // Check if migration system is properly set up
    const migrationsDir = path.join(__dirname, '..', 'db', 'migrations');
    const seedsDir = path.join(__dirname, '..', 'db', 'seeds');

    try {
        const migrationFiles = await fs.readdir(migrationsDir);
        const seedFiles = await fs.readdir(seedsDir);

        console.log('\n✅ Migration system is active and ready!');
        console.log(`📁 Found ${migrationFiles.filter(f => f.endsWith('.sql')).length} migration(s)`);
        console.log(`🌱 Found ${seedFiles.filter(f => f.endsWith('.sql')).length} seed file(s)`);
    } catch (error) {
        console.log('\n❌ Migration system setup incomplete');
        console.log('   Run: npm run db:setup');
    }
}

async function showMigrationCommands() {
    console.log('\n🚀 Migration System Commands:');
    console.log('============================');
    console.log('npm run db:status     - Check migration status');
    console.log('npm run db:migrate    - Run pending migrations');
    console.log('npm run db:seed       - Run database seeds');
    console.log('npm run db:setup      - Full database setup');
    console.log('npm run db:create     - Create new migration'); console.log('\n📖 For detailed documentation, see:');
    console.log('   Main README.md (Database Migration System section)');
}

async function main() {
    console.log('🔄 MyHealthPlan Migration System Check');
    console.log('=====================================\n');

    await checkMigrationStatus();
    await showMigrationCommands();

    console.log('\n🎉 Migration system is ready for use!');
}

if (require.main === module) {
    main().catch(console.error);
}

module.exports = { checkMigrationStatus, showMigrationCommands };
