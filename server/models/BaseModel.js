const pool = require('../db/connection');
const { asyncHandler } = require('../middleware/errorHandler');

/**
 * Base Model Class
 * Provides common database operations
 */
class BaseModel {
    constructor(tableName) {
        this.tableName = tableName;
        this.pool = pool;
    }

    /**
     * Find all records with optional conditions
     */
    async findAll(conditions = '', params = [], limit = null, offset = null) {
        let query = `SELECT * FROM ${this.tableName}`;

        if (conditions) {
            query += ` WHERE ${conditions}`;
        }

        if (limit) {
            query += ` LIMIT ${limit}`;
        }

        if (offset) {
            query += ` OFFSET ${offset}`;
        }

        const result = await this.pool.query(query, params);
        return result.rows;
    }

    /**
     * Find record by ID
     */
    async findById(id) {
        const query = `SELECT * FROM ${this.tableName} WHERE id = $1`;
        const result = await this.pool.query(query, [id]);
        return result.rows[0];
    }

    /**
     * Find single record by conditions
     */
    async findOne(conditions, params = []) {
        const query = `SELECT * FROM ${this.tableName} WHERE ${conditions} LIMIT 1`;
        const result = await this.pool.query(query, params);
        return result.rows[0];
    }

    /**
     * Create new record
     */
    async create(data) {
        const columns = Object.keys(data);
        const values = Object.values(data);
        const placeholders = values.map((_, index) => `$${index + 1}`).join(', ');

        const query = `
      INSERT INTO ${this.tableName} (${columns.join(', ')})
      VALUES (${placeholders})
      RETURNING *
    `;

        const result = await this.pool.query(query, values);
        return result.rows[0];
    }

    /**
     * Update record by ID
     */
    async updateById(id, data) {
        const columns = Object.keys(data);
        const values = Object.values(data);
        const setClause = columns.map((col, index) => `${col} = $${index + 2}`).join(', ');

        const query = `
      UPDATE ${this.tableName}
      SET ${setClause}
      WHERE id = $1
      RETURNING *
    `;

        const result = await this.pool.query(query, [id, ...values]);
        return result.rows[0];
    }

    /**
     * Delete record by ID
     */
    async deleteById(id) {
        const query = `DELETE FROM ${this.tableName} WHERE id = $1 RETURNING *`;
        const result = await this.pool.query(query, [id]);
        return result.rows[0];
    }

    /**
     * Count records with optional conditions
     */
    async count(conditions = '', params = []) {
        let query = `SELECT COUNT(*) as count FROM ${this.tableName}`;

        if (conditions) {
            query += ` WHERE ${conditions}`;
        }

        const result = await this.pool.query(query, params);
        return parseInt(result.rows[0].count);
    }

    /**
     * Execute raw query
     */
    async query(sql, params = []) {
        const result = await this.pool.query(sql, params);
        return result.rows;
    }
}

module.exports = BaseModel;
