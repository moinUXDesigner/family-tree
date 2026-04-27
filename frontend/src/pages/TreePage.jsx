import { useEffect, useMemo, useState } from 'react';
import { GitBranch, Heart, LogOut, Network, ShieldCheck, UsersRound } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLE_HOME, ROLE_LABELS, ROLES } from '../config/roles.js';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Alert, Badge, Button, Card } from '../app/components';
import { familyApi } from '../services/familyApi.js';
import { treeApi } from '../services/treeApi.js';

const memberRoutes = {
  [ROLES.SUPER_ADMIN]: '/super-admin/members',
  [ROLES.ADMIN]: '/admin/members',
  [ROLES.USER]: '/app/members',
};

const relationshipRoutes = {
  [ROLES.SUPER_ADMIN]: '/super-admin/relationships',
  [ROLES.ADMIN]: '/admin/relationships',
  [ROLES.USER]: '/app/relationships',
};

const treeRoutes = {
  [ROLES.SUPER_ADMIN]: '/super-admin/tree',
  [ROLES.ADMIN]: '/admin/tree',
  [ROLES.USER]: '/app/tree',
};

export function TreePage({ role }) {
  const { logout, token, user } = useAuth();
  const [families, setFamilies] = useState([]);
  const [selectedFamilyId, setSelectedFamilyId] = useState(user.family_id ?? '');
  const [tree, setTree] = useState({ family: null, nodes: [], links: [], root_member_ids: [] });
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(true);

  const nodeMap = useMemo(
    () => new Map(tree.nodes.map((node) => [node.id, node])),
    [tree.nodes],
  );

  const parentLinks = useMemo(
    () => tree.links.filter((link) => link.relationship_type === 'parent'),
    [tree.links],
  );

  const sideLinks = useMemo(
    () => tree.links.filter((link) => link.relationship_type !== 'parent'),
    [tree.links],
  );

  const childrenByParent = useMemo(() => {
    const map = new Map();

    parentLinks.forEach((link) => {
      const children = map.get(link.from_member_id) ?? [];
      children.push(link.to_member_id);
      map.set(link.from_member_id, children);
    });

    return map;
  }, [parentLinks]);

  useEffect(() => {
    let isMounted = true;

    async function loadFamilies() {
      try {
        const nextFamilies = await familyApi.listFamilies(token);
        const nextFamilyId = selectedFamilyId || nextFamilies[0]?.id || user.family_id || '';

        if (!isMounted) {
          return;
        }

        setFamilies(nextFamilies);
        setSelectedFamilyId(nextFamilyId);
      } catch (loadError) {
        if (isMounted) {
          setError(loadError.message);
          setIsLoading(false);
        }
      }
    }

    loadFamilies();

    return () => {
      isMounted = false;
    };
  }, [selectedFamilyId, token, user.family_id]);

  useEffect(() => {
    if (!selectedFamilyId) {
      return;
    }

    let isMounted = true;

    async function loadTree() {
      setIsLoading(true);
      setError('');

      try {
        const nextTree = await treeApi.getTree(token, selectedFamilyId);

        if (isMounted) {
          setTree(nextTree);
        }
      } catch (loadError) {
        if (isMounted) {
          setError(loadError.message);
        }
      } finally {
        if (isMounted) {
          setIsLoading(false);
        }
      }
    }

    loadTree();

    return () => {
      isMounted = false;
    };
  }, [selectedFamilyId, token]);

  const stats = [
    ['Members', tree.nodes.length],
    ['Parent links', parentLinks.length],
    ['Other links', sideLinks.length],
  ];

  return (
    <main className="dashboard-page">
      <NavigationChrome active="tree" role={role} />

      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <Badge variant="primary">{ROLE_LABELS[user.role]}</Badge>
            <h1>{tree.family?.name ?? 'Family Tree'}</h1>
            <p>
              The first tree view uses parent relationships for hierarchy and keeps
              spouse, sibling, and guardian links visible beside the graph.
            </p>
          </div>
          <Button onClick={logout} type="button" variant="outline">
            <LogOut aria-hidden="true" />
            Logout
          </Button>
        </header>

        {error ? <Alert variant="error">{error}</Alert> : null}

        <section className="metric-grid" aria-label="Family tree summary">
          {stats.map(([label, value]) => (
            <Card className="metric-card" key={label} padding="md" variant="elevated">
              <span>{label}</span>
              <strong>{value}</strong>
            </Card>
          ))}
        </section>

        {families.length > 1 ? (
          <Card padding="md" variant="bordered">
            <label className="field-group tree-family-select">
              Family
              <select
                value={selectedFamilyId}
                onChange={(event) => setSelectedFamilyId(event.target.value)}
              >
                {families.map((family) => (
                  <option key={family.id} value={family.id}>
                    {family.name}
                  </option>
                ))}
              </select>
            </label>
          </Card>
        ) : null}

        <section className="tree-layout">
          <Card padding="lg" variant="elevated">
            <div className="section-heading">
              <div>
                <h2>Tree graph</h2>
                <p>{isLoading ? 'Loading tree...' : 'Parent links are rendered as generations.'}</p>
              </div>
              <Network aria-hidden="true" />
            </div>

            <div className="tree-canvas">
              {tree.root_member_ids.map((rootId) => (
                <TreeBranch
                  childrenByParent={childrenByParent}
                  depth={0}
                  key={rootId}
                  node={nodeMap.get(rootId)}
                  nodeMap={nodeMap}
                  visited={new Set()}
                />
              ))}

              {!isLoading && tree.nodes.length === 0 ? (
                <div className="empty-state">
                  <UsersRound aria-hidden="true" />
                  <strong>No members yet</strong>
                  <p>Add members and relationships to render a tree.</p>
                </div>
              ) : null}
            </div>
          </Card>

          <Card padding="lg" variant="bordered">
            <div className="section-heading">
              <div>
                <h2>Other links</h2>
                <p>Non-parent relationships stay attached to the tree context.</p>
              </div>
              <GitBranch aria-hidden="true" />
            </div>

            <div className="side-link-list">
              {sideLinks.map((link) => (
                <article className="side-link-row" key={link.id}>
                  <div className="relationship-icon" aria-hidden="true">
                    {link.relationship_type === 'spouse' ? <Heart /> : <GitBranch />}
                  </div>
                  <div>
                    <strong>{link.from_member_name}</strong>
                    <span>{link.relationship_label}</span>
                    <strong>{link.to_member_name}</strong>
                  </div>
                </article>
              ))}

              {!isLoading && sideLinks.length === 0 ? (
                <div className="empty-state compact">
                  <ShieldCheck aria-hidden="true" />
                  <strong>No side links</strong>
                  <p>Spouse, sibling, and guardian links will appear here.</p>
                </div>
              ) : null}
            </div>
          </Card>
        </section>
      </section>
    </main>
  );
}

