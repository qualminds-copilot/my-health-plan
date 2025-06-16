const BaseModel = require('./BaseModel');
const bcrypt = require('bcrypt');

/**
 * User Model
 * Handles user-related database operations
 */
class User extends BaseModel {
    constructor() {
        super('users');
    }

    /**
     * Find user by email
     */
    async findByEmail(email) {
        return await this.findOne('email = $1', [email]);
    }

    /**
     * Create new user with hashed password
     */
    async createUser(userData) {
        const { password, ...otherData } = userData;

        // Hash password
        const saltRounds = 12;
        const hashedPassword = await bcrypt.hash(password, saltRounds);

        return await this.create({
            ...otherData,
            password: hashedPassword,
            created_at: new Date(),
            updated_at: new Date()
        });
    }

    /**
     * Verify user password
     */
    async verifyPassword(plainPassword, hashedPassword) {
        return await bcrypt.compare(plainPassword, hashedPassword);
    }

    /**
     * Update user password
     */
    async updatePassword(userId, newPassword) {
        const saltRounds = 12;
        const hashedPassword = await bcrypt.hash(newPassword, saltRounds);

        return await this.updateById(userId, {
            password: hashedPassword,
            updated_at: new Date()
        });
    }

    /**
     * Update user last login
     */
    async updateLastLogin(userId) {
        return await this.updateById(userId, {
            last_login: new Date(),
            updated_at: new Date()
        });
    }

    /**
     * Get user profile (without password)
     */
    async getProfile(userId) {
        const query = `
      SELECT id, email, name, full_name, role, created_at, updated_at, last_login
      FROM ${this.tableName}
      WHERE id = $1
    `;

        const result = await this.pool.query(query, [userId]);
        return result.rows[0];
    }

    /**
     * Search users by name or email
     */
    async searchUsers(searchTerm, limit = 10, offset = 0) {
        const query = `
      SELECT id, email, name, full_name, role, created_at, last_login
      FROM ${this.tableName}
      WHERE name ILIKE $1 OR email ILIKE $1 OR full_name ILIKE $1
      ORDER BY name
      LIMIT $2 OFFSET $3
    `;

        const searchPattern = `%${searchTerm}%`;
        const result = await this.pool.query(query, [searchPattern, limit, offset]);
        return result.rows;
    }
}

module.exports = new User();
