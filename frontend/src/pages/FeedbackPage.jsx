import { useEffect, useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Camera, FilePenLine, Image as ImageIcon, Images, X } from 'lucide-react';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Alert, Card } from '../app/components';
import { useAuth } from '../auth/useAuth.js';
import { ROLES } from '../config/roles.js';
import { feedbackApi } from '../services/feedbackApi.js';

const MAX_FILE_SIZE = 10 * 1024 * 1024;
const ALLOWED_IMAGE_TYPES = ['image/png', 'image/jpeg'];

const feedbackBackRoutes = {
  [ROLES.SUPER_ADMIN]: '/super-admin/tree',
  [ROLES.ADMIN]: '/admin/tree',
  [ROLES.USER]: '/app/tree',
};

export function FeedbackPage({ role }) {
  const { token } = useAuth();
  const navigate = useNavigate();
  const cameraInputRef = useRef(null);
  const galleryInputRef = useRef(null);
  const [notes, setNotes] = useState('');
  const [screenshot, setScreenshot] = useState(null);
  const [previewUrl, setPreviewUrl] = useState('');
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const backRoute = feedbackBackRoutes[role] ?? '/';
  const canSubmit = notes.trim().length > 0 || Boolean(screenshot);

  useEffect(() => {
    if (!screenshot) {
      setPreviewUrl('');
      return undefined;
    }

    const nextPreviewUrl = URL.createObjectURL(screenshot);
    setPreviewUrl(nextPreviewUrl);

    return () => URL.revokeObjectURL(nextPreviewUrl);
  }, [screenshot]);

  function handleFileChange(event) {
    const file = event.target.files?.[0];
    event.target.value = '';

    if (!file) {
      return;
    }

    if (!ALLOWED_IMAGE_TYPES.includes(file.type)) {
      setError('Please upload a PNG or JPG image.');
      return;
    }

    if (file.size > MAX_FILE_SIZE) {
      setError('Screenshot must be 10 MB or smaller.');
      return;
    }

    setError('');
    setSuccess('');
    setScreenshot(file);
  }

  async function handleSubmit(event) {
    event.preventDefault();

    if (!canSubmit) {
      setError('Please add feedback notes or attach a screenshot.');
      return;
    }

    setError('');
    setSuccess('');
    setIsSubmitting(true);

    try {
      const sourceUrl = typeof window !== 'undefined' ? window.location.href : '';

      await feedbackApi.submitFeedback(token, {
        notes,
        screenshot,
        sourceUrl,
      });

      setNotes('');
      setScreenshot(null);
      setSuccess('Feedback submitted. Thank you for helping improve the family tree.');
    } catch (submitError) {
      setError(submitError.message);
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <main className="dashboard-page">
      <NavigationChrome active="tree" mobileBackTo={backRoute} role={role} />

      <section className="dashboard-content feedback-content">
        <header className="feedback-header">
          <h1>Feedback</h1>
          <p>Share your issue, suggestion, or feedback with us.</p>
        </header>

        {error ? <Alert variant="error">{error}</Alert> : null}
        {success ? <Alert variant="success">{success}</Alert> : null}

        <form className="feedback-form" onSubmit={handleSubmit}>
          <Card className="feedback-card" padding="none" variant="elevated">
            <div className="feedback-card-heading">
              <span className="feedback-heading-icon">
                <ImageIcon aria-hidden="true" />
              </span>
              <div>
                <h2>Add a screenshot (optional)</h2>
                <p>Help us understand your feedback better.</p>
              </div>
            </div>

            <div className="feedback-upload-box">
              <span className="feedback-upload-icon">
                <ImageIcon aria-hidden="true" />
              </span>
              <strong>Upload image</strong>
              <p>PNG, JPG up to 10 MB</p>
              <div className="feedback-upload-actions">
                <button onClick={() => cameraInputRef.current?.click()} type="button">
                  <Camera aria-hidden="true" />
                  Camera
                </button>
                <button onClick={() => galleryInputRef.current?.click()} type="button">
                  <Images aria-hidden="true" />
                  Gallery
                </button>
              </div>
              <input
                accept="image/png,image/jpeg"
                capture="environment"
                className="feedback-file-input"
                onChange={handleFileChange}
                ref={cameraInputRef}
                type="file"
              />
              <input
                accept="image/png,image/jpeg"
                className="feedback-file-input"
                onChange={handleFileChange}
                ref={galleryInputRef}
                type="file"
              />
            </div>

            {screenshot ? (
              <div className="feedback-preview-row">
                <div className="feedback-preview-thumb">
                  {previewUrl ? <img alt="" src={previewUrl} /> : null}
                  <button
                    aria-label="Remove screenshot"
                    onClick={() => setScreenshot(null)}
                    type="button"
                  >
                    <X aria-hidden="true" />
                  </button>
                </div>
                <div className="feedback-preview-copy">
                  <strong>{screenshot.name}</strong>
                  <span>{formatFileSize(screenshot.size)}</span>
                </div>
              </div>
            ) : null}
          </Card>

          <Card className="feedback-card" padding="none" variant="elevated">
            <div className="feedback-card-heading">
              <span className="feedback-heading-icon">
                <FilePenLine aria-hidden="true" />
              </span>
              <div>
                <h2>Notes</h2>
                <p>Please provide as much detail as possible.</p>
              </div>
            </div>

            <label className="feedback-notes-field">
              <span className="sr-only">Feedback notes</span>
              <textarea
                maxLength={1000}
                onChange={(event) => setNotes(event.target.value)}
                placeholder="Describe your feedback here..."
                value={notes}
              />
              <span>{notes.length}/1000</span>
            </label>
          </Card>

          <div className="feedback-actions">
            <button disabled={isSubmitting || !canSubmit} type="submit">
              {isSubmitting ? 'Submitting...' : 'Submit Feedback'}
            </button>
            <button onClick={() => navigate(backRoute)} type="button">
              Cancel
            </button>
          </div>
        </form>
      </section>
    </main>
  );
}

function formatFileSize(bytes) {
  if (!bytes) {
    return '0 KB';
  }

  if (bytes >= 1024 * 1024) {
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
  }

  return `${Math.max(1, Math.round(bytes / 1024))} KB`;
}
