# TETHER — MODULE 6: MEALS
## Complete Design Specification

**Module:** Meals
**Version:** v1.0 — Route Map Aligned
**Risk:** 🟢 (D1-D2; D3 for allergy data)
**Phase:** 1D (basic meal planning, baby-led weaning, pantry inventory) → 2A (collaborative shopping lists, price comparison integration) → 3+ (cross-store price comparison, click & collect integration)
**Status:** ⬜ Not yet built — spec ready

---

## 1. WHAT MEALS IS

Meals is the module that handles everything food-related for the household. It plans meals, manages pantry and fridge inventory, tracks what foods have been introduced to babies, supports sensory and allergy needs, builds shopping lists, and reduces food waste.

It answers the question: *"What are we eating, and do we have what we need?"*

Meals is connected to Family Hub (for household size, ages, allergies, dietary needs) and Budget (for grocery spending). It is not a calorie counter. It is not a diet app. It is a practical, family-aware, sensory-aware, budget-conscious meal coordination tool.

---

## 2. CORE PRINCIPLES

| Principle | What It Means |
|-----------|---------------|
| **Feed the household, not the algorithm** | Meals considers who is eating: a 5-month-old starting solids, a 13-year-old who hates peas, a 16-year-old who is vegetarian, a partner who works late, a mum running on 4 hours of sleep. |
| **Base meal + variations, not separate meals** | One meal. Adaptations for different needs. Adult version. Child version. Baby version. Not four different dinners. |
| **No diet culture. No food morality.** | No calories. No "good food / bad food." No "earn your meal." No weight-loss language. Food is neutral. The language is neutral. |
| **Allergy-aware, not allergy-anxious** | If someone has a serious allergy, the meal generator avoids that allergen across the household unless the user explicitly overrides. Clear labelling. No scare tactics. |
| **Reduce waste, reduce cost** | Pantry and fridge inventory with expiry tracking. "Use this before it goes bad" prompts. "Cook with what you have" suggestions. Budget-aware meal planning. |
| **Baby-led weaning with dignity** | Foods tried are logged without pressure. "Still exploring" not "refused." Multiple exposures are encouraged. Gagging vs choking education is available. |

---

## 3. HOW YOU GET HERE

**Primary:** Bottom nav → ⋯ More → 🍽 Meals (once added from Module Management).
**From Dashboard:** Module quick-glance card: "🍽 No meal plan for tonight. Cook with what's in the fridge?" — tappable.
**From Family Hub:** Household section → "🍽 Meals" or child profile → "🥄 Foods tried."
**From Budget:** Grocery budget link → opens Meals shopping list.

---

## 4. MEALS MAIN SCREEN

