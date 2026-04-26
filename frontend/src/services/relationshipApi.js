import { apiClient } from './apiClient.js';

export const relationshipApi = {
  async listRelationships(token, familyId) {
    const query = familyId ? `?family_id=${familyId}` : '';
    const response = await apiClient.get(`/family-relationships${query}`, token);
    return response.data;
  },

  async createRelationship(token, payload) {
    const response = await apiClient.post('/family-relationships', payload, token);
    return response.data.relationship;
  },

  async deleteRelationship(token, relationshipId) {
    await apiClient.delete(`/family-relationships/${relationshipId}`, token);
  },
};
