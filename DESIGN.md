# Design System Strategy: The Sovereign Intelligence

## 1. Overview & Creative North Star
This design system is built to transform the traditional, cluttered ERP experience into an authoritative "Intelligence Engine." We are moving away from the "data-entry spreadsheet" aesthetic toward a **High-End Editorial Command Center**. 

**Creative North Star: "The Sovereign Command"**
The interface should feel like a physical glass console—weightless yet powerful. We break the "template" look by using intentional asymmetry in dashboard layouts, overlapping data modules, and a dramatic typography scale. The goal is to make the user feel like an orchestrator of complex logic, not a processor of forms. By prioritizing high-contrast chromatic depth and tonal layering, we ensure that the "intelligence" of the system is felt through clarity and sophistication.

---

## 2. Colors: Chromatic Depth
The palette is rooted in deep obsidian tones and royal violets. Use these tokens to create a sense of infinite depth.

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders for sectioning or containment. Boundaries must be defined solely through background color shifts or subtle tonal transitions. For example, a `surface_container_low` section sitting on a `surface` background provides enough distinction without the visual "noise" of a line.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers—stacked sheets of tinted obsidian.
*   **Base:** `surface_container_lowest` (#0E0E0E) for the deepest background layers.
*   **Workspaces:** `surface_container_low` (#1C1B1B) for main content areas.
*   **Active Modules:** `surface_container_high` (#2A2A2A) to bring attention to specific data clusters.
*   **Nesting:** When placing a container within a container, always shift the tier. An inner card should be `surface_container_highest` (#353534) against a `surface_container_low` backdrop.

### The "Glass & Gradient" Rule
To escape the "flat" look, use Glassmorphism for floating elements (modals, dropdowns, tooltips).
*   **Token:** Use `surface` with 60% opacity and a `20px backdrop-blur`.
*   **Signature Textures:** For primary CTAs or high-level KPIs, use a linear gradient: `primary_container` (#4A148C) to `on_primary_fixed_variant` (#5A2A9C). This creates a "pulse" of energy within the professional charcoal environment.

---

## 3. Typography: The Editorial Voice
We use **Inter** not as a generic sans-serif, but as a Swiss-style tool for information density.

*   **Display (lg/md/sm):** Use for hero metrics. Tracking should be set to -2% for a "tight," high-fashion look.
*   **Headline & Title:** These are your anchors. Use `headline-lg` for section headers to establish an authoritative hierarchy.
*   **Body (lg/md/sm):** Keep data entry and secondary descriptions in `body-md`.
*   **Labels:** Use `label-sm` in all-caps with +5% letter spacing for a refined, technical feel.

**Editorial Intent:** Use drastic scale leaps. Pair a `display-lg` metric with a `label-sm` descriptor. The contrast between the massive and the minuscule creates the "Intelligence Engine" aesthetic.

---

## 4. Elevation & Depth: Tonal Layering
Depth is achieved through "stacking" rather than traditional drop shadows.

*   **The Layering Principle:** Avoid shadows for static elements. A `surface_container_lowest` card on a `surface_container_low` section creates a natural "in-set" look that feels more modern and integrated than a shadow.
*   **Ambient Shadows:** For floating elements only (Modals/Popovers), use a custom shadow: 
    *   `box-shadow: 0 24px 48px rgba(0, 0, 0, 0.4), 0 0 12px rgba(74, 20, 140, 0.1);`
    *   Note the purple tint in the shadow—this mimics the ambient light of the `primary` color.
*   **The "Ghost Border" Fallback:** If a border is required for accessibility, use the `outline_variant` token at **15% opacity**. This creates a "suggestion" of a boundary without breaking the editorial flow.

---

## 5. Components: Precision Primitives

### Buttons
*   **Primary:** Linear gradient (`primary_container` to `on_primary_fixed_variant`). Text color: `on_primary`. Roundedness: `md` (0.375rem).
*   **Secondary:** No background. `outline_variant` (Ghost Border) at 20% opacity. Text: `primary`.
*   **Tertiary:** Transparent background. Text: `secondary`. Subtle `surface_bright` hover state.

### Input Fields
*   **Style:** Avoid 4-sided boxes. Use a `surface_container_low` background with a 2px bottom-border only, using the `primary` token for the active state. 
*   **States:** Use `error` (#FFB4AB) for validation, but keep it sophisticated—a subtle glow rather than a bright red box.

### Cards & Lists
*   **Rule:** Forbid the use of divider lines. 
*   **Separation:** Use `1.5rem` to `2rem` of vertical white space (from the Spacing Scale) or shift the `surface_container` tier to distinguish list items.
*   **Hover:** List items should shift to `surface_bright` on hover with a `md` (0.375rem) corner radius.

### Chips
*   **Selection:** `primary_container` background with `on_primary_container` text.
*   **Filter:** `surface_container_highest` background. No border.

### Command Palette (Special Component)
As an ERP, navigation is key. Implement a "Glass" command palette using `surface` at 70% opacity, `backdrop-blur: 30px`, and a `primary` ghost-border. This is the heart of the "Intelligence Engine."

---

## 6. Do's and Don'ts

### Do
*   **Do** use extreme white space. Let the data breathe.
*   **Do** use `secondary_text` (#B0BEC5) for all non-essential information to keep the focus on the primary data points.
*   **Do** lean into the "Intelligence" philosophy by using `primary` (#D7BAFF) for highlights—it should feel like the system is highlighting insights for the user.

### Don't
*   **Don't** use pure white (#FFFFFF). It will break the high-contrast dark aesthetic. Use `on_surface` (#E5E2E1) for the highest brightness.
*   **Don't** use standard 1px gray dividers. They are the enemy of premium UI.
*   **Don't** use "default" rounded corners. Stick strictly to the `md` (0.375rem) and `xl` (0.75rem) scale to maintain a professional, slightly sharp edge.