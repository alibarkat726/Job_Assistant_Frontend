# Job Assistant AI — Flutter Frontend

Production-grade, scalable Flutter application for the Job Assistant AI platform built with Riverpod, Clean Architecture, and Dio.

---

## 🎨 Finalized Design System & Theme Architecture

The app uses a strict, unified design token palette, encapsulated typography system, and semantic color extension.

### 1. Design Tokens Table

| Token | Light Mode | Dark Mode | Usage |
| :--- | :--- | :--- | :--- |
| **Background / Scaffold** | `#EAF2FB` | `#1C1F26` | App background |
| **Card / Surface** | `#FFFFFF` | `#20242C` | Cards, containers, modals |
| **Input Surface** | `#FFFFFF` | `#22262E` | Input field backgrounds |
| **Default Border** | `#D6E3EF` | `#2E323C` | Card & container borders |
| **Input Border** | `#C7D8E8` | `#2E323C` | Form field outline borders |
| **Text Primary** | `#1B2430` | `#FFFFFF` | Main headings & body text |
| **Text Secondary** | `#5C6B7A` | `#8E94A0` | Captions, hints, subtitles |
| **Brand Accent (Teal)** | `#14B8A6` | `#14B8A6` | Primary action buttons & active navigation |
| **Accent Hover / Pressed** | `#0D9488` | `#0D9488` | Pressed states |
| **On-Accent Text** | `#FFFFFF` | `#0E1116` | Text rendered on primary buttons |

---

### 2. 🟢 Semantic Skill-Match Colors (`AppSemanticColors`)

Access semantic states across features (e.g. JD matching, analytics) via `Theme.of(context).extension<AppSemanticColors>()!`:

| State | Light Mode (Bg / Text) | Dark Mode (Bg / Text) | Purpose |
| :--- | :--- | :--- | :--- |
| **Matched / Success** | `#E3F7F3` / `#0D9488` | `#0E2E2A` / `#2DD4BF` | Full skill match / positive state |
| **Partial / Attention** | `#FDEEDA` / `#B4740E` | `#2E2818` / `#F2A93B` | Partial match / warning state |
| **Missing / Error** | `#FCE8E8` / `#B91C1C` | `#2E1A1A` / `#F87171` | Missing skill / error feedback |

#### Usage Example:
```dart
final semanticColors = Theme.of(context).extension<AppSemanticColors>()!;

Chip(
  backgroundColor: semanticColors.matchedBg,
  label: Text(
    'Matched Skill',
    style: TextStyle(color: semanticColors.matchedText),
  ),
);
```

---

### 3. ✍️ Typography (`AppTypography`)

- **Headings & Titles**: `Plus Jakarta Sans` (FontWeight 500 for headers, 600 for primary titles & buttons).
- **Body & UI Text**: `Inter` (FontWeight 400 regular, 500 for emphasis).
- **Rule**: All text styles are exposed through `Theme.of(context).textTheme`. No `GoogleFonts.xxx()` calls are permitted outside `lib/core/theme/app_typography.dart`.

---

### 4. 🔣 Iconography

- All icons use the **Tabler Icon Set** (`flutter_tabler_icons`).
- Icon colors inherit dynamically from `Theme.of(context)` token properties (`onSurface`, `primary`, or `textTheme.bodyMedium?.color`). No literal hex values are hardcoded in widget trees.

---

## 🔒 Auth Feature Module Architecture

```
lib/features/auth/
├── data/
│   ├── models/          # Raw API shapes, Freezed & json_serializable DTOs
│   ├── services/        # Raw Dio HTTP calls returning DTOs
│   └── repositories/    # Maps DTOs -> Domain User, exceptions -> Failure objects
├── domain/
│   ├── entities/        # Pure domain models (User)
│   └── repositories/    # Abstract repository contract
└── presentation/
    ├── controllers/     # Riverpod Notifier managing AuthState
    ├── providers/       # Riverpod provider definitions & dependency wiring
    ├── screens/         # UI screens (Login, Register, Verify Email, Forgot Password)
    └── widgets/         # Reusable auth components (AuthTextField, PasswordTextField, AuthButton)
```

---

## 🧪 Testing

Run all unit and widget tests with:
```bash
flutter test
```
