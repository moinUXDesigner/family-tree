import { useEffect, useState } from 'react';
import { Download, X } from 'lucide-react';
import { Button, Card } from '../app/components';

export function PwaInstallPrompt({ isOpen, onClose }) {
  const [deferredPrompt, setDeferredPrompt] = useState(null);
  const [isInstalled, setIsInstalled] = useState(false);

  useEffect(() => {
    function handleBeforeInstallPrompt(event) {
      event.preventDefault();
      setDeferredPrompt(event);
    }

    function handleInstalled() {
      setIsInstalled(true);
      setDeferredPrompt(null);
    }

    window.addEventListener('beforeinstallprompt', handleBeforeInstallPrompt);
    window.addEventListener('appinstalled', handleInstalled);

    return () => {
      window.removeEventListener('beforeinstallprompt', handleBeforeInstallPrompt);
      window.removeEventListener('appinstalled', handleInstalled);
    };
  }, []);

  if (!isOpen) {
    return null;
  }

  async function handleInstall() {
    if (!deferredPrompt) {
      onClose();
      return;
    }

    deferredPrompt.prompt();
    await deferredPrompt.userChoice.catch(() => null);
    setDeferredPrompt(null);
    onClose();
  }

  return (
    <div className="pwa-install-overlay" role="presentation">
      <Card className="pwa-install-card" padding="lg" variant="elevated">
        <button className="pwa-install-close" onClick={onClose} type="button" aria-label="Close install prompt">
          <X aria-hidden="true" />
        </button>

        <div className="brand-mark">
          <Download aria-hidden="true" />
        </div>
        <h2>{isInstalled ? 'Family Tree is installed' : 'Install Family Tree'}</h2>
        <p>
          Add this app to your home screen for quicker access after connecting to your family tree.
        </p>

        <div className="pwa-install-actions">
          <Button fullWidth onClick={handleInstall} type="button">
            <Download aria-hidden="true" />
            {deferredPrompt ? 'Install app' : 'Continue'}
          </Button>
          <Button fullWidth onClick={onClose} type="button" variant="outline">
            Not now
          </Button>
        </div>
      </Card>
    </div>
  );
}
