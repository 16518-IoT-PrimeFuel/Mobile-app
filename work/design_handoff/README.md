# Handoff: FullTank Mobile App — Auth + Inventory Module

## Overview

FullTank is a B2B fuel supply-chain and logistics mobile app. This handoff covers **8 mobile screens** across two feature modules:

**Authentication (4 screens)**
1. **Splash** — Full-bleed brand intro with auto-advance
2. **Login** — Email + password with Remember me / Forgot flow
3. **Sign Up (Step 1 of 2)** — Role selection (Fuel Supplier vs. Requesting Company) + company info form
4. **Recover Password** — Send access code by email (1-step)

**Inventory Module (4 screens)**
5. **Tank List** — Live IoT sensor readings across all fuel tanks
6. **Tank Detail** — Real-time telemetry (level gauge, temperature, pressure, flow rate, ETA)
7. **Low-Level Alerts** — Grouped critical/warning notifications with inline restock actions
8. **Restock Request** — Order fuel replenishment form with priority, quantity picker, supplier, cost summary

The app targets iOS mobile (portrait) with a bottom tab bar in the Inventory module.

---

## About the Design Files

The files in this bundle are **design references created in HTML/React** — interactive prototypes that show the intended visual design and behavior. They are **not production code to ship directly**.

The task is to **recreate these designs in the target codebase's existing environment** (e.g. React Native, SwiftUI, Flutter, Jetpack Compose, or a mobile web framework) using its established patterns, component library, and conventions. If no environment exists yet, choose the most appropriate framework for the platform and implement the designs there.

Design tokens, exact hex colors, dimensions, and copy in this README are authoritative — treat them as the source of truth.

---

## Fidelity

**High-fidelity (hifi).** All screens are pixel-perfect mockups with finalized colors, typography, spacing, iconography, and interaction states. Recreate the UI pixel-perfectly using the target codebase's libraries and patterns.

Design canvas dimensions used for the mocks: **340 × 720 px** inside an iOS device frame. Real-device layouts should scale fluidly using standard iOS/Android/mobile-web conventions (safe areas, dynamic type, etc.).

---

## Design Tokens

### Colors

| Token | Hex | Usage |
|---|---|---|
| `navy` | `#1A202C` | Headings, primary ink, body text |
| `navyMid` | `#2D3748` | Secondary body copy |
| `blue` | `#1E40AF` | Accent — selected states, links, focus rings, brand borders |
| `blueSoft` | `#EFF4FF` | Selected role card fill, info surface |
| `ctaFrom` | `#FFB300` | CTA gradient start |
| `ctaTo` | `#FFA500` | CTA gradient end |
| `inkMid` | `#4A5568` | Secondary text, form labels |
| `inkSoft` | `#94A3B8` | Placeholders, tertiary meta |
| `line` | `#E2E8F0` | Dividers, input borders, card outlines |
| `card` | `#F3F4F6` | Input fills, resting card surfaces |
| `bg` | `#FFFFFF` | Screen backgrounds |
| `info` | `#DBEAFE` | Light-blue info-box fill |
| `infoBorder` | `#BFDBFE` | Info-box border |

### Status Colors (semantic)

| Token | Hex | Soft variant | Rule |
|---|---|---|---|
| `status.ok` | `#10B981` | `#ECFDF5` | tank level ≥ 40% |
| `status.warn` | `#F59E0B` | `#FFFBEB` | 20% ≤ level < 40% |
| `status.crit` | `#EF4444` | `#FEF2F2` | level < 20% |

Status colors apply to: pills, level bars, gauge fill, telemetry card icons, alert card left-borders, priority chips.

### Typography

- **Family:** Inter (`400`, `500`, `600`, `700`, `800`)
- **Headings (H1):** 26–28px / weight 700 / letter-spacing -0.6 to -0.7 / color `navy`
- **Section labels (uppercase):** 10–11px / weight 700 / letter-spacing 0.4–0.8 / color varies (typically `inkMid` or `blue`)
- **Body:** 13–14px / weight 500 / line-height 1.5 / color `inkMid`
- **Meta / caption:** 10–12px / weight 500–600 / color `inkSoft`
- **Numeric emphasis (gauge center, quantity picker):** 34–44px / weight 800 / letter-spacing -1 to -1.5 / color `navy`

### Spacing & Shape

