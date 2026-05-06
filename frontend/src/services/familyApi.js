import { apiClient } from './apiClient.js';

export const familyApi = {
  async listFamilies(token) {
    const response = await apiClient.get('/families', token);
    return response.data.families;
  },

  async createFamily(token, payload) {
    const response = await apiClient.post('/families', payload, token);
    return response.data.family;
  },

  async deleteFamily(token, familyId) {
    await apiClient.delete(`/families/${familyId}`, token);
  },

  async listMembers(token, familyId) {
    const query = familyId ? `?family_id=${familyId}` : '';
    const response = await apiClient.get(`/family-members${query}`, token);
    return response.data.members;
  },

  async listHouseholds(token, familyId) {
    const query = familyId ? `?family_id=${familyId}` : '';
    const response = await apiClient.get(`/households${query}`, token);
    return response.data.households;
  },

  async createMember(token, payload) {
    const response = payload instanceof FormData
      ? await apiClient.postForm('/family-members', payload, token)
      : await apiClient.post('/family-members', payload, token);
    return response.data;
  },

  async updateMember(token, memberId, payload) {
    if (payload instanceof FormData) {
      payload.set('_method', 'PUT');
    }
    const response = payload instanceof FormData
      ? await apiClient.postForm(`/family-members/${memberId}`, payload, token)
      : await apiClient.put(`/family-members/${memberId}`, payload, token);
    return response.data.member;
  },

  async deleteMember(token, memberId) {
    await apiClient.delete(`/family-members/${memberId}`, token);
  },

  async updateMemberPhoto(token, memberId, photoFile) {
    const formData = new FormData();
    formData.append('photo', photoFile);
    const response = await apiClient.postForm(`/family-members/${memberId}/photo`, formData, token);
    return response.data.member;
  },
};
