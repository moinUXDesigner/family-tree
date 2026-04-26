import { ShieldCheck, TreePine, UsersRound } from 'lucide-react';
import { apiConfig } from './config/api.js';

const setupItems = [
  {
    icon: ShieldCheck,
    title: 'RBAC Ready',
    text: 'Super Admin, Admin, and End User layouts will be protected from the first auth phase.',
  },
  {
    icon: TreePine,
    title: 'Tree First',
    text: 'The frontend is prepared for a relationship-driven family tree experience.',
  },
  {
    icon: UsersRound,
    title: 'Hostinger Ready',
    text: 'The app builds as static files for the familytree subdomain.',
  },
];

export function App() {
  return (
    <main className="app-shell">
      <section className="hero">
        <p className="eyebrow">Family Network Platform</p>
        <h1>Project foundation is ready.</h1>
        <p className="hero-copy">
          React Vite is prepared for role-based dashboards, Laravel API integration, and Hostinger deployment.
        </p>
        <div className="meta-grid" aria-label="Environment summary">
          <div>
            <span>Frontend</span>
            <strong>familytree.khajamynuddin.com</strong>
          </div>
          <div>
            <span>API</span>
            <strong>{apiConfig.baseUrl}</strong>
          </div>
        </div>
      </section>

      <section className="setup-grid" aria-label="Foundation features">
        {setupItems.map((item) => {
          const Icon = item.icon;

          return (
            <article className="setup-card" key={item.title}>
              <Icon aria-hidden="true" />
              <h2>{item.title}</h2>
              <p>{item.text}</p>
            </article>
          );
        })}
      </section>
    </main>
  );
}