- **Screen horizontal padding:** 20px (inventory) / 24px (auth)
- **Card padding:** 12–16px
- **Vertical rhythm between form fields:** 12–14px
- **Section vertical gap:** 18–22px
- **Border radius (inputs, cards):** 8px (tweakable 4–16)
- **Border radius (CTA buttons):** 999px (pill)
- **Border radius (role cards, telemetry cards):** 8–12px
- **Border radius (avatars, icon tiles):** 8–12px

### Shadows / Elevation

- **CTA gradient button:** `0 10px 22px -10px rgba(255,165,0,0.8), inset 0 1px 0 rgba(255,255,255,0.35)`
- **Selected role card icon tile:** `0 6px 14px -6px rgba(255,165,0,0.67)`
- **Cards:** no shadow — rely on 1px `line` border on white/`#F3F4F6`

---

## Components

### `TextField`
- Height 46px, radius 8px, background `card` (`#F3F4F6`)
- Left icon (18×18) — color `inkSoft` at rest, `blue` on focus
- On focus: background → white, border → 1.5px `blue`
- Optional trailing element (eye icon for password fields)
- Label above field: 11px / weight 600 / uppercase / `inkMid`

### `PrimaryButton` (CTA)
- Full width, height 52px, radius 999px (pill)
- Background: `linear-gradient(90deg, #FFB300 0%, #FFA500 100%)`
- Text: `#fff`, 15px, weight 700
- Trailing arrow icon (right-arrow) with 10px gap
- Elevated shadow (see tokens)

### `SecondaryButton` (outlined)
- Full width, height 48px, radius 8px
- White background, 1.5px `line` border, color `navy`, 14px weight 600

### `Checkbox`
- 16–18px square, radius 4px
- Unchecked: white fill, 1.5px `line` border
- Checked: `blue` fill + white check icon
- Label 12–13px, color `inkMid`

### `StatusPill`
- Inline pill: `3px 8px` (sm) or `5px 10px` (md), radius 999
- Optional 6px dot in status color
- Text: 11–12px, weight 700, status color; background: status soft

### `LevelBar`
- Horizontal 6px bar, radius 999
- Track: `line` (`#E2E8F0`)
- Fill: status color, width = `pct%`, animated on change

### `RadialGauge`
- 200px circle, 270° arc (rotated -135°)
- Track: 12px stroke, `line`
- Fill: 12px stroke, status color, `strokeDasharray` animated on pct change
- Center: big pct number (44px weight 800) + label + StatusPill

### `MetricCard` (telemetry)
- Padding 12px, radius 8px, white bg + `line` border
- Header row: icon tile (30×30, radius 8, status soft bg + status color icon) + optional trend text (weight 700, status color)
- Label (10.5px uppercase `inkMid`) + value (20px weight 800 `navy`) + unit (11px `inkSoft`)

### `TankRow` (list item)
- Padding 14px, radius 8px, white bg + `line` border
- Left: 44×44 icon tile (status soft bg + status color tank icon)
- Right column: name (14 weight 700) + pct (14 weight 800 status color), location + type (11 `inkMid`), level bar + LIVE indicator (10px `inkSoft`, animated dot when critical)

### `BottomNav`
- Fixed bottom, white bg, 1px `line` top border
- 5 tabs: Home, Inventory, Alerts, Reports, Account
- Active: `blue` color + weight 700; inactive: `inkSoft` + weight 500
- Alerts tab: red badge with count (top-right of icon, 15×15 circle)
- Padding: `10px 8px 22px` (bottom accounts for iOS home indicator)

### `BackButton`
- 40×40 rounded-square, radius 12
- Light: `card` bg, `navy` icon
- On-dark (over hero photos): `rgba(255,255,255,0.15)` bg + 1px `rgba(255,255,255,0.25)` border + blur(10px)

### Header Hero (auth screens)
- 190–220px height
- Full-width photo with `object-fit: cover`
- Gradient overlay: `linear-gradient(180deg, navy55 0%, navyAA 70%, #fff 100%)` (hex `55` = ~33% alpha, `AA` = ~67%)
- Logo (white variant via `brightness(0) invert(1)`) + optional B2B badge in top row over the photo

---

## Screens / Views

### 00 · Splash Screen

**Purpose:** Brand intro shown on cold start; auto-advances to Login after 2–3 seconds.

**Layout:**
- Full-bleed background: `assets/hero-highway.jpg`
- Dark navy gradient overlay: `linear-gradient(180deg, navy(dd) 0%, navy(aa) 40%, navy(f0) 100%)`
- Content flex column, `justify-content: space-between`, padding `40px 32px 40px`

