import { apiConfig } from '../config/api.js';

async function request(path, options = {}) {
  const isFormData = typeof FormData !== 'undefined' && options.body instanceof FormData;
  const response = await fetch(`${apiConfig.baseUrl}${path}`, {
    ...options,
    headers: {
      Accept: 'application/json',
      ...(!isFormData ? { 'Content-Type': 'application/json' } : {}),
      ...(options.token ? { Authorization: `Bearer ${options.token}` } : {}),
      ...options.headers,
    },
  });

  const payload = await response.json().catch(() => ({}));

  if (!response.ok) {
    const validationMessage = payload.errors ? Object.values(payload.errors).flat()[0] : null;
    const message =
      validationMessage ??
      payload.message ??
      payload.errors?.email?.[0] ??
      payload.errors?.password?.[0] ??
      'Request failed.';
    throw new Error(message);
  }

  return payload;
}

export const apiClient = {
  get(path, token) {
    return request(path, {
      method: 'GET',
      token,
    });
  },
  post(path, body, token) {
    return request(path, {
      method: 'POST',
      body: JSON.stringify(body),
      token,
    });
  },
  postForm(path, body, token) {
    return request(path, {
      method: 'POST',
      body,
      token,
    });
  },
  put(path, body, token) {
    return request(path, {
      method: 'PUT',
      body: JSON.stringify(body),
      token,
    });
  },
  delete(path, token) {
    return request(path, {
      method: 'DELETE',
      token,
    });
  },
};
