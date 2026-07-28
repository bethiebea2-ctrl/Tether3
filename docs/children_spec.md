# Children / care profiles (summary)

Age-specific person detail screens keyed by `person_id`:

- **Baby**: medications (as-needed intervals), quick log (feed, nap, nappy, bath, tummy, other), activity feed, 7-day feeding chart.
- **Toddler / child / teen**: age-appropriate quick logs; school hub placeholder for school-aged; teen privacy toggles (local flags until 2A).

Data: `medications`, `medication_logs`, `feeding_logs`, `care_activity_logs` with `person_id` (migrated from `child_id`).

Red lines: no dose calculators or clinical interpretation.

See `lib/screens/family_hub/person_detail_screen.dart`, `lib/database/family_care_dao.dart`.
