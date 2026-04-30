import { apiClient } from './apiClient.js';

export const approvalApi = {
  async listRequests(token, status = 'pending') {
    const response = await apiClient.get(`/approval-requests?status=${status}`, token);
    return response.data.users;
  },

  async updateRequest(token, userId, approvalStatus, claimedMemberId = null) {
    const response = await apiClient.post(
      `/approval-requests/${userId}`,
      {
        approval_status: approvalStatus,
        claimed_member_id: claimedMemberId || null,
      },
      token,
    );
    return response.data.user;
  },
};