function TreeBranch({ childrenByParent, depth, node, nodeMap, visited }) {
  if (!node || visited.has(node.id)) {
    return null;
  }

  const nextVisited = new Set(visited);
  nextVisited.add(node.id);
  const childIds = childrenByParent.get(node.id) ?? [];

  return (
    <div className="tree-branch" style={{ '--tree-depth': depth }}>
      <article className="tree-node">
        <div className="member-avatar" aria-hidden="true">
          {initials(node.name)}
        </div>
        <div>
          <strong>{node.name}</strong>
          <span>{node.birth_date ?? 'Birth date not added'}</span>
          {node.location ? <small>{node.location}</small> : null}
        </div>
        <Badge variant={node.is_living ? 'success' : 'neutral'}>
          {node.is_living ? 'Living' : 'Deceased'}
        </Badge>
      </article>

      {childIds.length > 0 ? (
        <div className="tree-children">
          {childIds.map((childId) => (
            <TreeBranch
              childrenByParent={childrenByParent}
              depth={depth + 1}
              key={childId}
              node={nodeMap.get(childId)}
              nodeMap={nodeMap}
              visited={nextVisited}
            />
          ))}
        </div>
      ) : null}
    </div>
  );
}

function initials(name) {
  return name
    .split(' ')
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join('');
}
