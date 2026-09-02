/// Inclusive household relationship + living-arrangement helpers for Family Hub.
library;

/// Relationship of this person to the signed-in user (Beth).
const relationshipOptions = <(String, String)>[
  ('self', 'Me'),
  ('partner', 'Partner'),
  ('child', 'Child (mine)'),
  ('step_child', 'Stepchild'),
  ('partners_child', "Partner's child"),
  ('parent', 'Parent'),
  ('step_parent', 'Step-parent'),
  ('grandparent', 'Grandparent'),
  ('grandchild', 'Grandchild'),
  ('aunt', 'Aunt'),
  ('uncle', 'Uncle'),
  ('partners_ex', "Partner's ex / co-parent"),
  ('co_parent', 'Co-parent'),
  ('sibling', 'Sibling'),
  ('step_sibling', 'Step-sibling'),
  ('friend', 'Friend'),
  ('family_friend', 'Family friend'),
  ('coworker', 'Co-worker'),
  ('carer', 'Carer'),
  ('pet', 'Pet'),
  ('other', 'Other'),
];

/// Birthday / calendar relation labels (same catalog, without self/pet).
List<(String, String)> get birthdayRelationOptions => relationshipOptions
    .where((o) => o.$1 != 'self' && o.$1 != 'pet')
    .toList();

/// Where this person usually lives relative to the user's home.
const livingArrangementOptions = <(String, String)>[
  ('lives_with_me', 'Lives with us'),
  ('shared_custody', 'Shared custody'),
  ('visitation', 'Visits / stays with us sometimes'),
  ('lives_elsewhere', 'Lives elsewhere'),
  ('international', 'Lives overseas / international separation'),
  ('deceased', 'Deceased / in memory'),
];

String relationshipLabel(String key) {
  for (final o in relationshipOptions) {
    if (o.$1 == key) return o.$2;
  }
  return key.replaceAll('_', ' ');
}

String livingArrangementLabel(String key) {
  for (final o in livingArrangementOptions) {
    if (o.$1 == key) return o.$2;
  }
  return key.replaceAll('_', ' ');
}

bool isChildRelationship(String relationship) => const {
      'child',
      'step_child',
      'partners_child',
      'grandchild',
    }.contains(relationship);

bool isParentRelationship(String relationship) => const {
      'parent',
      'step_parent',
      'co_parent',
      'partners_ex',
    }.contains(relationship);

/// True when this person is part of day-to-day "at home" list.
bool isLocalHousehold(String livingArrangement) =>
    livingArrangement == 'lives_with_me' || livingArrangement == 'shared_custody';

/// True when person primarily lives away (visits, overseas, elsewhere).
bool livesAwayPrimarily(String livingArrangement) => const {
      'visitation',
      'lives_elsewhere',
      'international',
    }.contains(livingArrangement);

bool isDeceasedArrangement(String livingArrangement) =>
    livingArrangement == 'deceased';

/// Family Hub list placement: core household/family vs Contacts subsection.
const listKindFamily = 'family';
const listKindContact = 'contact';

/// Relationships that belong in the core Family Hub list by default.
bool isCoreFamilyRelationship(String relationship) => const {
      'self',
      'partner',
      'child',
      'step_child',
      'partners_child',
      'parent',
      'step_parent',
      'co_parent',
      'partners_ex',
      'pet',
    }.contains(relationship);

/// Suggested list for add/edit flows (user can still choose explicitly).
String defaultListKindFor(String relationship) {
  if (relationship == 'self' || relationship == 'pet') return listKindFamily;
  return isCoreFamilyRelationship(relationship) ? listKindFamily : listKindContact;
}

String listKindLabel(String listKind) =>
    listKind == listKindContact ? 'Contacts' : 'Family Hub';
