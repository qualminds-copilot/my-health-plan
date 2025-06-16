import apiService from './apiService';

/**
 * Member Service
 * Handles all member-related API calls
 */
class MemberService {
    /**
     * Get member by number
     */
    async getMemberByNumber(memberNumber) {
        const data = await apiService.get(`/api/dashboard/member/${memberNumber}`);

        // Transform snake_case to camelCase for frontend consistency
        if (data) {
            return {
                ...data,
                memberNumber: data.member_number,
                firstName: data.first_name,
                lastName: data.last_name,
                dateOfBirth: data.dob,
                primaryCareProvider: data.pcp
            };
        }

        return data;
    }

    /**
     * Get all members
     */
    async getAllMembers() {
        return await apiService.get('/api/dashboard/members');
    }

    /**
     * Search members
     */
    async searchMembers(query) {
        return await apiService.get(`/api/dashboard/members/search?q=${encodeURIComponent(query)}`);
    }

    /**
     * Update member
     */
    async updateMember(memberNumber, memberData) {
        return await apiService.put(`/api/dashboard/member/${memberNumber}`, memberData);
    }
}

const memberService = new MemberService();
export default memberService;
