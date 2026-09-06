# TETHER — MODULE 11: CLOUD RESOURCE LIBRARY
## Complete Design Specification

**Module:** Cloud Resource Library  
**Version:** v1.0 — Route Map Aligned  
**Risk:** 🟢-🟠 (🟠 for high-risk topics — must be accredited or expert-reviewed)  
**Phase:** 2B (full library with metadata, categories, cloud updates)  
**Status:** ⬜ Not yet built — spec ready

---

## 1. WHAT THE CLOUD RESOURCE LIBRARY IS

The Cloud Resource Library is the central repository for all educational, support, and reference content in Tether. It is cloud-based — the source of truth lives on the server and is updated centrally. The app caches content for performance and offline access, but the server is authoritative.

It answers the question: *"What do I need to know about this, and can I trust this information?"*

The library serves every other module. Health Status links to accredited condition resources. Reproductive Health links to postpartum and contraception guidance. Mental Health Toolkit links to crisis resources and coping strategies. Family Hub links to child development and baby-led weaning guides. Every module pulls from the same library. Nothing is duplicated. Nothing is out of date.

---

## 2. CORE PRINCIPLES

| Principle | What It Means |
|-----------|---------------|
| **Cloud-first, cache-second** | The server is the source of truth. Content updates without app updates. The app caches for performance and offline access, but the cache is invalidated when the server version changes. |
| **Accredited or labelled** | Every resource has a source label. Users know whether they're reading a government health guideline, an expert-reviewed article, a lived-experience piece, or a community idea. |
| **High-risk = accredited only** | Topics like CPR, choking, anaphylaxis, fever in infants, safe sleep, seizures, postpartum psychosis, suicidal ideation, and domestic violence safety require accredited or expert-reviewed sources. No exceptions. |
| **Versioned and reviewed** | Every resource has a last-reviewed date and a next-review date. Outdated content is flagged. Resources can be updated, replaced, or retired without an app update. |
| **Accessible, not overwhelming** | Resources are written in plain language. Summaries are available. Emergency information is clearly marked. Reading level is appropriate for the general public. |

---

## 3. HOW YOU GET HERE

**Primary:** Bottom nav → ⋯ More → 📚 Resource Library (once added from Module Management).  
**From any module:** Links within Health Status, Reproductive Health, Mental Health Toolkit, Family Hub, Meals — all open the relevant resource in the library.  
**From search:** The library is searchable from the Dashboard search bar (Phase 2B+).

---

## 4. RESOURCE LIBRARY MAIN SCREEN