**Components (top → bottom):**
- 54px status bar spacer
- (space)
- Centered block (max-width 300px):
  - FullTank logo (white, height 62px, with drop-shadow `0 8px 24px rgba(0,0,0,0.4)`)
  - Heading (26px / 700 / white / line-height 1.25 / letter-spacing -0.5):
    > "Guaranteed fuel<br/>for your operation"
  - Subtitle (14px / 500 / `rgba(255,255,255,0.75)` / line-height 1.55):
    > "B2B fuel supply chain, digitized."
  - Loading spinner: 38×38 circle, 3px border, `rgba(255,255,255,0.15)` track, `ctaFrom` top color, rotate 360° every 0.9s
- Footer row (11px / `rgba(255,255,255,0.55)` / letter-spacing 0.6):
  - Shield icon (12×12) + text: `SOC 2 · ISO 27001 · v2.4.1`

**Interactions:**
- Auto-navigate to Login after 2500ms (recommended)
- No user input

---

### 01 · Login Screen

**Purpose:** Sign in with corporate credentials.

**Layout:**
- Header hero: 200px tall, `assets/hero-truck.jpg`, navy gradient overlay
- Body: white bg, padding `4px 24px 32px`, negative `marginTop: -8px` to tuck under the hero fade

**Components:**
- **Header row (over photo, z-index 2):**
  - Left: FullTank logo (white variant, height 26px)
  - Right: `B2B · v2.4` pill — 5px/11px padding, radius 999, 1px `rgba(255,255,255,0.35)` border, `rgba(255,255,255,0.12)` bg, backdrop-filter blur(10px), 10.5px weight 700 white text
- **Title block:**
  - H1 "Welcome back" (28px / 700 / `navy` / letter-spacing -0.7)
  - Subtitle "Sign in to manage your supply operations in real time." (13.5px / `inkMid` / line-height 1.5)
- **Form (gap 14px):**
  - `TextField` — label "Corporate Email", envelope icon, placeholder `example@mycompany.com`, type email
  - `TextField` — label "Password", lock icon, placeholder `••••••••`, type password, trailing eye icon
- **Options row (space-between):**
  - `Checkbox` "Remember me" (checked by default)
  - Text link "Forgot password?" (13px / 600 / `blue`)
- **`PrimaryButton`** "Sign In" with right-arrow trailing icon
- **Divider row:** 1px `line` — text "NEW TO FULLTANK" (10.5px / 600 / `inkSoft` / letter-spacing 1) — 1px `line`
- **`SecondaryButton`** "Create business account"
- **Compliance footer** (11px / `inkSoft`, centered, inline-flex):
  - Shield icon + "End-to-end encrypted · SOC 2 Type II"

**Interactions:**
- Focus states on inputs (see `TextField`)
- Eye toggle: show/hide password
- "Forgot password?" → navigate to Recover
- "Create business account" → navigate to Sign Up
- Sign In → validate → dashboard

---

### 02 · Sign Up (Step 1 of 2)

**Purpose:** Collect role + basic company info.

**Layout:**
- White background throughout, 54px status bar spacer, padding `8px 24px 32px`

**Components (top → bottom):**
- **Header row (gap 14):**
  - `BackButton` (light)
  - FullTank logo (color, height 22px)
- **Progress block:**
  - Pill: "STEP 1 OF 2" (`blueSoft` bg, `blue` text, 10.5px weight 700, letter-spacing 0.8, padding 3/9px)
  - Step dots: two 18×3 pills — first `blue`, second `line`
  - H1 "Create your account" (26px / 700)
  - Subtitle "Select your role in the supply chain to configure your dashboard." (13px / `inkMid`)
- **Role selector:**
  - Section label "YOUR ROLE" (11px / 600 uppercase / `inkMid`)
  - Two `RoleCard` in flex row, gap 10px:
    - **Fuel Supplier (selected):** `blueSoft` bg, 1.5px `blue` border, 40×40 icon tile with **orange gradient** background + white truck icon, title `blue`, subtitle "I distribute and deliver fuel", checkmark badge top-right (blue circle + white check)
    - **Requesting Company:** `card` bg, transparent border, white icon tile with `inkMid` chart icon, title `navy`, subtitle "I purchase fuel to operate"
