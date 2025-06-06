const bcrypt = require('bcrypt');

// Function to generate password hash
async function generatePasswordHash(password) {
    const saltRounds = 10;
    const hash = await bcrypt.hash(password, saltRounds);
    return hash;
}

// Generate hashes for our demo passwords
async function generateDemoPasswords() {
    const password = 'password123';
    const hash = await generatePasswordHash(password);
    
    console.log('Password:', password);
    console.log('Hash:', hash);
    console.log('\nUse this hash in your SQL INSERT statements');
}

generateDemoPasswords();
