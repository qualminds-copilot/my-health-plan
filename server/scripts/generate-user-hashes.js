const bcrypt = require('bcrypt');

// Configuration
const SALT_ROUNDS = 10;
const DEFAULT_PASSWORD = 'password123';

// Users configuration
const USERS = [
    { email: 'admin@myhealthplan.com', username: 'admin', fullName: 'System Administrator', role: 'admin' },
    { email: 'maria.hartsell@myhealthplan.com', username: 'maria.hartsell', fullName: 'Maria Hartsell', role: 'admin' },
    { email: 'john.doe@myhealthplan.com', username: 'john.doe', fullName: 'John Doe', role: 'user' },
    { email: 'jane.smith@myhealthplan.com', username: 'jane.smith', fullName: 'Jane Smith', role: 'user' }
];

async function generateConsistentHashes() {
    console.log('🔐 Generating password hashes...');
    console.log(`Password: "${DEFAULT_PASSWORD}"`);

    // Generate hash for the password
    const hash = await bcrypt.hash(DEFAULT_PASSWORD, SALT_ROUNDS);
    console.log(`Hash: ${hash}`);

    // Verify it works
    const testMatch = await bcrypt.compare(DEFAULT_PASSWORD, hash);
    if (!testMatch) {
        throw new Error('Hash verification failed!');
    }
    console.log('✅ Hash verified');

    // Generate SQL INSERT statement
    const userInserts = USERS.map((user, index) =>
        `(${index + 1}, '${user.username}', '${user.email}', '${hash}', '${user.fullName}', '${user.role}', '2025-06-16 11:38:05.214214', '2025-06-16 11:38:05.214214')`
    ); const sqlInsert = `INSERT INTO public.users (id, username, email, password_hash, full_name, role, created_at, updated_at) VALUES\n${userInserts.join(',\n')};`;

    // Output the SQL for manual use or migration creation
    console.log('\n📋 Generated SQL INSERT statement:');
    console.log('=====================================');
    console.log(sqlInsert);
    console.log('\n💡 To update passwords in the database:');
    console.log('1. Use this SQL in a new migration file, or');
    console.log('2. Run it directly against your database, or');
    console.log('3. Update the seed file if recreating the database');

    console.log(`\n🎉 Done! All ${USERS.length} users now use password: "${DEFAULT_PASSWORD}"`);
}

// Run if called directly
if (require.main === module) {
    generateConsistentHashes().catch(console.error);
}
