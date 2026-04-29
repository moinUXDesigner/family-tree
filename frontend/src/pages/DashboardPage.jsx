import { useEffect, useMemo, useState } from 'react';
import { LogOut, RefreshCw, TreePine } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLE_LABELS } from '../config/roles.js';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Alert, Badge, Button } from '../app/components';
import { familyApi } from '../services/familyApi.js';
import { treeApi } from '../services/treeApi.js';

export function DashboardPage({ role }) {
  const { logout, token, user } = useAuth();
  const [families, setFamilies] = useState([]);
  const [selectedFamilyId, setSelectedFamilyId] = useState(user.family_id ?? '');
  const [tree, setTree] = useState({ family: null, nodes: [], links: [], root_member_ids: [] });
  const [focusedMemberId, setFocusedMemberId] = useState(null);
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    let isMounted = true;

    async function loadFamilies() {
      try {
        const families = await familyApi.listFamilies(token);
        const defaultFamilyId = preferredOverviewFamilyId(families, user.family_id);

        if (!isMounted) {
          return;
        }

        setFamilies(families);
        setSelectedFamilyId((current) => current || defaultFamilyId);
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
  }, [token, user.family_id]);

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

        if (!isMounted) {
          return;
        }

        setTree(nextTree);
        setFocusedMemberId(defaultFocusedMemberId(nextTree, user.id));
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
  }, [selectedFamilyId, token, user.id]);

  const focusTree = useMemo(
    () => buildFocusTree(tree, focusedMemberId, user.id),
    [focusedMemberId, tree, user.id],
  );

  return (
    <main className="dashboard-page">
      <NavigationChrome active="overview" role={role} />

      <section className="dashboard-content overview-content">
        <header className="dashboard-header overview-header">
          <div>
            <Badge variant="primary">{ROLE_LABELS[user.role]}</Badge>
            <h1>{tree.family?.name ?? 'Family Tree'}</h1>
            <p>Click any person to navigate their parents, spouse, children, and siblings.</p>
          </div>
          <Button onClick={logout} type="button" variant="outline">
            <LogOut aria-hidden="true" />
            Logout
          </Button>
        </header>

        {error ? <Alert variant="error">{error}</Alert> : null}

        {families.length > 1 ? (
          <div className="overview-family-toolbar">
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
          </div>
        ) : null}

        <section className="family-focus-shell" aria-label="Focused family tree">
          <div className="family-focus-title">
            <TreePine aria-hidden="true" />
            <strong>Family Tree</strong>
          </div>

          {isLoading ? (
            <div className="empty-state compact">
              <RefreshCw aria-hidden="true" />
              <strong>Loading family tree</strong>
              <p>Reading members and relationships from the local database.</p>
            </div>
          ) : null}

          {!isLoading && !error && !focusTree.focus ? (
            <div className="empty-state compact">
              <TreePine aria-hidden="true" />
              <strong>No tree data yet</strong>
              <p>Add members and relationships to display the family tree.</p>
            </div>
          ) : null}

          {focusTree.focus ? (
            <div className="family-focus-board">
              <section className="focus-main-tree" aria-label="Selected person family tree">
                <FamilySection className="parents-section" title="Parents" tone="green">
                  <div className="focus-pair">
                    {focusTree.parents.length > 0 ? (
                      focusTree.parents.map((person) => (
                        <PersonBubble
                          key={person.id}
                          onSelect={setFocusedMemberId}
                          person={person}
                        />
                      ))
                    ) : (
                      <EmptyBubble label="Parents not added" />
                    )}
                  </div>
                </FamilySection>

                <div className="focus-connector vertical from-parents" aria-hidden="true" />

                <FamilySection className="couple-section" title={focusTree.focus.isYou ? 'You & Spouse' : 'Person & Spouse'} tone="blue">
                  <div className="focus-pair">
                    <PersonBubble
                      isFocused
                      onSelect={setFocusedMemberId}
                      person={focusTree.focus}
                    />
                    {focusTree.spouses.length > 0 ? (
                      focusTree.spouses.map((person) => (
                        <PersonBubble
                          key={person.id}
                          onSelect={setFocusedMemberId}
                          person={person}
                        />
                      ))
                    ) : (
                      <EmptyBubble label="Spouse not added" />
                    )}
                  </div>
                </FamilySection>

                <div className="focus-connector vertical to-children" aria-hidden="true" />

                <FamilySection className="children-section" title="Children" tone="purple">
                  <div className="children-row">
                    {focusTree.children.length > 0 ? (
                      focusTree.children.map((person) => (
                        <PersonBubble
                          key={person.id}
                          onSelect={setFocusedMemberId}
                          person={person}
                        />
                      ))
                    ) : (
                      <EmptyBubble label="Children not added" />
                    )}
                  </div>
                </FamilySection>
              </section>

              <aside className="siblings-panel" aria-label="Siblings">
                <div className="section-pill amber">Siblings</div>
                <div className="siblings-list">
                  {focusTree.siblings.length > 0 ? (
                    focusTree.siblings.map((person) => (
                      <PersonBubble
                        compact
                        key={person.id}
                        onSelect={setFocusedMemberId}
                        person={person}
                      />
                    ))
                  ) : (
                    <EmptyBubble label="Siblings not added" />
                  )}
                </div>
              </aside>
            </div>
          ) : null}
        </section>
      </section>
    </main>
  );
}