```
┌─────────────────────────────────────┐
│  ← Dashboard         🍽 MEALS       │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🍽 TONIGHT                   │   │
│  │                             │   │
│  │ Chicken rice bowls          │   │
│  │ 🕐 30 min · 💰 $18 · 👨‍👩‍👦 5  │   │
│  │                             │   │
│  │ Adult: Seasoned chicken,    │   │
│  │ rice, salad, sauce          │   │
│  │ 👶 Baby: Soft rice, shredded│   │
│  │ chicken, avocado            │   │
│  │ 👦 Theo: Peas on side       │   │
│  │ 👧 Bella: Cucumber instead  │   │
│  │    of peas                  │   │
│  │                             │   │
│  │ [View recipe] [Edit meal]   │   │
│  │ [I made this!]              │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📅 THIS WEEK                 │   │
│  │                             │   │
│  │ Mon · Spag bol        ✅    │   │
│  │ Tue · Fish & veg           │   │
│  │ Wed · Leftovers            │   │
│  │ Thu · Chicken rice bowls   │   │
│  │ Fri · Homemade pizza       │   │
│  │ Sat · TBD                  │   │
│  │ Sun · Roast                │   │
│  │                             │   │
│  │ [Edit week] [Generate plan] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🥄 EVANDER · FOODS TRIED     │   │
│  │                             │   │
│  │ Pumpkin · ✅ · 1st June     │   │
│  │ Avocado · 👅 · 3rd June     │   │
│  │ Banana · ✅ · 5th June      │   │
│  │ Sweet potato · ⏳ tomorrow  │   │
│  │                             │   │
│  │ [+ Log new food]            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📦 PANTRY & FRIDGE           │   │
│  │                             │   │
│  │ 🟡 3 items expiring soon    │   │
│  │ 🔴 1 item expired           │   │
│  │                             │   │
│  │ [View inventory]            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🛒 SHOPPING LIST             │   │
│  │                             │   │
│  │ 5 items · 2 stores          │   │
│  │ ⚠ 2 items needed tonight    │   │
│  │                             │   │
│  │ [View list]                 │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 5. MEAL PLANNING

### 5.1 Weekly Plan View

```
┌─────────────────────────────────────┐
│  ← Meals          📅 THIS WEEK      │
├─────────────────────────────────────┤
│                                     │
│  Week of 30th June — 6th July      │
│                                     │
│  Budget: $200.00                    │
│  People: 4 (2 adults, 1 teen,       │
│  1 baby starting solids)            │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Mon 30th                    │   │
│  │ Spaghetti bolognese    ✅   │   │
│  │ 🕐 45 min · 💰 $22         │   │
│  │ 👶 Baby: Soft pasta + sauce│   │
│  │ [Edit] [Swap]              │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Tue 1st                     │   │
│  │ Fish & seasonal vegetables  │   │
│  │ 🕐 25 min · 💰 $26         │   │
│  │ 👶 Baby: Flaked fish +      │   │
│  │    mashed potato             │   │
│  │ [Edit] [Swap]              │   │
│  └─────────────────────────────┘   │
│                                     │
│  (continues through Sunday)         │
│                                     │
│  [Generate new plan]                │
│  [Reuse past plan]                  │
│                                     │
└─────────────────────────────────────┘
```

### 5.2 Generating a Meal Plan

```
┌─────────────────────────────────────┐
│  ← Meal Plan     GENERATE NEW PLAN  │
├─────────────────────────────────────┤
│                                     │
│  How many days?                     │
│  [7 days ▼]                         │
│                                     │
│  People eating:                     │
│  ☑ Beth                            │
│  ☑ Ant (home by 6:30pm)           │
│  ☑ Theodore                        │
│  ☐ Annabella (at rehearsal Thu)   │
│  ☑ Evander (solids only)          │
│                                     │
│  Budget: [$200.00______________]    │
│                                     │
│  Preferences:                        │
│  ☑ Use pantry items first          │
│  ☑ Include leftovers day           │
│  ☐ Batch cook (make extra)         │
│                                     │
│  Time available:                     │
│  [30 min ▼] on weekdays             │
│  [60 min ▼] on weekends             │
│                                     │
│  Energy level (this week):          │
│  [Medium ▼]                         │
│                                     │
│  [Generate plan]                    │
│                                     │
└─────────────────────────────────────┘
```

### 5.3 Base Meal + Variations

Every meal follows a "base + variations" model. One core meal. Adaptations for different household members.

```
┌─────────────────────────────────────┐
│  ← Plan        CHICKEN RICE BOWLS   │
├─────────────────────────────────────┤
│                                     │
│  🕐 30 min · 💰 $18 · ⭐ Easy       │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🍽 BASE MEAL                 │   │
│  │ · 500g chicken thigh        │   │
│  │ · 2 cups jasmine rice       │   │
│  │ · Mixed salad greens        │   │
│  │ · Soy-ginger sauce          │   │
│  │ [View full recipe]          │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 👶 EVANDER (5mo)             │   │
│  │ · Soft rice (no salt)       │   │
│  │ · Shredded chicken (plain)  │   │
│  │ · Avocado slices            │   │
│  │ ⚠ No honey in sauce         │   │
│  │ ⚠ No whole nuts             │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 👦 THEO (13y)                │   │
│  │ · Extra chicken             │   │
│  │ · Peas on the side          │   │
│  │ · Sauce on the side         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 👧 BELLA (16y)               │   │
│  │ · Vegetarian: tofu instead  │   │
│  │   of chicken                │   │
│  │ · No peas (sub cucumber)    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🛒 SHOPPING LIST             │   │
│  │ [Add all to list]           │   │
│  │ [Add missing only]          │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