- **Form (gap 12px):**
  - Full Name (user icon)
  - Company Name (building icon)
  - Two-column grid (gap 10): Tax ID (id icon) + Phone (phone icon)
  - Corporate Email (mail icon)
- **`PrimaryButton`** "Continue" with arrow (margin-top 16)
- **Bottom link (centered, 13px / `inkMid`):** "Already have an account? **Sign in**" (Sign in is `blue` weight 600)

**Interactions:**
- Role card is a toggle (only one selected at a time). Update visual state per spec.
- Tapping "Continue" advances to Step 2 (password creation, T&C, etc. — not in this handoff).
- Back button returns to Login.

---

### 03 · Recover Password

**Purpose:** Send an access code to the user's corporate email.

**Layout:**
- Header hero: 190px, `assets/hero-tanks.jpg`, navy gradient overlay
- Body: white, padding `4px 24px 32px`

**Components:**
- **Header (over photo):** BackButton (on-dark variant) + FullTank logo (white)
- **Label pill** "SECURE RECOVERY" (`blueSoft` bg / `blue` text, 10.5px weight 700)
- **H1** "Recover Password" (28px / 700)
- **Subtitle:** "Enter your corporate email to receive the access code."
- **`TextField`** — Corporate Email
- **Info card (light-blue):**
  - Background `info` (`#DBEAFE`), 1px `infoBorder` border, radius 8, padding 14, flex gap 12
  - Left: info icon (18×18, color `infoInk`)
  - Right: title "Check your inbox" (12.5px / 700 / `infoInk`) + body "The code expires in **15 minutes**. If it doesn't appear, check your spam folder." (12px / `navyMid` / line-height 1.5, "15 minutes" bold)
- **`PrimaryButton`** "Send Code" (gradient pill with arrow)
- **Text button** "← Return to login" (44px height, transparent bg, `blue` 13px weight 600)
- **Support card:**
  - `card` bg, radius 8, padding `14px 16px`, flex space-between
  - Left cluster: 36×36 white tile with help icon (navy) + "Need help?" caption + "Contact 24/7 support" (13px / 700 / `navy`)
  - Right: arrow icon (navy)

**Interactions:**
- Send Code → transition to code-entry screen (out of scope) or success toast
- Return to login → navigate to Login
- Support card → open help center / dial

---

### 04 · Tank List (Inventory)

**Purpose:** Overview of all fuel tanks with live IoT levels; filter by status.

**Layout:**
- White bg, padding-bottom 76px (bottom nav clearance)
- Header row (padding `4px 20px 8px`): title/subtitle + search icon button (right)
- Body (padding `10px 20px 20px`)
- Bottom nav (active: `inventory`)

**Components:**
- **Title:** "Inventory" / **Subtitle:** "6 tanks · live IoT"
- **Search button (right):** 40×40, `card` bg, radius 12, search icon
- **Summary grid (3 columns, gap 8):** Critical / Warning / Optimal cards
  - Padding `10px 12px`, radius 8, background = status soft, 1px status-color border (22% alpha)
  - Label (10px / 700 / status color / uppercase) + count "0N" (22px / 800 / `navy` / letter-spacing -0.5, zero-padded to 2 digits)
- **Filter chips (horizontal scroll):** All / Critical / Warning / Optimal
  - Padding `7px 12px`, radius 999
  - Active: `navy` bg + white text; inactive: `card` bg + `navy` text
  - Optional status dot before label; trailing count number (`inkSoft` / white 70%)
- **Tank list:** `TankRow` components in vertical stack, gap 8
  - See `TankRow` spec above
  - Data source: 6 tanks (see mock data)

**Interactions:**
- Filter chip → update filtered list
- Row tap → navigate to Tank Detail
- Search icon → open search overlay

**Mock data (6 tanks):**

| ID | Name | Location | Type | Level | Capacity | Sensor | Updated |
|---|---|---|---|---|---|---|---|
| A-102 | Diesel Tank A-102 | North Yard · Sector 4 | Diesel | 12% | 12,000 L | SN-4492 | 2 min ago |
| B-05 | Water Tank B-05 | Sector 1 | Coolant | 84% | 50,000 L | SN-2011 | 1 min ago |
| C-12 | Lube Tank C-12 | Sector 9 | Lubricant | 35% | 8,000 L | SN-8821 | 3 min ago |
| A-204 | Diesel Tank A-204 | North Yard · Sector 4 | Diesel | 72% | 15,000 L | SN-4499 | just now |
| G-11 | Propane G-11 | Sector 6 | Propane | 18% | 6,000 L | SN-9002 | 5 min ago |
| D-4 | Hydraulic D-4 | Sector 2 | Hydraulic | 58% | 4,000 L | SN-3355 | 4 min ago |