```
┌─────────────────────────────────────┐
│  ← Dashboard   📚 RESOURCE LIBRARY  │
├─────────────────────────────────────┤
│                                     │
│  🔍 Search resources...             │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📂 BROWSE BY CATEGORY        │   │
│  │                             │   │
│  │ 🩺 Health & Conditions  [>]│   │
│  │ 🧠 Mental Health        [>]│   │
│  │ 🍼 Parenting & Children  [>]│   │
│  │ 🩸 Reproductive Health  [>]│   │
│  │ 🍽 Food & Nutrition      [>]│   │
│  │ 🏠 Household & Safety    [>]│   │
│  │ 💰 Finance & Budget      [>]│   │
│  │ ♿ Accessibility          [>]│   │
│  │ 🌈 LGBTQIA+ Health       [>]│   │
│  │ 🩺 Men's Health          [>]│   │
│  │ 👵 Ageing & Elder Care   [>]│   │
│  │ 🐾 Pets & Animal Care    [>]│   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ⚡ EMERGENCY RESOURCES       │   │
│  │                             │   │
│  │ · CPR / First Aid          │   │
│  │ · Choking                  │   │
│  │ · Anaphylaxis              │   │
│  │ · Fever in infants         │   │
│  │ · Seizure first aid        │   │
│  │ · Safe sleep for babies    │   │
│  │ · Postpartum haemorrhage   │   │
│  │ · Mental health crisis     │   │
│  │ [View all emergency]       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📌 SAVED RESOURCES           │   │
│  │ · Safe sleep guidelines     │   │
│  │ · Introducing solids        │   │
│  │ [View all saved]            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🕐 RECENTLY VIEWED           │   │
│  │ · Mastitis signs (2 days    │   │
│  │   ago)                      │   │
│  │ · Paracetamol dosing for    │   │
│  │   infants (5 days ago)      │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 5. RESOURCE METADATA

Every resource in the library carries the following metadata:

| Field | Description | Example |
|-------|-------------|---------|
| **Title** | Resource title | "Safe Sleeping Guidelines for Infants" |
| **Topic** | Specific topic within category | "Safe Sleep" |
| **Module** | Which module(s) this resource serves | Family Hub, Health Status |
| **Source Type** | Accreditation level (see below) | 🏛️ Accredited Resource |
| **Author / Reviewer** | Who wrote or reviewed it | Red Nose Australia |
| **Source Organisation** | The publishing body | Red Nose Australia |
| **Country / Region** | Geographic relevance | Australia |
| **Age Relevance** | Relevant age groups | 0-12 months |
| **Condition Relevance** | Relevant conditions (if any) | N/A |
| **Risk Level** | 🟢 Low / 🟠 Medium / 🔴 High | 🟠 Medium |
| **Source Link** | URL to original source | https://rednose.org.au/... |
| **Last Reviewed Date** | When the content was last reviewed | 15th March 2026 |
| **Next Review Date** | When it should be reviewed again | 15th March 2027 |
| **Content Version** | Version number | v2.1 |
| **Plain-Language Summary** | 1-2 sentence plain-English summary | "How to put your baby to sleep safely and reduce the risk of SIDS." |
| **Emergency / Red-Flag Notes** | If applicable, critical safety information | "If your baby stops breathing, call 000 immediately." |

---

## 6. RESOURCE LABELS

Every resource carries one of four labels. The label tells the user what kind of information they're reading.

| Label | Name | Description | Example |
|-------|------|-------------|---------|
| 🏛️ | **Accredited Resource** | Government health body, professional college, clinical guideline, hospital/health service. The gold standard. | Raising Children Network, Healthdirect Australia, RACGP guidelines, WHO, CDC |
| ✅ | **Expert-Reviewed Article** | Written or reviewed by a qualified professional in the relevant field. | Article reviewed by a registered midwife, paediatrician, or clinical psychologist |
| 💬 | **Lived Experience** | Personal story, parent/carer/patient experience. Helpful for connection and community. Not medical advice. | "My experience with postpartum anxiety" — shared with permission |
| 🏠 | **Community Idea** | Practical tips, meal ideas, routines, home organisation, life hacks. Not medical or professional advice. | "How we manage bath time with twins" — from the Tether community |

**High-risk topics must carry 🏛️ Accredited or ✅ Expert-Reviewed labels. No exceptions.**

---

## 7. HIGH-RISK TOPICS (🔴 — MUST BE ACCREDITED OR EXPERT-REVIEWED)

These topics require the highest standard of sourcing. Community ideas and lived-experience pieces are not acceptable as primary resources for these topics.

| Topic | Examples |
|-------|----------|
| **CPR** | Infant CPR, adult CPR, hands-only CPR |
| **Choking** | Infant choking first aid, child choking, adult choking |
| **Anaphylaxis** | Signs, symptoms, EpiPen use, emergency response |
| **Fever in infants** | When to seek help, febrile convulsions, temperature taking |
| **Safe sleep** | SIDS reduction, co-sleeping risks, safe bedding |
| **Seizures** | First aid, when to call ambulance, epilepsy management |
| **Diabetes** | Hypoglycaemia management, insulin safety, DKA warning signs |
| **Blood pressure** | Hypertensive crisis signs, pre-eclampsia warning signs |
| **Pregnancy complications** | Reduced fetal movement, bleeding, pre-eclampsia, preterm labour |
| **Postpartum psychosis** | Symptoms, emergency response, support resources |
| **Suicidal ideation / self-harm** | Crisis resources, safety planning, when to seek emergency care |
| **Domestic violence / coercive control** | Safety planning, emergency exits, support services |
| **Medication dosing** | Paracetamol/ibuprofen dosing for children — links to official guidelines only. No calculators. |

---

## 8. RESOURCE DETAIL VIEW

```
┌─────────────────────────────────────┐
│  ← Library    SAFE SLEEP GUIDELINES │
├─────────────────────────────────────┤
│                                     │
│  🏛️ Accredited Resource            │
│  Red Nose Australia                │
│  Last reviewed: 15th March 2026    │
│  Next review: 15th March 2027      │
│  Version: v2.1                     │
│                                     │
│  📋 Plain-language summary:         │
│  How to put your baby to sleep      │
│  safely and reduce the risk of      │
│  SIDS.                              │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  [Full resource content — pulled    │
│   from cloud, displayed in-app]     │
│                                     │
│  ⚠ EMERGENCY:                      │
│  If your baby stops breathing,      │
│  call 000 immediately and start     │
│  CPR.                               │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  Relevant to:                       │
│  · Age: 0-12 months                │
│  · Module: Family Hub, Health       │
│    Status                           │
│                                     │
│  Source:                            │
│  https://rednose.org.au/...        │
│                                     │
│  [Save]  [Share]  [Open original]  │
│                                     │
└─────────────────────────────────────┘
```

---

## 9. CONTENT MANAGEMENT (ADMIN SIDE — NOT USER-FACING)

The Cloud Resource Library is managed through a content management system. This is not part of the user-facing app but is the backend that supports it.

### 9.1 Content Update Flow

```
Admin adds/updates resource in CMS
        │
        ▼
