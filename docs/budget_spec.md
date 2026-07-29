# TETHER — MODULE 7: BUDGET
## Complete Design Specification

**Module:** Budget
**Version:** v1.0 — Route Map Aligned
**Risk:** 🟢 (D2; some D3 if health-related expenses are tracked)
**Phase:** 1B (basic manual tracker, categories, Tim slot) → 1D (sinking funds, bill tracking, subscription review) → 2A (partner sharing, collaborative budget) → 2B (Tim AI insights, smart suggestions)
**Status:** ✅ Phase 1B complete — manual tracker, categories, visual bars, Tim slot

---

## 1. WHAT BUDGET IS

Budget is the module that tracks household finances. It is a manual tracker — there is no bank integration. Beth enters income and expenses manually. The Budget AI instance (Tim — personalisable) provides insights, tracks patterns, and offers suggestions. Tim does not provide regulated financial advice, does not recommend financial products, and does not shame spending.

Budget answers the question: *"Where is our money going, and are we okay?"*

Budget uses the SMART budget format. Beth will provide this reference separately. For now, the spec assumes standard budget categories, visual tracking, sinking funds, bill management, and savings goals.

---

## 2. CORE PRINCIPLES

| Principle | What It Means |
|-----------|---------------|
| **Manual, not automated** | No bank syncing. Beth enters what she wants. Full control. No data leaving the app to financial institutions. |
| **No shame. No judgement.** | Overspending is data, not moral failure. "You've spent $340 of $400 on groceries with 5 days remaining" — factual, not shaming. |
| **Visual, not numerical** | Bars, not spreadsheets. Colours, not raw numbers. Green = on track. Amber = approaching limit. Red = over. Instant understanding. |
| **SMART budget format** | Specific, Measurable, Achievable, Relevant, Time-bound categories. Reference to be provided by Beth. |
| **Tim is an assistant, not an advisor** | Tim (Budget Manager AI) provides insights and suggestions. He does not replace a financial planner. He does not recommend products. He does not judge. |
| **Shared by choice** | Budget categories are private by default. Beth chooses which categories to share with Ant. Personal spending stays personal. |

---

## 3. HOW YOU GET HERE

**Primary:** Bottom nav → ⋯ More → 💰 Budget (once added from Module Management).
**From Dashboard:** Module quick-glance card: "💰 Groceries: $340 of $400 · 5 days remaining" — tappable.
**From Notes:** Capturing an expense via Notes routes here.
**From Team:** Tapping the Budget Manager instance opens Tim's chat, which can surface budget data.

---

## 4. BUDGET MAIN SCREEN

```
┌─────────────────────────────────────┐
│  ← Dashboard         💰 BUDGET      │
├─────────────────────────────────────┤
│                                     │
│  June 2026 · Fortnightly budget     │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ OVERVIEW                     │   │
│  │                             │   │
│  │ Income:      $1,999.00      │   │
│  │ Spent:       $1,355.00      │   │
│  │ Remaining:   $644.00        │   │
│  │                             │   │
│  │ ████████████████░░░░░░░     │   │
│  │ 68% of budget used          │   │
│  │ 5 days remaining            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ CATEGORIES                   │   │
│  │                             │   │
│  │ 🛒 Groceries                │   │
│  │ $340 of $400 · 5 days      │   │
│  │ ████████████░░░░░ 🟡       │   │
│  │                             │   │
│  │ 💡 Bills                    │   │
│  │ $280 of $350 · On track    │   │
│  │ ██████████░░░░░░░ 🟢      │   │
│  │                             │   │
│  │ 👶 Baby                     │   │
│  │ $85 of $150 · Under budget │   │
│  │ ██████░░░░░░░░░░░ 🟢      │   │
│  │                             │   │
│  │ 💑 Date Night               │   │
│  │ $60 of $120 · On track     │   │
│  │ █████░░░░░░░░░░░░ 🟢      │   │
│  │                             │   │
│  │ 🚗 Car                      │   │
│  │ $110 of $200 · On track    │   │
│  │ ███████░░░░░░░░░░ 🟢      │   │
│  │                             │   │
│  │ 💰 Savings                  │   │
│  │ $500 of $500 · ✅ Done     │   │
│  │ ████████████████████ 🟢    │   │
│  │                             │   │
│  │ [+ Add category]            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ⚠ UPCOMING BILLS             │   │
│  │ Car rego · 15th July · $890 │   │
│  │ Optus · 22nd July · $59     │   │
│  │ [View all bills]            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🏦 SINKING FUNDS             │   │
│  │ Car rego: $320 of $890     │   │
│  │ Christmas: $150 of $600    │   │
│  │ [View all funds]           │   │
│  └─────────────────────────────┘   │
│                                     │
│  [+ Add income]  [+ Add expense]    │
│                                     │
└─────────────────────────────────────┘
```

