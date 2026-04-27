import { apiClient } from './apiClient.js';

export const familyConnectionApi = {
  async status(token) {
    const response = await apiClient.get('/family-connection', token);
    return response.data;
  },

  async connect(token, payload) {
    const response = await apiClient.post('/family-connection', payload, token);
    return response.data;
  },
};