function FamilySection({ children, className, title, tone }) {
  return (
    <section className={`focus-family-section ${className}`}>
      <div className={`section-pill ${tone}`}>{title}</div>
      {children}
    </section>
  );
}

function PersonBubble({ compact = false, isFocused = false, onSelect, person }) {
  return (
    <button
      className={[
        'person-bubble',
        compact ? 'compact' : '',
        isFocused ? 'focused' : '',
        person.isYou ? 'you' : '',
      ].filter(Boolean).join(' ')}
      onClick={() => onSelect(person.id)}
      type="button"
    >
      <span className={`person-portrait ${person.gender}`}>
        {person.initials}
      </span>
      <strong>{person.isYou ? 'You' : person.name}</strong>
      <small>{person.years}</small>
    </button>
  );
}

function EmptyBubble({ label }) {
  return (
    <div className="person-bubble empty">
      <span className="person-portrait unknown">?</span>
      <strong>{label}</strong>
      <small>Not linked</small>
    </div>
  );
}

function preferredOverviewFamilyId(families, userFamilyId) {
  return userFamilyId
    ?? families.find((family) => family.slug === 'shaik-nanne-saheb-family')?.id
    ?? families.find((family) => family.name?.toLowerCase().includes('nanne saheb'))?.id
    ?? families[0]?.id
    ?? '';
}

function defaultFocusedMemberId(tree, userId) {
  return tree.nodes.find((node) => node.user_id === userId)?.id
    ?? tree.root_member_ids?.[0]
    ?? tree.nodes[0]?.id
    ?? null;
}

function buildFocusTree(tree, focusedMemberId, userId) {
  const nodeMap = new Map(tree.nodes.map((node) => [node.id, node]));
  const focusNode = nodeMap.get(focusedMemberId);

  if (!focusNode) {
    return { focus: null, parents: [], spouses: [], children: [], siblings: [] };
  }

  const parentLinks = tree.links.filter((link) => link.relationship_type === 'parent');
  const spouseLinks = tree.links.filter((link) => link.relationship_type === 'spouse');
  const siblingLinks = tree.links.filter((link) => link.relationship_type === 'sibling');

  const parentIds = parentLinks
    .filter((link) => link.to_member_id === focusNode.id)
    .map((link) => link.from_member_id);
  const childIds = parentLinks
    .filter((link) => link.from_member_id === focusNode.id)
    .map((link) => link.to_member_id);
  const spouseIds = spouseLinks
    .filter((link) => link.from_member_id === focusNode.id || link.to_member_id === focusNode.id)
    .map((link) => (link.from_member_id === focusNode.id ? link.to_member_id : link.from_member_id));
  const siblingIdsFromParents = parentLinks
    .filter((link) => parentIds.includes(link.from_member_id) && link.to_member_id !== focusNode.id)
    .map((link) => link.to_member_id);
  const siblingIdsFromLinks = siblingLinks
    .filter((link) => link.from_member_id === focusNode.id || link.to_member_id === focusNode.id)
    .map((link) => (link.from_member_id === focusNode.id ? link.to_member_id : link.from_member_id));

  return {
    focus: personFromNode(focusNode, userId),
    parents: peopleFromIds(parentIds, nodeMap, userId),
    spouses: peopleFromIds(spouseIds, nodeMap, userId),
    children: peopleFromIds(childIds, nodeMap, userId),
    siblings: peopleFromIds([...siblingIdsFromParents, ...siblingIdsFromLinks], nodeMap, userId),
  };
}

function peopleFromIds(ids, nodeMap, userId) {
  return [...new Set(ids)]
    .map((id) => nodeMap.get(id))
    .filter(Boolean)
    .map((node) => personFromNode(node, userId));
}

function personFromNode(node, userId) {
  return {
    id: node.id,
    name: node.name,
    years: lifeYears(node),
    gender: node.gender ?? 'unknown',
    initials: initials(node.name),
    isYou: node.user_id === userId,
  };
}

function lifeYears(node) {
  const birthYear = node.birth_date ? node.birth_date.slice(0, 4) : null;
  const deathYear = node.death_date ? node.death_date.slice(0, 4) : null;

  if (birthYear && deathYear) {
    return `${birthYear} - ${deathYear}`;
  }

  if (birthYear && !node.is_living) {
    return `${birthYear} - Deceased`;
  }

  return birthYear ?? 'Dates not added';
}

function initials(name) {
  return name
    .split(' ')
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join('');
}