---

## 5. CATEGORIES

### 5.1 Default Categories

| Category | Colour | Type | Description |
|----------|--------|------|-------------|
| 🛒 Groceries | Green | Expense | Food, household supplies |
| 💡 Bills | Amber | Expense | Utilities, phone, internet, insurance |
| 🏠 Rent/Mortgage | Blue | Expense | Housing |
| 👶 Baby | Soft blue | Expense | Nappies, formula, clothes, supplies |
| 💑 Date Night | Pink | Expense | Restaurants, activities, babysitter |
| 🚗 Car | Brown | Expense | Fuel, maintenance, rego |
| 🐾 Pets | Brown | Expense | Food, vet, supplies |
| 🩺 Medical | Red | Expense | Appointments, medications, supplies |
| 🎉 Social | Purple | Expense | Gifts, events, catch-ups |
| 💰 Savings | Teal | Goal | Emergency fund, goals |
| 📦 Subscriptions | Amber | Expense | Streaming, apps, memberships |
| 🛍 Personal | Pink | Expense | Discretionary — clothes, hobbies, treats |
| 📚 School | Navy | Expense | Fees, uniforms, supplies, excursions |
| 💼 Work | Orange | Expense | Uniforms, travel, parking, supplies |

### 5.2 Category Management

Categories are managed in Settings → Budget Categories. Same interface as Event Categories.

- **Add category:** Name, colour, icon, type (expense, income, savings goal).
- **Edit category:** Change any field. Historical data preserved.
- **Delete category:** Prompts for confirmation. Historical data can be recategorised or deleted.
- **Maximum 20 categories.**
- **Share toggle per category:** "Shared with Ant" or "Private." Default: private.

---

## 6. INCOME & EXPENSE LOGGING

### 6.1 Logging Income

```
┌─────────────────────────────────────┐
│  ← Budget          ADD INCOME       │
├─────────────────────────────────────┤
│                                     │
│  Amount *                           │
│  [$1999.00____________________]     │
│                                     │
│  Source                             │
│  [Salary — SNP ▼]                  │
│  · Salary · Gift · Side income     │
│  · Tax return · Other              │
│                                     │
│  Date                               │
│  [Today ▼]                          │
│                                     │
│  Recurring?                         │
│  ○ One-off                          │
│  ● Fortnightly                     │
│  ○ Monthly                          │
│                                     │
│  Notes (optional)                   │
│  [______________________________]   │
│                                     │
│  [Cancel]              [Save]       │
│                                     │
└─────────────────────────────────────┘
```

### 6.2 Logging an Expense

```
┌─────────────────────────────────────┐
│  ← Budget         ADD EXPENSE       │
├─────────────────────────────────────┤
│                                     │
│  Amount *                           │
│  [$85.50______________________]     │
│                                     │
│  Category *                         │
│  [Groceries ▼]                      │
│                                     │
│  Date                               │
│  [Today ▼]                          │
│                                     │
│  Store / Description (optional)     │
│  [Coles______________________________]   │
│                                     │
│  Notes (optional)                   │
│  [Weekly shop — under budget!___]   │
│                                     │
│  [Cancel]              [Save]       │
│                                     │
└─────────────────────────────────────┘
```

### 6.3 Quick-Add

From the Budget main screen, tapping "[+ Add expense]" with no category pre-selected opens the full form. But common expenses can be saved as quick-add buttons:

```
┌─────────────────────────────────────┐
│  QUICK ADD                          │
│  [$5 coffee] [$50 fuel] [$20 lunch] │
│  [+ Custom]                         │
└─────────────────────────────────────┘
```

Tapping a quick-add button logs that expense immediately with today's date and the pre-set category. A small undo toast appears. This makes daily small-expense tracking fast enough to actually use.

---

## 7. BILL TRACKING

### 7.1 Bills Main Screen