---

### 05 · Tank Detail

**Purpose:** Deep-dive into a single tank's real-time telemetry.

**Layout:**
- White bg, padding-bottom 76 (bottom nav)
- Header row: BackButton + title "A-102" + subtitle "Diesel" + right: LIVE pill (green soft bg, green pulsing dot + "LIVE" text, animation `pulse` opacity 1 → 0.35 → 1 every 1.4s)

**Components:**
- **Gauge card:**
  - White bg, 1px `line` border, radius 8, padding `20px 16px 18px`, centered
  - `RadialGauge` pct=12, label="Current level"
  - Divider row (border-top 1px `line`, padding-top 14, flex space-around):
    - Current: "1,440 L" (16px / 800 / `navy` with 11px `inkSoft` unit)
    - Vertical 1px `line` divider
    - Capacity: "12,000 L"
- **Section label** "REAL-TIME TELEMETRY"
- **2×2 grid of `MetricCard` (gap 8):**
  - Temperature: 24.3 °C — thermo icon, status `ok`
  - Pressure: 1.02 atm — gauge icon, status `ok`, trend `+0.4%`
  - Flow rate: 0.8 L/h out — droplet icon, status `warn`
  - ETA to empty: ~4h — clock icon, status `crit`
- **Sensor meta card:** `card` bg, radius 8, padding 12, flex space-between
  - Left: 32×32 white tile with radio-signal icon (blue) + "SENSOR" label + "SN-4492"
  - Right: "LAST UPDATE" label + "2 min ago"
- **`PrimaryButton`** "Request Restock" with arrow

**Interactions:**
- Live badge pulse animation (CSS keyframes)
- Request Restock → navigate to Restock form with tank pre-selected

---

### 06 · Low-Level Alerts

**Purpose:** Actionable list of tanks needing attention, grouped by severity.

**Layout:**
- White bg, padding-bottom 76
- Header row: BackButton + title "Alerts" + subtitle "4 active · 2 critical" + right: filter icon button
- Bottom nav (active: `alerts`, red badge shows count 3)

**Components:**
- **Critical banner (top):**
  - `critSoft` bg, 1px `crit` border at 33% alpha, radius 8, padding `12px 14px`, flex gap 12
  - 36×36 red tile with white alert icon
  - "2 tanks below 20% capacity" (13px / 700 / `crit`) + "Immediate restock recommended" (11px / `inkMid`)
- **Group divider — Critical:**
  - Row: 6×6 red dot + "CRITICAL" (11px / 700 / `crit` / uppercase) + 1px `line` fill
  - Followed by alert cards
- **Alert card:**
  - White bg, 1px `line` border, **3px left-border in status color**, radius 8, padding 14, flex gap 12
  - 38×38 tile (status soft bg + status color alert icon)
  - Right column:
    - Row 1: tank name (13px / 700 / `navy`) + pct (13px / 800 / status color)
    - Row 2: pin icon + location (11px / `inkMid`)
    - Row 3 (space-between): status pill + ETA meta (clock icon + "~Xh to depletion") + **inline Restock button** (navy bg, white, padding `5px 10px`, radius 999, 11px weight 700)
    - Row 4: relative time (10px / `inkSoft`)
- **Group divider — Warning** (same pattern in amber)

**Mock alerts:**

| Tank | Level | Status | Location | Time | ETA |
|---|---|---|---|---|---|
| Diesel Tank A-102 | 12% | crit | North Yard · Sector 4 | 2 min ago | ~4h to depletion |
| Propane G-11 | 18% | crit | Sector 6 | 5 min ago | ~7h to depletion |
| Lube Tank C-12 | 35% | warn | Sector 9 | 12 min ago | ~2 days |
| Coolant B-07 | 28% | warn | Sector 1 | 18 min ago | ~1.5 days |

**Interactions:**
- Inline Restock → navigate to Restock form with tank pre-selected
- Row tap → Tank Detail
- Filter icon → open filter sheet

---

### 07 · Restock Request

**Purpose:** Submit a fuel replenishment order.

**Layout:**
- White bg. **No bottom nav** on this screen (`hasBottomNav={false}`)
- Header: BackButton + title "Restock Request" + subtitle "Order fuel replenishment"

