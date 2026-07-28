# Family Hub spec (summary)

Canonical product spec for the Family Hub module: household status, People, Pets, Household chores/shopping, and School sections. Add-person flow is a wizard (Child / Partner / Other / Pet) with profile fields, DOB-driven age groups, and feature toggles for children.

Poly-friendly: multiple partners supported without a single-partner constraint.

DOB syncs to calendar birthday events (`source: family_hub`, `event_type: birthday`) with conflict prompt (keep calendar vs use DOB).

See implementation: `lib/screens/family_hub/`, `lib/providers/family_hub_provider.dart`.
