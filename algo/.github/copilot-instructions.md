# Copilot Instructions for This Project

These rules apply to all Swift / SwiftUI code generated or modified in this workspace.

---

# Critical Development Rules

## ALWAYS Build After Changes

**After making ANY code changes, you MUST verify the build succeeds.**

Run:
```bash
xcodebuild -project algo.xcodeproj -scheme algo -destination 'platform=iOS Simulator,name=iPhone 16' build
```

- Check for compilation errors with `grep -E "error:"`.
- Fix ALL errors before considering the work complete.
- Do NOT tell the user "it should work" without actually building.
- Syntax errors, missing braces, duplicate files, and import issues happen - catch them early.

---

# Architecture: MVVM + Router + Repository

## Fundamentals

- Use SwiftUI with `NavigationStack` (iOS 17+).
- Each screen has:
  - One SwiftUI `View` (UI only)
  - One `ViewModel` (state + presentation logic)
- Use a Router with a `Route` enum for navigation.
- ViewModels depend on protocol abstractions:
  - `AppRouting` for navigation
  - Repository protocols for data access
  - Service / UseCase protocols for domain logic
- Data access goes through Repositories.
- Domain logic goes into Services / UseCases / Domain objects.
- ViewModels should remain shallow and screen-scoped, not god objects.

---

## View Responsibilities

Views:

- Render UI.
- Bind to ViewModel state.
- Dispatch user intents to the ViewModel (e.g. `onAppear()`, `didTapX()`, `didSelectItem(_:)`).
- Contain no networking.
- Contain no domain/business logic.
- Contain no navigation logic except calling ViewModel methods.
- Ideally stay under ~150 lines.

---

## ViewModel Responsibilities

A ViewModel is a UI-facing orchestrator.

A ViewModel may:

- Hold UI state (loading flags, error messages, lists, selected item IDs, etc.).
- Contain presentation logic (UI-specific decisions, mapping domain models to view models, sorting for the UI).
- Perform simple input validation related to this screen.
- Coordinate calls to:
  - Repositories
  - Services / UseCases
  - Router (via `AppRouting` protocol)
- Handle loading and error states.
- Expose clear intent methods:
  - `onAppear()`
  - `didPullToRefresh()`
  - `didTapPrimaryButton()`
  - `didSelectItem(_:)`

A ViewModel must not:

- Perform raw networking (`URLSession`, manual decoding, request building).
- Contain domain-wide business rules (pricing, booking eligibility, tax rules, KYC rules, trading logic, etc.).
- Implement multi-step business workflows end-to-end (use a UseCase/Service instead).
- Manage `NavigationPath` directly (Router owns it).
- Contain logic obviously reusable by multiple screens (move to Service/Domain).
- Grow large methods (> ~25–30 lines) without extraction.
- Depend on SwiftUI types beyond what is necessary for `ObservableObject` and `@Published`.

---

## Domain Logic vs Presentation Logic

Domain logic (does NOT belong in ViewModel):

- Pricing rules.
- Booking eligibility.
- Tax and fee calculation.
- Payment validation.
- Wallet or trading rules.
- KYC/AML and compliance rules.
- Discount and promotion rules.
- Business invariants and core entity behaviors.

These must live in Services / UseCases / Domain objects.

Presentation logic (may belong in ViewModel):

- Enabling/disabling buttons based on UI state.
- Choosing which empty state to show.
- Sorting/filtering items specifically for this screen’s UI.
- Screen-specific flags such as “first time visit” banners.
- Mapping domain models to UI-facing view state structs.

---

## ViewModel Abuse Prevention (Critical)

Before adding logic to a ViewModel, apply this checklist:

1. Is this UI orchestration for this screen?
   - If yes → ViewModel is a candidate.
2. Is this domain/business logic that should be consistent across the app?
   - If yes → Service / UseCase / Domain object, not ViewModel.
3. Does this logic require data access (API, database, persistence)?
   - If yes → Repository.
4. Is this method longer than ~25–30 lines or doing multiple things?
   - If yes → Extract to helper or Service / UseCase and call from ViewModel.
5. Will another screen likely need this logic?
   - If yes → Service / Domain.
6. Would a domain expert care about this logic as part of “how the business works”?
   - If yes → Domain / UseCase, not ViewModel.

A good ViewModel is shallow, screen-focused, and delegates real work outward.

---

## Screen vs Embedded Component Rules

When designing UI, you must decide: **separate screen** or **embedded component**?