```
┌─────────────────────────────────────┐
│  ← Budget         💡 BILLS          │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🔴 OVERDUE                   │   │
│  │ Electricity · $320          │   │
│  │ Due: 25th June · 5 days ago│   │
│  │ [Mark as paid]              │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🟡 UPCOMING                  │   │
│  │                             │   │
│  │ Car rego · $890            │   │
│  │ Due: 15th July · 16 days   │   │
│  │ Sinking fund: $320 saved   │   │
│  │                             │   │
│  │ Optus · $59                 │   │
│  │ Due: 22nd July · 23 days   │   │
│  │                             │   │
│  │ Rent · $1,600               │   │
│  │ Due: 1st July · 2 days     │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ✅ PAID THIS MONTH            │   │
│  │ Insurance · $120 · 5th June │   │
│  │ [View all paid]             │   │
│  └─────────────────────────────┘   │
│                                     │
│  [+ Add bill]                      │
│                                     │
└─────────────────────────────────────┘
```

### 7.2 Adding a Bill

```
┌─────────────────────────────────────┐
│  ← Bills            ADD A BILL      │
├─────────────────────────────────────┤
│                                     │
│  Bill name *                        │
│  [Car rego____________________]     │
│                                     │
│  Amount *                           │
│  [$890.00_____________________]     │
│                                     │
│  Due date *                         │
│  [15th July 2026        📅]        │
│                                     │
│  Recurring?                         │
│  ○ One-off                          │
│  ● Yearly                           │
│  ○ Monthly                          │
│  ○ Quarterly                        │
│                                     │
│  Category                           │
│  [Car ▼]                            │
│                                     │
│  Create sinking fund?               │
│  ☑ Yes — save $74.17/month        │
│                                     │
│  Reminder                           │
│  ☑ 1 week before                   │
│  ☑ 1 day before                    │
│                                     │
│  Notes (optional)                   │
│  [______________________________]   │
│                                     │
│  [Cancel]              [Save]       │
│                                     │
└─────────────────────────────────────┘
```

---

## 8. SINKING FUNDS

Sinking funds are money set aside gradually for known future expenses.

### 8.1 Sinking Funds Main Screen

```
┌─────────────────────────────────────┐
│  ← Budget       🏦 SINKING FUNDS    │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🚗 Car rego                 │   │
│  │ Target: $890                │   │
│  │ Saved: $320 · 36%           │   │
│  │ Due: 15th July              │   │
│  │ $74.17/month                │   │
│  │ ████████░░░░░░░░░░░░ 🟡    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🎄 Christmas                 │   │
│  │ Target: $600                │   │
│  │ Saved: $150 · 25%           │   │
│  │ Due: 1st December           │   │
│  │ $50/month                   │   │
│  │ ██████░░░░░░░░░░░░░░ 🟢    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🏥 Medical/dental            │   │
│  │ Target: $500                │   │
│  │ Saved: $200 · 40%           │   │
│  │ Ongoing — no due date       │   │
│  │ ██████████░░░░░░░░░░ 🟢    │   │
│  └─────────────────────────────┘   │
│                                     │
│  [+ Create sinking fund]           │
│                                     │
└─────────────────────────────────────┘
```

### 8.2 Sinking Fund Suggestions

When a bill is added, the Budget module suggests creating a sinking fund:

"Car rego is $890 due in 12 months. That's $74.17/month or $34.23/fortnight. Want me to set up a sinking fund?"

**Common sinking funds:**
- Car rego, motorbike rego
- Insurance (car, home, health, pet)
- Vet bills
- Christmas, birthdays
- School costs (fees, uniforms, excursions)
- Medical/dental
- Travel, holidays
- Emergency repairs
- Home/moving costs
- Vehicle maintenance
- Baby/kids expenses

---

## 9. SUBSCRIPTION MANAGEMENT

### 9.1 Subscriptions Screen

```
┌─────────────────────────────────────┐
│  ← Budget     📦 SUBSCRIPTIONS      │
├─────────────────────────────────────┤
│                                     │
│  Total: $87.94/month                │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Amazon Prime · $9.99/month  │   │
│  │ Renews: 15th July           │   │
│  │ [Edit] [Cancel sub]         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Disney+ · $13.99/month      │   │
│  │ Renews: 3rd August          │   │
│  │ [Edit] [Cancel sub]         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Apple Music · $5.99/month   │   │
│  │ Renews: 22nd July           │   │
│  │ [Edit] [Cancel sub]         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Optus · $59/month           │   │
│  │ Renews: 22nd of each month  │   │
│  │ [Edit] [Cancel sub]         │   │
│  └─────────────────────────────┘   │
│                                     │
│  [+ Add subscription]              │
│                                     │
│  💡 You could save $13.99/month    │
│  by reviewing Disney+. You haven't │
│  used it in 6 weeks.               │
│                                     │
└─────────────────────────────────────┘
```

