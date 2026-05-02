import { useEffect, useMemo, useState } from 'react';
import { ChevronDown, ChevronRight, LogOut, Network, RotateCcw, UsersRound } from 'lucide-react';
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
  const [focusMemberId, setFocusMemberId] = useState(null);
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

  const familyHeadId = useMemo(
    () => chooseFamilyHeadId(tree.nodes, tree.links, tree.root_member_ids),
    [tree.links, tree.nodes, tree.root_member_ids],
  );

  const focusedNode = focusMemberId ? nodeMap.get(focusMemberId) : null;

  const focusedFamily = useMemo(
    () => buildFocusedFamily(focusMemberId, nodeMap, tree.links),
    [focusMemberId, nodeMap, tree.links],
  );

  const spouseLinks = useMemo(
    () => tree.links.filter((link) => link.relationship_type === 'spouse'),
    [tree.links],
  );

  useEffect(() => {
    setFocusMemberId(defaultFocusedMemberId(tree, user.id, familyHeadId));
  }, [familyHeadId, tree, user.id]);

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
    ['Spouse links', spouseLinks.length],
  ];

  return (
    <main className="dashboard-page">
      <NavigationChrome active="tree" role={role} />

      <section className="dashboard-content tree-dashboard-content">
        <header className="dashboard-header">
          <div>
            <Badge variant="primary">{ROLE_LABELS[user.role]}</Badge>
            <h1>{tree.family?.name ?? 'Family Tree'}</h1>
            <p>Tap a person to view parents, spouse, children, and siblings.</p>
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
          <Card className="tree-graph-card" padding="lg" variant="elevated">
            <div className="section-heading tree-desktop-heading">
              <div>
                <h2>Tree graph</h2>
                <p>
                  {isLoading
                    ? 'Loading tree...'
                    : focusedNode
                      ? `${focusedNode.name} is shown as Self.`
                      : 'Choose a member to view their immediate family.'}
                </p>
              </div>
              <Network aria-hidden="true" />
            </div>

            {focusedNode ? (
              <FocusedFamilyGraph
                family={focusedFamily}
                familyHeadId={familyHeadId}
                focusMemberId={focusMemberId}
                onFocus={setFocusMemberId}
              />
            ) : null}

            {!isLoading && tree.nodes.length === 0 ? (
              <div className="tree-canvas">
                <div className="empty-state">
                  <UsersRound aria-hidden="true" />
                  <strong>No members yet</strong>
                  <p>Add members and relationships to render a tree.</p>
                </div>
              </div>
            ) : null}
          </Card>
        </section>
      </section>
    </main>
  );
}

function FocusedFamilyGraph({ family, familyHeadId, focusMemberId, onFocus }) {
  return (
    <>
      <div className="focused-tree-canvas desktop-tree-canvas">
        <TreeRelationSection
          emptyLabel="Parents not added"
          members={family.parents}
          onFocus={onFocus}
          title="Parents"
        />

        <section className="tree-relation-section self-section" aria-label="Selected person and spouse">
          <div className="tree-section-title">
            <span>Self</span>
          </div>
          <div className="tree-self-row">
            <TreePersonCard
              isFamilyHead={family.self.id === familyHeadId}
              isFocused
              member={family.self}
              onFocus={onFocus}
            />
            <div className="tree-spouse-group">
              <span>Spouse</span>
              {family.spouses.length > 0 ? (
                <div className="tree-card-grid compact">
                  {family.spouses.map((member) => (
                    <TreePersonCard key={member.id} member={member} onFocus={onFocus} />
                  ))}
                </div>
              ) : (
                <EmptyTreeSlot label="Spouse not added" />
              )}
            </div>
          </div>
          {focusMemberId !== familyHeadId ? (
            <button className="tree-reset-button" onClick={() => onFocus(familyHeadId)} type="button">
              <RotateCcw aria-hidden="true" size={16} />
              Family head
            </button>
          ) : null}
        </section>

        <TreeRelationSection
          emptyLabel="Siblings not added"
          members={family.siblings}
          onFocus={onFocus}
          title="Siblings"
        />

        <TreeRelationSection
          emptyLabel="Children not added"
          members={family.children}
          onFocus={onFocus}
          title="Children"
        />
      </div>

      <MobileFocusedFamilyGraph family={family} familyHeadId={familyHeadId} onFocus={onFocus} />
    </>
  );
}

