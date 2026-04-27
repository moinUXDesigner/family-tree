import { apiClient } from './apiClient.js';

export const rootFamilyApi = {
  async getRootFamily(token) {
    const response = await apiClient.get('/root-family', token);
    return response.data;
  },

  async addMember(token, payload) {
    const response = await apiClient.post('/root-family/members', payload, token);
    return response.data;
  },
};