### Use Separate Screens (with Route, ViewModel, Navigation) when:

1. **User Navigation Intent**: The user would say "I go to this screen" or "I navigate to this"
2. **Back Button Behavior**: Pressing back should return to the previous screen (not just hide UI)
3. **Independent Entry Points**: Can be reached from multiple places (deep link, share, notification, different flows)
4. **Distinct Task/Mode**: Represents a different task, workflow step, or mode of operation
5. **Own Lifecycle**: Has meaningful appear/disappear lifecycle (data loading, cleanup, analytics tracking)
6. **Own Navigation Bar**: Needs its own title, toolbar buttons, navigation context
7. **Screen Transitions**: Should animate in/out as a distinct screen change
8. **Shareable/Bookmarkable**: Could be deep-linked or shared as a URL
9. **Significant State**: Has complex state that lives beyond simple show/hide
10. **Different Layout**: Fundamentally different layout from parent (not just conditional sections)

**Examples**: Profile screen, Trip details, Checkout flow steps, Settings, Search results

### Use Embedded Components (inline state switching) when:

1. **Conditional Sections**: Different sections of the same logical screen (tabs, accordions, sheets)
2. **Visual Variants**: Same screen showing different states (empty, loading, error, success)
3. **Small UI Changes**: Button states, modal overlays, inline forms
4. **Parent-Owned State**: State only makes sense within the parent (expand/collapse, filter toggles)
5. **No Back Navigation**: Dismissing it doesn't change the navigation stack
6. **Reusable Building Blocks**: Cards, headers, list items, custom controls
7. **Transient UI**: Popovers, tooltips, alerts, inline validation messages
8. **Synchronized State**: Multiple views that must stay perfectly in sync with parent

**Examples**: Loading spinners, empty states, filter panels, accordions, inline editors

### Multi-Step Flows: The Critical Decision

For wizard-like flows (e.g., signup, booking, checkout, drill practice):

**Use SEPARATE SCREENS when:**
- ✅ User can/should navigate back to previous steps
- ✅ Each step is independently complex (own data loading, validation, error handling)
- ✅ Steps can be bookmarked or deep-linked
- ✅ Steps could be reused in different flows
- ✅ Clear "step 1 → step 2 → step 3" mental model
- ✅ User might exit and resume later (needs persistent navigation state)
- ✅ Steps have different navigation bars/titles

