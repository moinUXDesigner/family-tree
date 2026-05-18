import { useEffect, useMemo, useState } from 'react';
import { Link } from 'react-router-dom';
import { Pencil, Plus, Trash2, UsersRound } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLES } from '../config/roles.js';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Alert, Badge, Button, Card } from '../app/components';
import { LoadingCard } from '../app/components/LoadingCard.jsx';
import { familyApi } from '../services/familyApi.js';
import { relationshipApi } from '../services/relationshipApi.js';

const memberRoutes = {
  [ROLES.SUPER_ADMIN]: '/super-admin/members',
  [ROLES.ADMIN]: '/admin/members',
  [ROLES.USER]: '/app/members',
};

const relationLabels = {
  parent: 'Parent',
  child: 'Child',
  spouse: 'Spouse',
  sibling: 'Sibling',
  guardian: 'Guardian',
};

export function MyFamilyPage() {
  const { token, user } = useAuth();
  const [members, setMembers] = useState([]);
  const [relationships, setRelationships] = useState([]);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [isDeletingId, setIsDeletingId] = useState(null);

  const selfMember = useMemo(
    () => members.find((item) => item.user_id === user.id)
      ?? members.find((item) => item.email && user.email && item.email.toLowerCase() === user.email.toLowerCase())
      ?? null,
    [members, user.email, user.id],
  );

  const relativeMap = useMemo(() => {
    if (!selfMember) {
      return new Map();
    }

    const selfId = Number(selfMember.id);
    const mapped = new Map();
    const spouseLinks = [];

    relationships.forEach((rel) => {
      const fromId = Number(rel.from_member_id);
      const toId = Number(rel.to_member_id);
      const relationType = normalizeRelationshipType(rel.relationship_type);

      if (relationType === 'parent') {
        if (toId === selfId) {
          addRelation(mapped, fromId, 'parent');
        } else if (fromId === selfId) {
          addRelation(mapped, toId, 'child');
        }
      }

      if (relationType === 'spouse') {
        spouseLinks.push({ fromId, toId });
        if (fromId === selfId) {
          addRelation(mapped, toId, 'spouse');
        } else if (toId === selfId) {
          addRelation(mapped, fromId, 'spouse');
        }
      }

      if (relationType === 'sibling') {
        if (fromId === selfId) {
          addRelation(mapped, toId, 'sibling');
        } else if (toId === selfId) {
          addRelation(mapped, fromId, 'sibling');
        }
      }

      if (relationType === 'guardian') {
        if (toId === selfId) {
          addRelation(mapped, fromId, 'guardian');
        } else if (fromId === selfId) {
          addRelation(mapped, toId, 'child');
        }
      }
    });

    // If only one parent is directly linked, include their spouse as a co-parent.
    const directParentIds = [...mapped.entries()]
      .filter(([, relationTypes]) => relationTypes.has('parent'))
      .map(([memberId]) => Number(memberId));

    directParentIds.forEach((parentId) => {
      spouseMemberIds(parentId, spouseLinks).forEach((spouseId) => {
        addRelation(mapped, spouseId, 'parent');
      });
    });

    return mapped;
  }, [relationships, selfMember]);

  const familyMembers = useMemo(
    () => members
      .filter((member) => relativeMap.has(member.id))
      .filter((member) => !member.is_private)
      .sort((left, right) => relationPriority(relativeMap.get(left.id)) - relationPriority(relativeMap.get(right.id))),
    [members, relativeMap],
  );

  useEffect(() => {
    let isMounted = true;

    async function loadData() {
      if (!token || !user.family_id) {
        return;
      }

      setIsLoading(true);
      setError('');

      try {
        const [memberData, relData] = await Promise.all([
          familyApi.listMembers(token, user.family_id),
          relationshipApi.listRelationships(token, user.family_id),
        ]);

        if (!isMounted) {
          return;
        }

        setMembers(memberData);
        setRelationships(relData.relationships ?? []);
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

    loadData();
    return () => {
      isMounted = false;
    };
  }, [token, user.family_id]);

  async function handleSoftDelete(member) {
    setError('');
    setSuccess('');
    setIsDeletingId(member.id);

    try {
      await familyApi.softDeleteMember(token, member.id);
      setMembers((current) => current.map((item) => (item.id === member.id ? { ...item, is_private: true } : item)));
      setSuccess(`${member.display_name} was removed from My Family (soft delete).`);
    } catch (deleteError) {
      setError(deleteError.message);
    } finally {
      setIsDeletingId(null);
    }
  }

  const memberEditBaseRoute = memberRoutes[user.role] ?? '/app/members';
  const memberAddRoute = `${memberRoutes[user.role] ?? '/app/members'}?quick_add=1`;

  return (
    <main className="dashboard-page">
      <NavigationChrome active="my-family" role={user.role} />

      <section className="dashboard-content">
        {isLoading ? (
          <LoadingCard
            messages={[
              'Connecting family relationships...',
              'Building your family tree...',
              'Preparing your family view...',
            ]}
            variant="relationships"
          />
        ) : null}
        <header className="dashboard-header">
          <div>
            <h1>My Family</h1>
            <p>View only your parents, spouse, siblings, and children.</p>
          </div>
          <Button component={Link} to={memberAddRoute} type="button">
            <Plus aria-hidden="true" />
            Add Member
          </Button>
        </header>

        {error ? <Alert variant="error">{error}</Alert> : null}
        {success ? <Alert variant="success">{success}</Alert> : null}

        <div className="member-list">
          {isLoading ? (
            [...Array(5)].map((_, index) => (
              <article className="member-row member-row-skeleton" key={`my-family-skeleton-${index}`}>
                <div className="member-leading">
                  <div className="member-avatar member-skeleton-block" aria-hidden="true" />
                  <div className="member-leading-meta">
                    <span className="member-skeleton-pill" />
                    <span className="member-skeleton-line short" />
                  </div>
                </div>
                <div className="member-main">
                  <div className="member-title-line">
                    <span className="member-skeleton-line medium" />
                  </div>
                  <small className="member-skeleton-line long" />
                </div>
                <div className="member-meta">
                  <span className="member-skeleton-line short" />
                </div>
              </article>
            ))
          ) : null}

          {!isLoading ? familyMembers.map((member) => (
            <article className="member-row" key={member.id}>
              <div className="member-leading">
                <div className="member-avatar" aria-hidden="true">
                  {member.photo_url ? (
                    <img alt="" src={member.photo_url} />
                  ) : (
                    <UsersRound aria-hidden="true" size={18} />
                  )}
                </div>
                <div className="member-leading-meta">
                  <Badge variant={member.is_living ? 'success' : 'neutral'}>
                    {member.is_living ? 'Living' : 'Deceased'}
                  </Badge>
                  <Badge variant="secondary">
                    {[...relativeMap.get(member.id)].map((type) => relationLabels[type] ?? type).join(', ')}
                  </Badge>
                </div>
              </div>
              <div className="member-main">
                <div className="member-title-line">
                  <strong>{member.display_name}</strong>
                </div>
                <small>
                  {[
                    member.household_name ?? member.display_family_name,
                    [member.current_city, member.current_country].filter(Boolean).join(', '),
                  ].filter(Boolean).join(' | ') || 'No details'}
                </small>
              </div>
              <div className="member-meta">
                <Link className="text-action" to={`${memberEditBaseRoute}?edit_member_id=${member.id}`}>
                  <Pencil aria-hidden="true" size={16} />
                  Edit
                </Link>
                <button
                  className="text-action danger"
                  disabled={isDeletingId === member.id}
                  onClick={() => handleSoftDelete(member)}
                  type="button"
                >
                  <Trash2 aria-hidden="true" size={16} />
                  {isDeletingId === member.id ? 'Removing...' : 'Remove'}
                </button>
              </div>
            </article>
          )) : null}

          {!isLoading && familyMembers.length === 0 ? (
            <div className="empty-state">
              <UsersRound aria-hidden="true" />
              <strong>No immediate family found</strong>
              <p>Add or connect relationships in Tree so parents, spouse, siblings, and children appear here.</p>
            </div>
          ) : null}
        </div>
      </section>
    </main>
  );
}

function addRelation(map, memberId, relationType) {
  const next = map.get(memberId) ?? new Set();
  next.add(relationType);
  map.set(memberId, next);
}

function normalizeRelationshipType(type) {
  const normalized = String(type ?? '')
    .trim()
    .toLowerCase()
    .replace(/[\s-]+/g, '_');

  if (['parent', 'father', 'mother', 'female_parent', 'male_parent'].includes(normalized)) {
    return 'parent';
  }

  if (['child', 'son', 'daughter'].includes(normalized)) {
    return 'child';
  }

  if (['spouse', 'husband', 'wife'].includes(normalized)) {
    return 'spouse';
  }

  if (['sibling', 'brother', 'sister', 'brother_in_law', 'sister_in_law', 'in_law'].includes(normalized)) {
    return 'sibling';
  }

  if (['guardian', 'ward'].includes(normalized)) {
    return 'guardian';
  }

  return normalized;
}

function spouseMemberIds(memberId, spouseLinks) {
  return spouseLinks.flatMap((link) => {
    if (link.fromId === memberId) {
      return [link.toId];
    }

    if (link.toId === memberId) {
      return [link.fromId];
    }

    return [];
  });
}

function relationPriority(relationTypes = new Set()) {
  if (relationTypes.has('parent')) {
    return 1;
  }

  if (relationTypes.has('guardian')) {
    return 2;
  }

  if (relationTypes.has('spouse')) {
    return 3;
  }

  if (relationTypes.has('sibling')) {
    return 4;
  }

  if (relationTypes.has('child')) {
    return 5;
  }

  return 99;
}