**Allergy rule:** If anyone in the household has a serious allergy, the meal generator avoids that allergen across the entire household unless the user explicitly overrides. "This recipe contains peanuts. Theo is allergic. Substituting with sunflower seeds. Override?"

---

## 6. BABY-LED WEANING & FOODS TRIED

### 6.1 Foods Tried Log

```
┌─────────────────────────────────────┐
│  ← Meals      🥄 EVANDER · FOODS    │
├─────────────────────────────────────┤
│                                     │
│  5 foods tried · Started 1st June   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ RECENTLY TRIED               │   │
│  │                             │   │
│  │ 🥑 Avocado                  │   │
│  │ First tried: 3rd June       │   │
│  │ Exposures: 2                │   │
│  │ Reaction: 👅 Still exploring│   │
│  │ Texture: Mashed             │   │
│  │ Notes: Gagged a little but  │   │
│  │ worked it out               │   │
│  │ [Log another exposure]      │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🎃 Pumpkin                   │   │
│  │ First tried: 1st June       │   │
│  │ Exposures: 4                │   │
│  │ Reaction: ✅ Accepted       │   │
│  │ Texture: Purée / soft chunks│   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🍌 Banana                    │   │
│  │ First tried: 5th June       │   │
│  │ Exposures: 3                │   │
│  │ Reaction: ✅ Accepted       │   │
│  │ Texture: Whole (grasped)    │   │
│  └─────────────────────────────┘   │
│                                     │
│  [+ Log new food]                  │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  UPCOMING                           │
│  🍠 Sweet potato · Planned for     │
│  tomorrow                           │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  📚 RESOURCES                       │
│  · Gagging vs choking: what to     │
│    look for                         │
│  · Allergy signs to watch for       │
│  · Safe preparation by age          │
│  · High-risk choking foods to       │
│    avoid                            │
│                                     │
└─────────────────────────────────────┘
```

### 6.2 Logging a New Food

```
┌─────────────────────────────────────┐
│  ← Foods          LOG A NEW FOOD    │
├─────────────────────────────────────┤
│                                     │
│  For: [Evander ▼]                   │
│                                     │
│  Food: [Sweet potato_____________]  │
│                                     │
│  Date first tried:                   │
│  [Today ▼]                          │
│                                     │
│  How was it prepared?               │
│  [Roasted, soft chunks__________]   │
│                                     │
│  Texture offered:                    │
│  [Soft chunks ▼]                    │
│  Purée · Mashed · Soft chunks       │
│  · Finger-sized · Whole            │
│                                     │
│  Reaction:                           │
│  ○ ✅ Accepted                      │
│  ● 👅 Still exploring              │
│  ○ ⚠ Reaction noted (see notes)    │
│                                     │
│  Notes (optional):                  │
│  [Played with it more than ate___]  │
│  [it. Will try again.___________]   │
│                                     │
│  [Cancel]              [Save]       │
│                                     │
└─────────────────────────────────────┘
```

**Language rules for baby-led weaning:**
- Never "refused." Never "didn't like it." Never "failed to eat."
- "Still exploring." "Not sure yet." "Will try again."
- "Some children need 10-15 exposures before accepting a new food. This is normal."
- No pressure. No milestone panic. Every exposure counts, even if they just licked it.

---

## 7. PANTRY & FRIDGE INVENTORY

### 7.1 Inventory Main Screen