**Use INLINE STATE SWITCHING when:**
- ✅ Steps MUST be completed in strict order (can't skip or go back)
- ✅ All steps share the same data/session (tightly coupled state)
- ✅ Abandoning flow means losing everything (no partial save)
- ✅ Steps are simple variations of the same UI (just different questions/fields)
- ✅ Navigation feels wrong (it's one continuous experience, not separate destinations)
- ✅ Back button should mean "cancel entire flow", not "previous step"

**When Unsure:**
- Ask: "If I press back, should I go to the previous step, or cancel the whole thing?"
  - Previous step → **Separate screens**
  - Cancel whole thing → **Inline state**
- Ask: "Can this step exist independently or be accessed directly?"
  - Yes → **Separate screens**
  - No → **Inline state**

### Examples:

**Separate Screens (Drill Flow):**
```swift
// ✅ CORRECT - Each step is a separate screen
enum AppRoute {
    case drillPatternRecognition(problem: Problem)
    case drillCoding(problem: Problem, selectedPattern: PatternType)
    case drillComparison(problem: Problem, userCode: String)
    case drillRating(problem: Problem, attempt: Attempt)
}

// Back button on Comparison goes back to Coding
// Each step can be deep-linked or resumed
```

**Inline State (Simple Form Wizard):**
```swift
// ✅ CORRECT - Simple form with multiple pages
enum FormStep {
    case personalInfo
    case address
    case confirmation
}

var body: some View {
    switch currentStep {
    case .personalInfo: PersonalInfoForm(...)
    case .address: AddressForm(...)
    case .confirmation: ConfirmationView(...)
    }
}
// Back button cancels entire form
// Steps share the same form data object
```

---

## Router Rules

- Use `NavigationStack` only inside the Router / App root.
- Define a `Route` enum to represent screens.
- The Router:
  - Owns `NavigationPath`
  - Maps `Route` to SwiftUI Views via `.navigationDestination(for:)`
  - Exposes methods like `push(_ route: Route)`, `pop()`, `popToRoot()`, etc.
- ViewModels interact with navigation only through an `AppRouting` protocol.
- ViewModels must not mutate `NavigationPath` directly.

---

## Repository Rules

Repositories:

- Handle all data access (network, local storage, files, etc.).
- Map raw responses / DTOs into domain models.
- Do not contain SwiftUI or UI logic.
- Do not contain navigation logic.
- Prefer `async/await` for asynchronous operations.
- Are depended on via protocols (e.g. `TripRepository`, `UserRepository`).

---

## Services / UseCases / Domain Objects

Use a Service / UseCase / Domain object when logic is:

- Multi-step and complex.
- Domain-critical and used in multiple places.
- Likely to evolve as business rules change.
- Involving multiple repositories or subsystems.

Examples:

- `BookingUseCase`
- `TripPricingService`
- `AuthService`
- `EligibilityService`
- `PortfolioCalculationService`

These should be testable independently from View and ViewModel.

---

# Engineering Principles for AI Assistant

These principles govern how changes should be proposed and applied.

## Core Methodology

### 1. Minimal Intervention Principle

- Make the smallest change that solves the problem.
- One logical change per iteration.
- Preserve working code unless explicitly refactoring.
- Default to editing over deleting/recreating.

### 2. Evidence-Based Debugging

- Read actual code before diagnosing.
- Verify assumptions by checking file contents.
- Test simple hypotheses first (Occam's Razor).
- Blame the most recent change, not external factors.

### 3. Incremental Problem Solving

**Debug Priority:**

1. Syntax/typos (property names, method calls)
2. View hierarchy (container types, modifiers)
3. State management (lifecycle, bindings)
4. Architecture (navigation, data flow)

### 4. Code Reading Before Code Writing

- Verify property/method names exist before using them.
- Check actual types before assuming them.
- Read existing patterns before creating new ones.
- Understand the system before modifying it.

---

## Decision Framework

### Should I create a new file?

- Is there explicit request? → Yes
- Is there >200 lines of unrelated code? → Maybe
- Am I "cleaning up"? → No

Default behavior: avoid creating new files unless necessary by the rules above.

---

## Success Metrics

### Good Session

- Minimal changes.
- Fast iterations.
- Problems solved at the lowest complexity level.
- Code compiles and works.
- Architecture and patterns are preserved.
- App builds and compiles successfully.

### Bad Session

- Files deleted/recreated without explicit request.
- Multiple failed approaches and rewrites.
- Theoretical debugging without reading code.
- Ignoring existing patterns.
- User frustration.

---

## Meta-Learning

After each mistake:

1. What was the actual problem?
2. What did I try first?
3. What should I have tried first?
4. Update mental model and heuristics.

---

## Engineering Balance

Remember:  
Senior engineers debug methodically, change minimally, and verify constantly.  
They experiment and observe instead of theorizing blindly.

---

## Architecture Decision Framework

When building new features:

1. **Assess scope**  
   - Is this a one-off or part of a pattern?

2. **Evaluate reusability**  
   - Will this code be used elsewhere?
   - Is that likely or just hypothetical?

3. **Choose appropriate abstraction level**  
   - One-off feature → Keep it simple, inline
   - Used 2–3 times → Extract to function/component
   - Core pattern → Build proper abstraction with extensibility

4. **Future-proof pragmatically**  
   - Add extension points only where change is probable, not just possible.

---

## Quality vs Speed Trade-offs

Shipping working code is NOT enough when:

- Building core infrastructure (repositories, services, models).
- Creating reusable components.
- Establishing patterns others will follow.
- Technical debt will compound quickly.

In those areas, favor clarity, correctness, and maintainability over speed.

---

## Reusability Decision Matrix

Build for reuse when:

- The same pattern is needed in 3+ places (Rule of Three).
- Clear interface boundaries exist.
- Variation is predictable and scoped.
- Maintenance cost is lower than duplication cost.

Do not build for reuse when:

- Premature – only one use case exists.
- Forced – trying to unify genuinely different things.
- Speculative – “we might need this someday”.
- Over-engineered – simple duplication is clearer and easier to maintain.

---

## The Pragmatic Path

1. **Start simple** – Solve the immediate problem directly.
2. **Notice patterns** – When similar code appears 2–3 times.
3. **Extract deliberately** – Create abstractions with clear, demonstrated value.
4. **Evolve architecture** – Let structure emerge from real needs, not anticipated ones.

Principle:  
Write code that is easy to change tomorrow, not code that handles every scenario today.  
The best architecture does not prevent future refactoring and keeps current code clear.
