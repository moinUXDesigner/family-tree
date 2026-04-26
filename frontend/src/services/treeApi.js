import { apiClient } from './apiClient.js';

export const treeApi = {
  async getTree(token, familyId) {
    const query = familyId ? `?family_id=${familyId}` : '';
    const response = await apiClient.get(`/family-tree${query}`, token);
    return response.data;
  },
};
