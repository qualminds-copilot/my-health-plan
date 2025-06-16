const BaseModel = require('./BaseModel');

/**
 * Member Model
 * Handles member-related database operations
 */
class Member extends BaseModel {
    constructor() {
        super('members');
    }

    /**
     * Find member by member number
     */
    async findByMemberNumber(memberNumber) {
        return await this.findOne('member_number = $1', [memberNumber]);
    }

    /**
     * Search members by various criteria
     */
    async searchMembers(searchTerm, limit = 10, offset = 0) {
        const query = `
      SELECT *
      FROM ${this.tableName}
      WHERE 
        member_number ILIKE $1 OR
        first_name ILIKE $1 OR
        last_name ILIKE $1 OR
        name ILIKE $1 OR
        CONCAT(first_name, ' ', last_name) ILIKE $1
      ORDER BY last_name, first_name
      LIMIT $2 OFFSET $3
    `;

        const searchPattern = `%${searchTerm}%`;
        const result = await this.pool.query(query, [searchPattern, limit, offset]);
        return result.rows;
    }

    /**
     * Get members with pagination
     */
    async getMembers(limit = 10, offset = 0, status = null) {
        let query = `
      SELECT *
      FROM ${this.tableName}
    `;

        const params = [];

        if (status) {
            query += ` WHERE status = $1`;
            params.push(status);
        }

        query += ` ORDER BY last_name, first_name LIMIT $${params.length + 1} OFFSET $${params.length + 2}`;
        params.push(limit, offset);

        const result = await this.pool.query(query, params);
        return result.rows;
    }

    /**
     * Get member statistics
     */
    async getMemberStats() {
        const query = `
      SELECT 
        COUNT(*) as total_members,
        COUNT(*) FILTER (WHERE status = 'Active') as active_members,
        COUNT(*) FILTER (WHERE status = 'Inactive') as inactive_members,
        COUNT(*) FILTER (WHERE status = 'Pending') as pending_members
      FROM ${this.tableName}
    `;

        const result = await this.pool.query(query);
        return result.rows[0];
    }

    /**
     * Update member status
     */
    async updateStatus(memberId, status) {
        return await this.updateById(memberId, {
            status,
            updated_at: new Date()
        });
    }

    /**
     * Get members by status
     */
    async getMembersByStatus(status, limit = 10, offset = 0) {
        const query = `
      SELECT *
      FROM ${this.tableName}
      WHERE status = $1
      ORDER BY last_name, first_name
      LIMIT $2 OFFSET $3
    `;

        const result = await this.pool.query(query, [status, limit, offset]);
        return result.rows;
    }

    /**
     * Get members with recent activity
     */
    async getMembersWithRecentActivity(days = 30, limit = 10) {
        const query = `
      SELECT m.*, 
        COUNT(a.id) as activity_count
      FROM ${this.tableName} m
      LEFT JOIN authorizations a ON m.id = a.member_id
      WHERE a.created_at >= NOW() - INTERVAL '${days} days'
      GROUP BY m.id
      ORDER BY activity_count DESC, m.last_name, m.first_name
      LIMIT $1
    `;

        const result = await this.pool.query(query, [limit]);
        return result.rows;
    }
}

module.exports = new Member();
