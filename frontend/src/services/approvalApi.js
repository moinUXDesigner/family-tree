import { apiClient } from './apiClient.js';

export const approvalApi = {
  async listRequests(token, status = 'pending') {
    const response = await apiClient.get(`/approval-requests?status=${status}`, token);
    return response.data.users;
  },

  async updateRequest(token, userId, approvalStatus) {
    const response = await apiClient.put(
      `/approval-requests/${userId}`,
      { approval_status: approvalStatus },
      token,
    );
    return response.data.user;
  },
};