**Subscription features:**
- Track recurring subscriptions with cost, renewal date, and frequency.
- Renewal alerts: "Disney+ renews in 3 days."
- Usage awareness: "You haven't used Disney+ in 6 weeks. Still worth it?"
- Annual vs monthly comparison: "Amazon Prime is $9.99/month. Annual is $79 — save $40.88/year."
- One-tap "Cancel sub" opens a note with cancellation steps (not automated — manual).

---

## 10. SAVINGS GOALS

```
┌─────────────────────────────────────┐
│  ← Budget       💰 SAVINGS GOALS    │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🚐 Bus fund                  │   │
│  │ Target: $15,000             │   │
│  │ Saved: $4,200 · 28%         │   │
│  │ Target date: March 2027     │   │
│  │ $450/month needed           │   │
│  │ ████████░░░░░░░░░░░░░░ 🟡  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🆘 Emergency fund            │   │
│  │ Target: $5,000              │   │
│  │ Saved: $3,800 · 76%         │   │
│  │ ████████████████████░░ 🟢   │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ✈️ UK trip (2027)            │   │
│  │ Target: $8,000              │   │
│  │ Saved: $600 · 7.5%          │   │
│  │ ██░░░░░░░░░░░░░░░░░░░░ 🟢  │   │
│  └─────────────────────────────┘   │
│                                     │
│  [+ Create savings goal]           │
│                                     │
└─────────────────────────────────────┘
```

---

## 11. TIM — THE BUDGET AI INSTANCE

Tim is the Budget Manager AI instance. He appears in the Team grid and can be chatted with directly. He also surfaces insights on the Budget main screen.

### 11.1 Tim's Domain

| Can Discuss | Cannot Discuss |
|-------------|----------------|
| Spending patterns and trends | Regulated financial advice |
| Savings suggestions | Financial product recommendations |
| Bill reminders and planning | Investment advice |
| Sinking fund progress | Tax advice |
| Subscription review | Debt consolidation recommendations |
| "Can we afford...?" questions | Anything outside the Budget domain |
| Cheaper alternatives (general) | |
| Budget category adjustments | |

### 11.2 Tim's Insights

Tim surfaces insights on the Budget main screen and in chat:

- "You've spent $340 of $400 on groceries with 5 days remaining. You're on track to stay under budget if you spend less than $12/day."
- "Your car rego is due in 16 days. The sinking fund has $320 of $890. Would you like to top it up?"
- "You haven't used Disney+ in 6 weeks. That's $13.99/month. Reviewing this could save $167.88/year."
- "You've been under budget on Date Night for 3 months. Consider reallocating $20/month to your UK trip fund."
- "Electricity bill is 5 days overdue. Would you like me to remind you to pay it today?"

### 11.3 Tim's Language Rules

| Avoid | Use Instead |
|-------|-------------|
| "You overspent." | "You've spent $340 of $400." |
| "You failed to save." | "The sinking fund is at 36%. On track for the due date." |
| "You're bad with money." | Never. Ever. |
| "You should..." | "Would it help to...?" |
| "You can't afford this." | "If you buy this, you'll have $X remaining for the rest of the fortnight." |

---

## 12. MONTHLY SUMMARY & TRENDS

### 12.1 Monthly Summary Chart

```
┌─────────────────────────────────────┐
│  ← Budget        📊 MAY 2026        │
├─────────────────────────────────────┤
│                                     │
│  Total spent: $2,710                │
│  Total budgeted: $2,900             │
│  Under budget by: $190 ✅           │
│                                     │
│  SPENDING BY CATEGORY               │
│                                     │
│  Groceries  ████████████ $780      │
│  Bills      ██████████░░ $640      │
│  Baby       ███░░░░░░░░░ $210      │
│  Date Night ██░░░░░░░░░░ $120      │
│  Car        ████░░░░░░░░ $260      │
│  Savings    ████████████ $500      │
│  Personal   ██░░░░░░░░░░ $100      │
│  Subscript  █░░░░░░░░░░░ $60       │
│  Other      █░░░░░░░░░░░ $40       │
│                                     │
│  [April] [May] [June]              │
│  [View yearly]                     │
│                                     │
└─────────────────────────────────────┘
```

---

## 13. FINANCIAL SENSITIVITY TOGGLES