function MobileFocusedFamilyGraph({ family, familyHeadId, onFocus }) {
  return (
    <div className="mobile-tree-card">
      <div className="mobile-tree-panel-header">
        <Network aria-hidden="true" />
        <strong>Family Tree</strong>
      </div>

      <div className="mobile-tree-panel-body">
        <MobileSectionLabel tone="green">Parents</MobileSectionLabel>
        <div className="mobile-family-pair parents">
          {family.parents.length > 0 ? (
            family.parents.map((member) => (
              <MobilePersonBubble key={member.id} member={member} onFocus={onFocus} showYears />
            ))
          ) : (
            <MobileEmptyState label="Parents not added" />
          )}
        </div>

        <div className="mobile-tree-connector" aria-hidden="true" />

        <section className="mobile-couple-box" aria-label="Selected person and spouse">
          <MobileSectionLabel tone="blue">You & Spouse</MobileSectionLabel>
          <div className="mobile-family-pair couple">
            <MobilePersonBubble
              isFamilyHead={family.self.id === familyHeadId}
              isFocused
              member={family.self}
              onFocus={onFocus}
            />
            {family.spouses.length > 0 ? (
              family.spouses.map((member) => (
                <MobilePersonBubble key={member.id} member={member} onFocus={onFocus} />
              ))
            ) : (
              <MobileEmptyState label="Spouse not added" />
            )}
          </div>
        </section>

        <div className="mobile-tree-connector" aria-hidden="true" />

        <MobileSectionLabel tone="amber">Siblings</MobileSectionLabel>
        <div className="mobile-tree-list" aria-label="Siblings">
          {family.siblings.length > 0 ? (
            family.siblings.map((member) => (
              <MobilePersonRow key={member.id} member={member} onFocus={onFocus} />
            ))
          ) : (
            <MobileEmptyState label="Siblings not added" />
          )}
        </div>

        <details className="mobile-tree-accordion">
          <summary>
            <span>
              <UsersRound aria-hidden="true" />
              Children
            </span>
            <span className="mobile-tree-action">
              Tap to view
              <ChevronDown aria-hidden="true" />
            </span>
          </summary>
          <div className="mobile-tree-list children">
            {family.children.length > 0 ? (
              family.children.map((member) => (
                <MobilePersonRow key={member.id} member={member} onFocus={onFocus} />
              ))
            ) : (
              <MobileEmptyState label="Children not added" />
            )}
          </div>
        </details>
      </div>
    </div>
  );
}

function MobileSectionLabel({ children, tone }) {
  return (
    <div className="mobile-section-line">
      <span className={`mobile-section-label ${tone}`}>{children}</span>
    </div>
  );
}

function MobilePersonBubble({ isFamilyHead = false, isFocused = false, member, onFocus, showYears = false }) {
  return (
    <button className="mobile-person-bubble" onClick={() => onFocus(member.id)} type="button">
      <span
        className={[
          'mobile-person-avatar',
          genderClass(member.gender),
          isFocused ? 'focused' : '',
          isFamilyHead ? 'family-head' : '',
        ].filter(Boolean).join(' ')}
        aria-hidden="true"
      >
        {initials(member.name)}
      </span>
      <strong>{member.name}</strong>
      {showYears ? <small>{lifeYears(member)}</small> : null}
    </button>
  );
}

function MobilePersonRow({ member, onFocus }) {
  return (
    <button className="mobile-person-row" onClick={() => onFocus(member.id)} type="button">
      <span className={`mobile-row-avatar ${genderClass(member.gender)}`} aria-hidden="true">
        {initials(member.name)}
      </span>
      <span>
        <strong>{member.name}</strong>
        <small>{year(member.birth_date) ?? (member.is_living ? 'Living' : 'Deceased')}</small>
      </span>
      <ChevronRight aria-hidden="true" />
    </button>
  );
}

function MobileEmptyState({ label }) {
  return <div className="mobile-tree-empty">{label}</div>;
}

function TreeRelationSection({ emptyLabel, members, onFocus, title }) {
  return (
    <section className="tree-relation-section" aria-label={title}>
      <div className="tree-section-title">
        <span>{title}</span>
      </div>
      {members.length > 0 ? (
        <div className="tree-card-grid">
          {members.map((member) => (
            <TreePersonCard key={member.id} member={member} onFocus={onFocus} />
          ))}
        </div>
      ) : (
        <EmptyTreeSlot label={emptyLabel} />
      )}
    </section>
  );
}

function TreePersonCard({ isFamilyHead = false, isFocused = false, member, onFocus }) {
  return (
    <button
      className={['tree-person-card', isFocused ? 'focused' : '', isFamilyHead ? 'family-head' : ''].filter(Boolean).join(' ')}
      onClick={() => onFocus(member.id)}
      type="button"
    >
      <span className={`tree-person-avatar ${genderClass(member.gender)}`} aria-hidden="true">
        {initials(member.name)}
      </span>
      <span className="tree-person-copy">
        <strong>{isFocused ? `${member.name} (Self)` : member.name}</strong>
        <span>{member.birth_date ?? 'Birth date not added'}</span>
        {member.location ? <small>{member.location}</small> : null}
      </span>
      <Badge variant={member.is_living ? 'success' : 'neutral'}>
        {member.is_living ? 'Living' : 'Deceased'}
      </Badge>
    </button>
  );
}

