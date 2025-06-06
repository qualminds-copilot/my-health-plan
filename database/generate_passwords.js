// Script to generate bcrypt password hashes
const bcrypt = require('bcrypt');

async function generatePasswordHashes() {
    const password = 'password123';
    const saltRounds = 10;
    
    console.log('Generating password hashes for password: "password123"');
    console.log('==========================================');
    
    for (let i = 1; i <= 4; i++) {
        const hash = await bcrypt.hash(password, saltRounds);
        console.log(`User ${i} hash: '${hash}'`);
    }
}

generatePasswordHashes().catch(console.error);
