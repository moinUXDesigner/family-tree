import { apiClient } from './apiClient.js';

export const feedbackApi = {
  async listFeedback(token, { hasScreenshot = false, search = '', status = 'all' } = {}) {
    const params = new URLSearchParams();

    if (status && status !== 'all') {
      params.set('status', status);
    }

    if (search.trim()) {
      params.set('search', search.trim());
    }

    if (hasScreenshot) {
      params.set('has_screenshot', '1');
    }

    const query = params.toString();
    const response = await apiClient.get(`/feedback${query ? `?${query}` : ''}`, token);

    return response.data;
  },

  async submitFeedback(token, { notes, screenshot, sourceUrl }) {
    const formData = new FormData();

    formData.append('notes', notes ?? '');

    if (screenshot) {
      formData.append('screenshot', screenshot);
    }

    if (sourceUrl) {
      formData.append('source_url', sourceUrl);
    }

    const response = await apiClient.postForm('/feedback', formData, token);

    return response.data;
  },

  async updateFeedbackStatus(token, feedbackId, status) {
    const response = await apiClient.put(`/feedback/${feedbackId}`, { status }, token);

    return response.data.feedback;
  },
};