When enabled in Settings → Sensitivity Toggles, these adjust Budget behaviour:

| Toggle | Effect |
|--------|--------|
| **Require confirmation before spending** | Any expense over a configurable threshold ($50 default) prompts: "You're about to log a $120 expense. Confirm?" |
| **Delay big financial decisions** | Expenses over $200 show a "Wait 24 hours?" prompt. Not a block. A suggestion. |
| **Avoid shame spending language** | All "overspent" language replaced with neutral "spent X of Y." |
| **Bare-minimum budget mode** | Only essential categories shown (Bills, Rent, Groceries, Baby). Discretionary categories hidden. |
| **Bill warning mode** | Bills due within 7 days are surfaced prominently on Dashboard. |
| **Visual budget bars** | Numbers hidden in favour of visual bars. "About two-thirds full" not "$340 of $400." |
| **Simplified numbers** | Round to nearest $5 or $10. "$340" becomes "~$340." Less precision, less anxiety. |
| **Reduce impulse-purchase prompts** | Quick-add buttons hidden. Shopping suggestions suppressed. |

---

## 14. PARTNER SHARING (Phase 2A)

When Connectable Accounts are active, budget categories can be shared with Ant.

| Feature | Detail |
|--------|--------|
| **Shared categories** | Groceries, Bills, Baby, Date Night — configurable per category. |
| **Private categories** | Personal, Work — never shared. |
| **Both can log** | Ant can log expenses to shared categories from his own Tether app. |
| **Both can see** | Both see shared category balances and transaction history. |
| **Notifications** | "Ant logged a $45 expense to Groceries." |
| **Budget discussions** | Tim can facilitate: "You and Ant have spent $340 of $400 on groceries. 5 days remaining. Want to discuss?" |

---

## 15. SMART BUDGET FORMAT (Reference Pending)

Beth will provide the SMART budget format separately. When received, this section will be updated with:
- Category structure per SMART methodology.
- Savings allocation rules.
- Sinking fund calculation methods.
- Income distribution guidelines.

For now, the Budget module uses standard categories with visual tracking.

---

## 16. STATE RESPONSIVENESS

| State | Budget Behaviour |
|-------|------------------|
| **ADHD Support** | Visual bars emphasised. Quick-add buttons prominent. Simplified numbers. Impulse-purchase warnings. |
| **Depression Support** | Bare-minimum budget mode available. No shame language enforced. "Essentials covered" highlighted. Small wins celebrated. |
| **Anxiety Support** | Upcoming bill warnings more prominent. "What if" scenarios available: "If an unexpected $500 expense came up, you'd still have $144 remaining." |
| **Bipolar Support (hypomania concern)** | Spending confirmation enforced. Big decision delay prompts. "You've logged $340 in discretionary spending this week. This is higher than usual. Pause and review?" |
| **Overwhelmed** | Budget hidden entirely except critical bills. "Bills are covered. The rest can wait." |
| **Low Energy** | Simplified view. No charts. No suggestions. Just the overview bar and critical alerts. |

---

## 17. PHASE DELIVERY

| Phase | What Ships |
|-------|------------|
| **1B** (Current) | Manual income and expense logging. User-defined categories with colour coding. Visual bars (green/amber/red). Basic overview screen. Tim slot in Team grid (placeholder). |
| **1D** | Sinking funds. Bill tracking with due date reminders. Savings goals. Subscription management. Monthly summary chart. Quick-add expense buttons. SMART budget format (once reference provided). |
| **2A** | Partner sharing (per-category toggles). Collaborative budget logging. Tim AI insights (first pass — spending patterns, bill reminders, subscription review). "Can we afford...?" chat queries. |
| **2B** | Full Tim insights (cheaper alternatives, savings projections, category optimisation). Financial sensitivity toggles. Advanced charts and trends. Debt repayment planning. Travel budget planning. |

---

## 18. WHAT BUDGET DOES NOT DO

- It does not connect to bank accounts. Manual only.
- It does not provide regulated financial advice.
- It does not recommend financial products (credit cards, loans, insurance).
- It does not shame. Overspending is data, not moral failure.
- It does not auto-categorise from bank feeds (no bank connection).
- It does not replace a financial planner or accountant.
- It does not share data with third parties.

---

That's Budget. Manual tracker. SMART format. Visual bars. Sinking funds. Bill tracking. Savings goals. Subscription review. Tim the AI assistant. No shame. No judgement. No bank connection.
