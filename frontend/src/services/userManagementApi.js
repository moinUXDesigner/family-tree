import { apiClient } from './apiClient.js';

export const userManagementApi = {
  async listUsers(token) {
    const response = await apiClient.get('/users', token);
    return response.data;
  },

  async updateUser(token, userId, payload) {
    const response = await apiClient.post(`/users/${userId}`, payload, token);
    return response.data.user;
  },

  async deleteUser(token, userId) {
    await apiClient.delete(`/users/${userId}`, token);
  },
};
