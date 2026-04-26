import { apiClient } from './apiClient.js';

export const familyApi = {
  async listFamilies(token) {
    const response = await apiClient.get('/families', token);
    return response.data.families;
  },

  async listMembers(token, familyId) {
    const query = familyId ? `?family_id=${familyId}` : '';
    const response = await apiClient.get(`/family-members${query}`, token);
    return response.data.members;
  },

  async createMember(token, payload) {
    const response = await apiClient.post('/family-members', payload, token);
    return response.data.member;
  },

  async updateMember(token, memberId, payload) {
    const response = await apiClient.put(`/family-members/${memberId}`, payload, token);
    return response.data.member;
  },

  async deleteMember(token, memberId) {
    await apiClient.delete(`/family-members/${memberId}`, token);
  },
};