**Components (top → bottom):**
- **Target tank card:** `card` bg, radius 8, padding 14, flex gap 12
  - 44×44 status-soft tile with tank icon (status color)
  - "TARGET TANK" label + "Diesel Tank A-102" (14px / 700 / `navy`)
  - StatusPill "Critical" + "1,440 / 12,000 L" (11px / `inkMid`)
- **Priority selector (section label "PRIORITY"):** 3 priority chips in flex row, gap 8
  - Padding 12, radius 8, `card` bg (unselected) / status-soft bg (selected)
  - 1.5px transparent border → status color on selected
  - Label (12px / 700, `navy` or status color when selected) + sub (10.5px / `inkMid`)
  - Selected: 14×14 status-color check badge top-right
  - Chips: **Urgent** (red, "ETA < 4h", selected by default) / **Standard** (amber, "ETA 24h") / **Planned** (green, "3–5 days")
- **Quantity picker:**
  - Row: label "QUANTITY" + right meta "max 10,560 L" (10.5px / `inkSoft`)
  - Card: `card` bg, radius 8, padding 16, flex column gap 10
    - Big numeric input: 34px / 800 / `navy` / letter-spacing -1, right-aligned in 130px field, with 16px `inkSoft` "L" unit
    - Quick-pick chips row (centered, wrap): `3,000 L`, `6,000 L`, `9,000 L`, `Fill up` — 5px/11px padding, radius 999, white bg, 1px `line` border, 11.5px weight 600
- **Form (gap 12):**
  - Preferred supplier (fuel icon) — value "Global Fuel Corp"
  - Two-column: Delivery date (calendar icon, "Today") + Window (clock icon, "14:00 – 17:00")
  - Notes for driver (send icon)
- **Order summary card:**
  - `blueSoft` bg, 1px `blue`/22% border, radius 8, padding 14
  - Label "ORDER SUMMARY" (10.5px / 700 / `blue`)
  - Rows (12.5px, space-between): "Fuel (9,000 L × $1.28)" $11,520.00 / "Urgent delivery" + $340.00 / "Taxes" $1,884.16
  - Divider (1px `blue`/22% alpha)
  - Total row (15px / 800 / `navy`): "Estimated total" ↔ "$13,744.16"
- **`PrimaryButton`** "Submit Request"
- **Footer** (11px / `inkSoft`, centered): shield icon + "Encrypted transmission · SLA-guaranteed"

**Interactions:**
- Priority chip is a mutually-exclusive selector
- Quick-pick chip updates the quantity display
- Quantity display should also accept manual keyboard input (currently readonly in the mock)
- Submit → success/confirmation screen (out of scope)

---

## Interactions & Behavior Summary

| Screen | Trigger | Action |
|---|---|---|
| Splash | Auto (~2.5s) | Navigate to Login |
| Login | Sign In | Validate → Home dashboard |
| Login | Forgot password? | Navigate to Recover |
| Login | Create business account | Navigate to Sign Up |
| Sign Up | Role card tap | Toggle selection |
| Sign Up | Continue | Advance to Step 2 |
| Recover | Send Code | Show code-entry (out of scope) |
| Recover | Return to login | Navigate back to Login |
| Tank List | Row tap | Navigate to Tank Detail |
| Tank List | Filter chip | Update visible tanks |
| Tank Detail | Request Restock | Navigate to Restock (tank pre-filled) |
| Alerts | Inline Restock | Navigate to Restock (tank pre-filled) |
| Restock | Priority chip | Update selection |
| Restock | Quick-pick chip | Update quantity |
| Restock | Submit Request | Confirm + navigate to success |

### Animations

- **Splash spinner:** rotate 360° every 0.9s, linear, infinite
- **LIVE badge dot:** opacity `1 → 0.35 → 1` over 1.4s, ease-in-out, infinite
- **LevelBar fill:** width transitions 400ms
- **RadialGauge fill:** `strokeDasharray` transitions 600ms
- **Input focus:** border-color + bg transitions 150ms
- **Priority / Role chip selection:** all-properties 150ms

### Form Validation (recommended, not shown in mock)

- Email fields: RFC-compliant + must belong to a business domain
- Password: min 8 chars, at least one number, one uppercase (for Sign Up)
- Tax ID: format varies by country — accept alphanumeric 8–20 chars
- Phone: E.164 preferred, allow local formats
- Quantity: `> 0` and `≤ (capacity - current)` for the selected tank