function EmptyTreeSlot({ label }) {
  return <div className="tree-empty-slot">{label}</div>;
}

function buildFocusedFamily(focusMemberId, nodeMap, links) {
  const self = nodeMap.get(focusMemberId);

  if (!self) {
    return {
      children: [],
      parents: [],
      self: null,
      siblings: [],
      spouses: [],
    };
  }

  const parentLinks = links.filter((link) => link.relationship_type === 'parent');
  const spouseLinks = links.filter((link) => link.relationship_type === 'spouse');
  const spouseIds = spouseMemberIds(focusMemberId, spouseLinks);
  const parents = uniqueNodes(
    parentLinks
      .filter((link) => link.to_member_id === focusMemberId)
      .map((link) => nodeMap.get(link.from_member_id)),
  );
  const parentIds = new Set(parents.map((parent) => parent.id));
  const inferredParentIds = [...parentIds].flatMap((parentId) => spouseMemberIds(parentId, spouseLinks));
  const children = uniqueNodes(
    parentLinks
      .filter((link) => link.from_member_id === focusMemberId || spouseIds.includes(link.from_member_id))
      .map((link) => nodeMap.get(link.to_member_id)),
  );
  const siblingsFromParents = parentLinks
    .filter((link) => parentIds.has(link.from_member_id) && link.to_member_id !== focusMemberId)
    .map((link) => nodeMap.get(link.to_member_id));
  const siblingsFromLinks = links
    .filter(
      (link) =>
        link.relationship_type === 'sibling' &&
        (link.from_member_id === focusMemberId || link.to_member_id === focusMemberId),
    )
    .map((link) => nodeMap.get(link.from_member_id === focusMemberId ? link.to_member_id : link.from_member_id));
  const spouses = uniqueNodes(
    spouseIds.map((id) => nodeMap.get(id)),
  );

  return {
    children,
    parents: uniqueNodes([
      ...parents,
      ...inferredParentIds.map((id) => nodeMap.get(id)),
    ]),
    self,
    siblings: uniqueNodes([...siblingsFromParents, ...siblingsFromLinks]),
    spouses,
  };
}

function spouseMemberIds(memberId, spouseLinks) {
  return spouseLinks
    .filter((link) => link.from_member_id === memberId || link.to_member_id === memberId)
    .map((link) => (link.from_member_id === memberId ? link.to_member_id : link.from_member_id));
}

function defaultFocusedMemberId(tree, userId, familyHeadId) {
  return tree.nodes.find((node) => node.user_id === userId)?.id
    ?? familyHeadId
    ?? tree.root_member_ids?.[0]
    ?? tree.nodes[0]?.id
    ?? null;
}

function chooseFamilyHeadId(nodes, links, rootMemberIds) {
  if (nodes.length === 0) {
    return null;
  }

  const childIds = new Set(
    links
      .filter((link) => link.relationship_type === 'parent')
      .map((link) => link.to_member_id),
  );
  const childCountByParent = links
    .filter((link) => link.relationship_type === 'parent')
    .reduce((counts, link) => {
      counts.set(link.from_member_id, (counts.get(link.from_member_id) ?? 0) + 1);
      return counts;
    }, new Map());
  const candidates = nodes
    .filter((node) => !childIds.has(node.id))
    .sort((first, second) => {
      const childDelta = (childCountByParent.get(second.id) ?? 0) - (childCountByParent.get(first.id) ?? 0);

      if (childDelta !== 0) {
        return childDelta;
      }

      const rootDelta = Number(rootMemberIds.includes(second.id)) - Number(rootMemberIds.includes(first.id));

      if (rootDelta !== 0) {
        return rootDelta;
      }

      return first.id - second.id;
    });

  return candidates[0]?.id ?? nodes[0].id;
}

function uniqueNodes(nodes) {
  const map = new Map();

  nodes.filter(Boolean).forEach((node) => {
    map.set(node.id, node);
  });

  return [...map.values()].sort((first, second) => first.name.localeCompare(second.name));
}

function genderClass(gender) {
  return ['male', 'female'].includes(gender) ? gender : 'unknown';
}

function year(value) {
  if (!value) {
    return null;
  }

  const match = String(value).match(/\d{4}/);

  return match ? match[0] : null;
}

function lifeYears(member) {
  const birthYear = year(member.birth_date);
  const deathYear = year(member.death_date);

  if (birthYear && deathYear) {
    return `${birthYear} - ${deathYear}`;
  }

  if (birthYear) {
    return member.is_living ? birthYear : `${birthYear} -`;
  }

  if (deathYear) {
    return `Died ${deathYear}`;
  }

  return member.is_living ? 'Living' : 'Deceased';
}

function initials(name) {
  return name
    .split(' ')
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join('');
}