```
┌─────────────────────────────────────┐
│  ← Meals        📦 PANTRY & FRIDGE  │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ⚠ ATTENTION NEEDED          │   │
│  │                             │   │
│  │ 🔴 EXPIRED                  │   │
│  │ Arnotts Choc Ripple        │   │
│  │ Expired: 12th May · Qty: 1 │   │
│  │                             │   │
│  │ 🟡 EXPIRING SOON            │   │
│  │ Milk · 30th June · Fridge   │   │
│  │ Chicken thighs · 1st July   │   │
│  │ Spinach · 2nd July          │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🏠 FRIDGE                    │   │
│  │ Milk · 30th June            │   │
│  │ Chicken thighs · 1st July   │   │
│  │ Spinach · 2nd July          │   │
│  │ Cheese · 15th July          │   │
│  │ Eggs · 8th July             │   │
│  │ [+ Add item]                │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📦 PANTRY                    │   │
│  │ Jasmine rice · Nov 2026     │   │
│  │ Pasta · Dec 2026            │   │
│  │ Tinned tomatoes · Mar 2027  │   │
│  │ Arnotts Choc Ripple ·⚠     │   │
│  │ [+ Add item]                │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🧊 FREEZER                   │   │
│  │ Frozen peas · Oct 2026      │   │
│  │ Bread · Aug 2026            │   │
│  │ [+ Add item]                │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### 7.2 Adding Items to Inventory

Items can be added:
- **Manually:** Tapping "[+ Add item]" in any storage location.
- **From shopping list:** When items are checked off a shopping list, the app asks: "Where would you like to store these items? Fridge / Pantry / Freezer." This is the WiseList-inspired "shop to inventory" flow.
- **From Notes:** Capturing a grocery item via Notes can route it to the shopping list or directly to inventory.

### 7.3 Inventory Alerts

- **Expiring soon (🟡):** Items expiring within 48 hours. Surfaces on the Meals main screen and Dashboard quick-glance card.
- **Expired (🔴):** Items past their expiry date. Surfaces as a notification: "3 items have expired. Check your pantry to avoid waste."
- **Low stock:** User-configurable. "Milk is running low. Add to shopping list?"
- **"Cook with what you have":** When inventory has expiring items, a prompt appears: "You have chicken thighs and spinach expiring soon. Here are 3 meals you could make."

---

## 8. SHOPPING LIST

### 8.1 Shopping List Main Screen

```
┌─────────────────────────────────────┐
│  ← Meals         🛒 SHOPPING LIST   │
├─────────────────────────────────────┤
│                                     │
│  5 items · Estimated: $34.50        │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🍽 FOR TONIGHT'S MEAL        │   │
│  │ ☐ Chicken thighs · $8.50   │   │
│  │ ☐ Avocado · $3.00          │   │
│  │ ☐ Cucumber · $2.50         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📦 LOW STOCK                 │   │
│  │ ☐ Milk · $3.80             │   │
│  │ ☐ Bread · $2.50            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📋 MANUALLY ADDED            │   │
│  │ ☐ Dishwashing liquid · $4  │   │
│  └─────────────────────────────┘   │
│                                     │
│  [+ Add item]                      │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  Share list with: [Ant ▼]           │
│  ☐ Collaborative (real-time)       │
│                                     │
│  [Clear checked items]             │
│  [Save as past list]               │
│                                     │
└─────────────────────────────────────┘
```

### 8.2 Smart Shopping List Features

- **Auto-categorised by store section:** Produce, dairy, meat, pantry, frozen, etc. Makes shopping faster.
- **Quantity tracking:** "You need 2 avocados for this week's meals."
- **Price estimation:** Based on past purchases or average prices (Phase 3+ with store integration).
- **Collaborative lists (Phase 2A):** Share with Ant in real-time. "Let's shop together."
- **Past lists:** Reusable. "You bought this exact list on 15th June. Reuse it?"

---

## 9. MEAL-TO-SHOPPING PIPELINE

When a meal plan is generated or a recipe is selected, ingredients are automatically added to the shopping list. Items already in inventory are excluded. Items expiring soon are prioritised.

```
Generate meal plan
        │
        ▼
Check pantry/fridge inventory
        │
        ├── In stock and fresh → Not added to list
        ├── In stock but expiring soon → Added with ⚠ "Use this first"
        └── Not in stock → Added to shopping list
                │
                ▼
        Shopping list updated
        Estimated cost calculated
        "5 items · $34.50"
