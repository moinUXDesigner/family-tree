import { apiClient } from './apiClient.js';

export const activityApi = {
  async listActivities(token, familyId = '') {
    const query = familyId ? `?family_id=${familyId}` : '';
    const response = await apiClient.get(`/activity-trails${query}`, token);
    return response.data.activities;
  },
};

