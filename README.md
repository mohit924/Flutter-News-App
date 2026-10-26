# PulseNews - Flutter News & Intelligence Application

A production-grade Flutter application engineered with **Clean Architecture**, **Riverpod** state management, **Dio** HTTP client, and **Hive** local persistence. Designed for seamless news browsing, category filtering, debounced search, offline bookmarking, and local authentication with resilient error recovery.

---

## 📱 Key Features & Capabilities

- **Clean Architecture & Separation of Concerns**: Multi-layered structure cleanly decoupling UI, business logic, domain repositories, and data sources.
- **Dynamic News Feed**: Category-filtered top headlines (Business, Technology, Sports, Health, Science) with pull-to-refresh and infinite scroll pagination.
- **Debounced Real-time Search**: Search queries against NewsAPI with client-side debouncing (500ms) to conserve API quotas and network bandwidth.
- **Detailed Article View**: Immersive reading experience with rich metadata breakdown and article navigation.
- **Offline Bookmarking (Hive)**: Save and unsave articles with persistent local storage surviving app restarts.
- **Robust Error & Recovery State**: Graceful exception interception for network timeouts, server outages, and rate limits, coupled with interactive retry UI.
- **Local Authentication Guard**: Client-side session management with persistent login state, GoRouter redirect guards, and isolated form validation.
- **Modern Responsive Design**: Fluid typography, responsive slivers, gradient themes, and adaptive tactile feedback.

---

## 🏛 Architecture Overview

PulseNews follows modern Flutter **Clean Architecture** principles with unidirectional data flow:

```
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│   (Screens, Custom Widgets, Adaptive Slivers, Dialogs)  │
└───────────────────────────▲────────────────────────────┘
                            │ Watches State / Emits Events
┌───────────────────────────▼────────────────────────────┐
│                    State Management                    │
│   (Riverpod Notifiers, State Observers, Providers)     │
└───────────────────────────▲────────────────────────────┘
                            │ Calls Contracts
┌───────────────────────────▼────────────────────────────┐
│                    Repository Layer                    │
│    (Abstract Repository Interfaces & Implementations)  │
└───────────────────────────▲────────────────────────────┘
                            │ Fetches & Stores
              ┌─────────────┴─────────────┐
              ▼                           ▼
┌───────────────────────────┐ ┌───────────────────────────┐
│     Remote Data Source    │ │     Local Data Source     │
│   (Dio Client / NewsAPI)  │ │   (Hive Encrypted Boxes)  │
└───────────────────────────┘ └───────────────────────────┘
```

---

## 📂 Project Directory Structure

```text
lib/
├── main.dart                          # App bootstrapping, Hive initialization & router entry
│
├── constants/
│   ├── app_assets.dart                # Local asset path constants
│   ├── app_colors.dart                # Design tokens & color palette
│   ├── app_sizes.dart                 # Spacing, padding, and border radius tokens
│   ├── app_strings.dart               # Localized copy & UI strings
│   └── app_text_styles.dart           # Typography styles
│
├── features/
│   ├── core/
│   │   └── local/
│   │       ├── auth_local_storage.dart# Hive persistence for user credentials & session
│   │       └── favorites_storage.dart # Hive persistence for saved articles
│   ├── model/
│   │   └── article_model.dart         # Article data model (fromJson / toJson)
│   ├── providers/
│   │   ├── auth_provider.dart         # Authentication state notifier & session coordinator
│   │   ├── fav_provider.dart          # Bookmarks state notifier
│   │   └── news_provider.dart         # News feed state, pagination & error coordinator
│   ├── repository/
│   │   ├── news_repository.dart       # Abstract repository interface (contract)
│   │   └── news_repository_impl.dart  # Concrete implementation using Dio
│   ├── routes/
│   │   └── app_router.dart            # GoRouter configuration & auth redirect guard
│   └── screens/
│       ├── splash/                    # Animated branding & launch routing
│       ├── login_page.dart            # Credential sign-in screen
│       ├── register_page.dart         # Account registration screen
│       ├── forgot_password_page.dart  # In-app password recovery screen
│       └── post_login/
│           ├── main_shell_page.dart   # Bottom navigation shell
│           ├── home_page.dart         # Feed, category tabs, sliver app bar, error states
│           ├── search_page.dart       # Debounced search & trending topics
│           ├── favourite_page.dart    # Offline saved bookmarks screen
│           ├── article_details_page.dart # Full article view
│           └── news_card.dart         # Reusable feed item card widget
│
├── network/
│   ├── api_endpoints.dart             # API route constants and configurations
│   └── dio_client.dart                # Configured Dio instance with timeouts & interceptors
│
├── utils/
│   ├── extensions.dart                # String & DateTime helper extensions
│   └── validators.dart                # Form validation logic (Email, Password, Confirm)
│
└── widgets/
    ├── app_button.dart                # Gradient button with loading indicator
    ├── app_loader.dart                # Progress indicators & overlay loaders
    └── app_textfield.dart             # Form field with labels, icons & visibility toggle
```

---

## 🛠 Tech Stack & Dependencies

| Dependency | Purpose | Rationale |
|---|---|---|
| `flutter_riverpod` | State Management | Predictable unidirectional state management with zero coupling to the widget tree. |
| `go_router` | Declarative Routing | URL-driven navigation supporting `ShellRoute` tabs and top-level authentication redirect guards. |
| `dio` | Networking | Robust HTTP client featuring connection timeouts, payload parsing, and extensible error handling. |
| `hive` / `hive_flutter` | Local Storage | Lightweight, lightning-fast NoSQL key-value store with zero native dependencies for offline persistence. |
| `flutter_test` | Testing Suite | Comprehensive unit and widget testing capabilities. |

---

## 🛡 Robust Error Handling & Resilience

1. **Network & Server Fault Tolerance**:
   - `DioException` types (`connectionTimeout`, `receiveTimeout`, `connectionError`) are caught and mapped to user-friendly status representations.
   - API error responses (e.g. rate limits or missing parameters) are parsed gracefully rather than throwing unhandled exceptions.

2. **Dedicated Retry & Offline Recovery**:
   - In the event of a failure, the UI renders a customized failure display with a 1-tap **"Try Again"** button.
   - Category feeds and search queries automatically clear previous errors upon re-invoking.

3. **Isolated Form Validation**:
   - Authentication screens manage dedicated state resets, ensuring errors on Login do not bleed into Registration or Password Recovery screens.

---

## 🧪 Automated Testing

PulseNews includes unit test coverage for core business logic, models, and validators:

- **Validators Test Suite**: Validates email formats, password minimums, and confirmation parity.
- **Article Serialization**: Verifies `fromJson` parsing and `toJson` serialization integrity.
- **NewsState Verification**: Ensures initial state invariants and immutable `copyWith` state transformations.

To run the test suite:
```bash
flutter test
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.19 or higher)
- Android Studio / Xcode / VS Code
- Git

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mohit924/News-Application.git
   cd News-Application
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run on a device or emulator:**
   ```bash
   flutter run
   ```

---

## 📄 License
This project is open-source and available under the [MIT License](LICENSE).