Resource stored in cloud database with metadata
        │
        ▼
Server increments content version
        │
        ▼
App checks version on next library access
        │
        ▼
If server version > cached version:
  · App downloads updated resource(s)
  · Old cached version is replaced
  · No app update required
```

### 9.2 Resource Lifecycle

| State | Description |
|-------|-------------|
| **Draft** | Being written. Not visible to users. |
| **In Review** | With a reviewer (for expert-reviewed content). Not visible. |
| **Published** | Live in the library. Visible to users. |
| **Flagged for Review** | Past its next-review date. Still visible but with a ⚠ "This resource is overdue for review." banner. |
| **Deprecated** | Replaced by a newer resource. Redirects to the replacement. |
| **Retired** | Removed from the library. No longer accessible. Cached versions invalidated. |

---

## 10. SEARCH & DISCOVERY

### 10.1 Search

- Full-text search across all resource titles, topics, summaries, and content.
- Filterable by: category, source type, age relevance, condition relevance, risk level.
- Results sorted by relevance. Emergency resources pinned to the top when relevant keywords are searched.

### 10.2 Browse by Category

Each category page shows:

- Featured resources (curated, most relevant).
- Recent updates.
- Most saved.
- Sub-categories for drill-down.

### 10.3 Related Resources

At the bottom of every resource detail view:

- "Related resources" — other resources on the same topic or condition.
- "People who saved this also saved..." — community-driven discovery.

---

## 11. OFFLINE BEHAVIOUR

- **Cached resources:** Available offline. The user can read them without an internet connection.
- **Emergency resources:** Pre-cached on install. Always available, even without internet.
- **Cache invalidation:** When the app regains connectivity, it checks the server version. If the server version is newer, the cache is updated.
- **Offline indicator:** A small banner: "📡 Offline — showing saved version from 15th June. [Check for updates]"

---

## 12. INTEGRATION WITH OTHER MODULES

| Module | How It Uses the Library |
|--------|--------------------------|
| **Health Status** | Condition-specific resources. Red-flag symptom guidance. Medication information. Appointment preparation guides. |
| **Reproductive Health** | Pregnancy week-by-week guides. Postpartum recovery. Contraception information. Baby development. Menopause resources. Men's health. |
| **Mental Health Toolkit** | Crisis resources. Coping strategy guides. Therapy modality explanations. Self-help workbook links. |
| **Family Hub** | Child development milestones. Baby-led weaning guides. Safe sleep. Immunisation schedules. School readiness. Teen mental health. |
| **Meals** | Allergy information. Introducing solids. Safe food preparation for infants. Choking hazards. Nutritional guidelines. |
| **Budget** | Financial literacy resources. Bill assistance programs. Energy comparison guides. |
| **Accessibility** | NDIS guides. Disability support resources. Assistive technology information. |

---

## 13. COMMUNITY CONTENT (Phase 3+)

In future phases, the library may include community-contributed content.

**Community Idea (🏠):**

- Practical tips and life hacks from Tether users.
- Moderated before publication.
- Clearly labelled as community content, not professional advice.
- Cannot be the primary resource for high-risk topics.

**Lived Experience (💬):**

- Personal stories shared with consent.
- Moderated for safety and accuracy of claims.
- Helpful for connection, not a substitute for professional guidance.
- Clearly labelled.

**Influencers:**

- Can contribute lived-experience or practical content.
- Not treated as clinical authority.
- Content labelled appropriately.

---

## 14. PHASE DELIVERY

| Phase | What Ships |
|-------|------------|
| **2B** | Core library with 50-100 seed resources across all categories. All metadata fields. Resource labels. High-risk topic enforcement. Cloud-based updates. Search and browse. Offline caching. Emergency resources pre-cached. Integration with Health Status, Reproductive Health, Mental Health Toolkit, Family Hub, and Meals. |
| **3** | Community content (moderated). User saving and sharing. Personalised recommendations based on user's conditions, age of children, and saved resources. "Trending in your area" (if location enabled). |
| **4+** | Multi-language support. Audio versions of resources. Video content. Integration with wearable and health device data for contextual resource suggestions. |

---

## 15. SEED RESOURCES (TO BE INCLUDED AT LAUNCH)

### Emergency (🔴 — Pre-cached)

| Resource | Source |
|----------|--------|
| Infant CPR | Healthdirect Australia / Raising Children Network |
| Choking first aid (infant, child, adult) | St John Ambulance Australia |
| Anaphylaxis signs and emergency response | ASCIA |
| Fever in infants — when to seek help | Raising Children Network |
| Seizure first aid | Epilepsy Action Australia |
| Safe sleep guidelines | Red Nose Australia |
| Postpartum haemorrhage warning signs | PANDA / COPE |
| Mental health crisis resources | Lifeline Australia |

### Health & Conditions (🟠)

| Resource | Source |
|----------|--------|
| Blood pressure — understanding your readings | Heart Foundation Australia |
| Asthma action plan | Asthma Australia |
| Diabetes — hypoglycaemia management | Diabetes Australia |
| Migraine management | Headache Australia |
| Chronic pain self-management | Pain Australia |

### Parenting & Children (🟠)

| Resource | Source |
|----------|--------|
| Introducing solids | Raising Children Network |
| Baby-led weaning — safe preparation | Raising Children Network |
| Immunisation schedule | Australian Immunisation Register |
| Developmental milestones 0-5 years | Raising Children Network |
| Toilet training | Raising Children Network |

### Reproductive Health (🟠)

| Resource | Source |
|----------|--------|
| Contraception options | Family Planning Australia |
| Pregnancy week-by-week | Raising Children Network |
| Postpartum recovery | COPE / PANDA |
| Mastitis signs and management | Australian Breastfeeding Association |
| Perimenopause and menopause | Jean Hailes for Women's Health |

### Mental Health (🟠)

| Resource | Source |
|----------|--------|
| Anxiety — self-help strategies | Beyond Blue |
| Depression — understanding and support | Beyond Blue |
| PTSD — treatment and recovery | Phoenix Australia |
| Grounding techniques | Therapist Aid (adapted) |
| Urge surfing | SMART Recovery Australia |

### Men's Health (🟠)

| Resource | Source |
|----------|--------|
| Prostate health | Prostate Cancer Foundation Australia |
| Testicular self-check | Healthy Male / Andrology Australia |
| Erectile dysfunction — when to see a GP | Healthy Male |

---

## 16. WHAT THE CLOUD RESOURCE LIBRARY DOES NOT DO

- It does not host unverified content on high-risk topics. 🔴 topics require accredited or expert-reviewed sources.
- It does not allow community content to be presented as medical advice.
- It does not replace professional medical, financial, or legal advice.
- It does not require an app update to refresh content. The cloud is authoritative.
- It does not force resources on users. Resources are available, not pushed. The exception is emergency resources, which are always accessible.
- It does not track what users read for any purpose other than improving recommendations (if the user opts in).

---

That's the Cloud Resource Library. Cloud-first. Accredited or labelled. High-risk topics strictly sourced. Versioned and reviewed. Accessible offline. Serves every module.