---

## State Management

Each screen is stateless in the current prototype except:

- **Sign Up:** `role: 'supplier' | 'requester'` (local state)
- **Tank List:** `filter: 'all' | 'crit' | 'warn' | 'ok'` (local state)
- **Restock:** `priority`, `qty` (local state)
- **Focusable inputs:** each `TextField` tracks its own `focus` boolean

For a production implementation:

- **Auth flow:** hold auth tokens (access + refresh) in secure storage; expose `useAuth()`
- **Live IoT feed:** subscribe to a WebSocket / MQTT stream for tank telemetry; fall back to REST polling (~30s) when disconnected
- **Alerts:** derived from tank data (`pct < 20` → crit, `pct < 40` → warn); bell-badge count is number of active alerts
- **Restock request:** POST to `/api/restock-requests`, then navigate to a confirmation state

---

## Assets

All assets are included under `assets/` in this handoff folder:

| File | Description | Source |
|---|---|---|
| `assets/fulltank-logo.png` | Official FullTank wordmark + fuel-drop logo | Provided by client |
| `assets/hero-highway.jpg` | Tanker truck on open highway at dusk (768×1376) | AI-generated (nano-banana-2-flash-lite), portrait orientation |
| `assets/hero-truck.jpg` | Chrome tanker truck at blue-hour parking (896×1200) | AI-generated |
| `assets/hero-tanks.jpg` | Industrial fuel storage tank farm (896×1200) | AI-generated |
| `assets/hero-refinery.jpg` | Oil refinery at blue-hour with warm safety lights (896×1200) | AI-generated |

**Note:** AI-generated stock imagery is included for prototyping fidelity. For production, source licensed photography with equivalent mood (industrial B2B, blue-hour, no visible logos).

**Icons:** Custom inline SVGs defined in `fulltank-ui.jsx` and `inventory-ui.jsx` (stroke-based, 1.7–2px stroke, `stroke-linecap: round`). Compatible with any icon library that supports 24×24 stroke icons (Lucide, Tabler, Heroicons outline). If migrating: **Lucide** is the closest visual match — recommended replacements:
- `mail`, `lock`, `user`, `building-2`, `id-card`, `phone`, `eye`, `arrow-right`, `arrow-left`, `check`, `shield-check`, `truck`, `bar-chart-2`, `info`, `help-circle`, `search`, `filter`, `chevron-right`, `plus`, `home`, `list`, `pin`, `radio`, `thermometer`, `gauge`, `bell`, `alert-triangle`, `droplet`, `clock`, `calendar`, `send`, `fuel`

**Fonts:** Inter loaded from Google Fonts. Weights used: 400, 500, 600, 700, 800.

---

## Files

Design source files in this handoff bundle:

| File | Purpose |
|---|---|
| `FullTank Auth.html` | Entry point — mounts the design canvas with all 8 screens inside iOS device frames + Tweaks panel |
| `fulltank-ui.jsx` | Shared design system: `FT` token map, `getFT()` hook, `Icon` map, `TextField`, `PrimaryButton`, `SecondaryButton`, `Checkbox`, `BackButton`, `FTLogo` |
| `screens.jsx` | Auth screens: `SplashScreen`, `LoginScreen`, `SignupScreen`, `RecoverScreen` |
| `inventory-ui.jsx` | Inventory design system: status tokens/helpers, `StatusPill`, `LevelBar`, `TankRow`, `RadialGauge`, `MetricCard`, `BottomNav`, `InvShell`, extended `InvIcon` map |
| `inventory-screens.jsx` | Inventory screens: `InventoryListScreen`, `TankDetailScreen`, `AlertsScreen`, `RestockScreen` + mock `TANKS` and `ALERTS` data |

To view the prototype: open `FullTank Auth.html` in a browser. The canvas pans/zooms; click any artboard to focus. Bottom-right corner has a **Tweaks** toggle that opens a live panel to adjust palette (navy, blue, CTA gradient), input radius, and font family — useful for exploring the token space before locking values.

**Framework hint:** the JSX uses React 18 via CDN with Babel-standalone for in-browser compilation. This is prototype scaffolding, not production architecture — a real implementation should use a proper build pipeline (Vite/Next.js/Expo/etc.) and can either lift the components as-is (with small tweaks to imports and styling approach) or reimplement using the target framework's conventions.
