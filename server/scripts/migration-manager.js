#!/usr/bin/env node

/**
 * Migration Status and Management Script
 * View migration status and create new migrations
 */

const Migrator = require('../db/migrator');

const command = process.argv[2];
const migrationName = process.argv[3];

async function main() {
    const migrator = new Migrator();

    try {
        switch (command) {
            case 'status':
                await migrator.status();
                break;

            case 'create':
                if (!migrationName) {
                    console.error('❌ Migration name required');
                    console.log('Usage: node migration-manager.js create <migration_name>');
                    process.exit(1);
                }
                await migrator.createMigration(migrationName);
                break;

            default:
                console.log('Migration Manager Commands:');
                console.log('  status  - Show migration status');
                console.log('  create  - Create new migration file');
                console.log('');
                console.log('Usage:');
                console.log('  node migration-manager.js status');
                console.log('  node migration-manager.js create <migration_name>');
        }

        process.exit(0);
    } catch (error) {
        console.error('❌ Command failed:', error.message);
        process.exit(1);
    }
}

if (require.main === module) {
    main();
}

module.exports = { main };
