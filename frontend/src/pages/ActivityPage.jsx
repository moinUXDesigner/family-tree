import { useEffect, useState } from 'react';
import { LogOut, ShieldCheck } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLES } from '../config/roles.js';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Alert, Badge, Button, Card } from '../app/components';
import { familyApi } from '../services/familyApi.js';
import { activityApi } from '../services/activityApi.js';

export function ActivityPage({ role }) {
  const { logout, token } = useAuth();
  const [families, setFamilies] = useState([]);
  const [familyId, setFamilyId] = useState('');
  const [activities, setActivities] = useState([]);
  const [error, setError] = useState('');

  useEffect(() => {
    async function load() {
      try {
        const nextFamilies = await familyApi.listFamilies(token);
        const nextFamilyId = nextFamilies[0]?.id ?? '';
        setFamilies(nextFamilies);
        setFamilyId(String(nextFamilyId));
        const rows = await activityApi.listActivities(token, role === ROLES.SUPER_ADMIN ? nextFamilyId : '');
        setActivities(rows);
      } catch (loadError) {
        setError(loadError.message);
      }
    }

    load();
  }, [role, token]);

  async function onFamilyChange(nextFamilyId) {
    setFamilyId(nextFamilyId);
    try {
      const rows = await activityApi.listActivities(token, nextFamilyId);
      setActivities(rows);
    } catch (loadError) {
      setError(loadError.message);
    }
  }

  return (
    <main className="dashboard-page">
      <NavigationChrome active="activity" role={role} />
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <h1>Activity</h1>
            <p>Audit trail for changes in this application.</p>
          </div>
          <Button onClick={logout} type="button" variant="outline">
            <LogOut aria-hidden="true" />
            Logout
          </Button>
        </header>

        {error ? <Alert variant="error">{error}</Alert> : null}

        {role === ROLES.SUPER_ADMIN && families.length > 1 ? (
          <Card padding="md" variant="bordered">
            <label className="field-group tree-family-select">
              Family
              <select value={familyId} onChange={(event) => onFamilyChange(event.target.value)}>
                {families.map((family) => (
                  <option key={family.id} value={family.id}>
                    {family.name}
                  </option>
                ))}
              </select>
            </label>
          </Card>
        ) : null}

        <Card padding="lg" variant="elevated">
          <div className="member-list">
            {activities.map((activity) => (
              <article className="member-row" key={activity.id}>
                <div className="member-avatar" aria-hidden="true">
                  <ShieldCheck size={20} />
                </div>
                <div className="member-main">
                  <div className="member-title-line">
                    <strong>{activity.event}</strong>
                    <Badge variant="neutral">{activity.method}</Badge>
                  </div>
                  <p>{activity.path}</p>
                  <small>
                    {activity.user_name || 'Unknown'} | {activity.user_role} | {new Date(activity.created_at).toLocaleString()}
                  </small>
                </div>
              </article>
            ))}
          </div>
        </Card>
      </section>
    </main>
  );
}