```

---

## 10. DIETARY & SENSORY PROFILES

Each household member's dietary and sensory needs are stored in their Family Hub profile. Meals reads these and adapts.

| Profile Field | Examples |
|---------------|----------|
| **Allergies** | Peanuts (anaphylactic), dairy (intolerance), eggs (mild) |
| **Intolerances** | Lactose, gluten, FODMAPs |
| **Dietary pattern** | Omnivore, vegetarian, vegan, pescatarian, halal, kosher |
| **Dislikes** | Peas, mushrooms, cooked carrots |
| **Safe foods** | Plain pasta, rice, bread, cheese, apples, chicken nuggets |
| **Sensory preferences** | Prefers crunchy, avoids mushy, likes strong flavours, needs bland |
| **ARFID support** | Very limited safe foods. New foods introduced slowly. No pressure. |
| **Baby-led weaning** | Age, foods tried, textures accepted, allergens introduced |
| **Cultural/religious** | No pork, no beef, halal only, fasting periods |

---

## 11. STATE RESPONSIVENESS

| State | Meals Behaviour |
|-------|-----------------|
| **Low Energy / Exhausted** | Suggests 15-minute meals, leftovers, or "order in tonight." No complex recipes. "Cook with what you have" prioritised. |
| **Depression Support** | Bare minimum meals. "Toast is food. Cereal is food. You fed yourself. That's a win." No pressure to cook. |
| **ADHD Support** | Simple recipes. Short ingredient lists. Visual steps. One-pot meals preferred. "Start the rice. While it cooks, chop the chicken." |
| **Sparkle (Productive)** | Batch cooking suggestions. "You're in the zone — want to make extra for the freezer?" |
| **Overwhelmed** | "Here's the simplest meal using what you already have. One pan. 15 minutes." |
| **Grief Day** | No meal planning pressure. "Order in. Ask Ant to cook. Cereal is fine. You're fed. That's enough." |

---

## 12. FOOD & BODY NEUTRALITY LANGUAGE RULES

Enforced when Food & Body Neutrality Support Preset is active, or when individual Food/Body sensitivity toggles are enabled.

**Never use:**
- "Good food" / "bad food"
- "Clean eating"
- "Cheat meal" / "guilt-free"
- "Burn off" / "earn your meal"
- "Calories" (unless user explicitly opts in)
- "Weight loss"
- "You went over..."
- "They refused it" (for babies)

**Use instead:**
- "Meal" / "food option"
- "Nourishment"
- "What feels manageable?"
- "Supportive choice"
- "Food exposure logged" (for babies)
- "Still exploring" (for babies)

---

## 13. PHASE DELIVERY

| Phase | What Ships |
|-------|------------|
| **1D** | Meal planning (manual + AI-generated). Base meal + variations model. Baby-led weaning foods log. Pantry/fridge inventory (manual entry). Shopping list (manual, single-user). "Cook with what you have" prompts. Dietary profiles read from Family Hub. Expiry tracking and alerts. Budget-aware meal suggestions. |
| **2A** | Collaborative shopping lists (real-time with household). "Shop to inventory" flow (check off list → items added to pantry/fridge). Past plan reuse. Meal rating and favourites. Safe foods list integration. ARFID support (slow introduction tracking). |
| **2B** | Advanced recipe suggestions based on preferences and history. Nutritional awareness (not tracking — just "this meal is high in iron"). Integration with Health Status for condition-aware meals. |
| **3+** | Cross-store price comparison (Coles, Woolworths, Aldi, IGA). Click & Collect / Delivery integration. Barcode scanning for inventory. Smart receipt parsing. |

---

## 14. WHAT MEALS DOES NOT DO

- It does not count calories (unless the user explicitly opts in — and even then, it's neutral).
- It does not push diet culture. No weight-loss language. No "beach body" nonsense.
- It does not shame. "You ordered takeaway three times this week." → No. "You fed yourself three times this week." → Yes.
- It does not diagnose allergies. It tracks what the user tells it. Resources link to accredited sources.
- It does not replace professional dietary advice. For serious allergies, medical conditions, or eating disorder recovery, it defers to clinicians.
- It does not force meal planning. If Beth doesn't want to plan, the module steps back. The quick-glance card says "No plan for tonight" without judgement.

---

That's Meals. Base meal + variations. Baby-led weaning. Pantry and fridge inventory with expiry tracking. Shopping lists. Allergy-aware. Sensory-aware. Budget-conscious. No diet culture.
