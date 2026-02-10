# 🚀 Crewmeister Coding Challenge – Absence Manager (Flutter)

This project is my solution for the **Crewmeister Frontend Coding Challenge**.  
It implements the **Absence Manager** feature, allowing company owners to manage employee absences such as vacations and sickness.

The application is built with **Flutter**, follows **Clean Architecture principles**, uses **BLoC** for state management, and includes **unit tests** for core business logic.

---

## Screenshots
![absence_manager](https://github.com/user-attachments/assets/ac232122-02db-4921-956c-5faa8b1dbe02)



## ▶️ How to Run the Project

### Prerequisites
- Flutter SDK (stable channel)
- Dart SDK

### Installation

```bash
git clone https://github.com/mokaily/crewmeister_frontend_coding_challenge
cd crewmeister_absence_manager
flutter pub get
# want to run test files, first build mocked files
flutter pub run build_runner build
```

## ✨ Features

### Core Requirements
- Display a list of absences including employee names
- Pagination (first 10 absences with the ability to load more)
- Display total number of absences
- Absence details:
  - Member name
  - Type of absence
  - Period
  - Member note (if available)
  - Status (`Requested`, `Confirmed`, `Rejected`)
  - Admitter note (if available)
- Filter absences by:
  - Absence type
  - Date range
- Loading state while data is fetched
- Error state when data is unavailable
- Empty state when no results are found

### Bonus & Enhancements
- 🔍 Search absences by **member name**
- 📅 Date range filtering
- 📄 iCal file generation (importable into Outlook)
- 🌍 Responsive UI supporting **Web and Mobile**
- ✅ Unit tests for business logic
- 🧼 Clean Architecture with clear separation of concerns

---

## 🧱 Architecture

The project follows **Clean Architecture**, structured into:

- **Presentation**
  - UI widgets
  - BLoC / Cubits
  - UI states (loading, success, empty, error)
- **Domain**
  - Entities
  - Use cases
  - Repository contracts
- **Data**
  - Data sources (mock JSON)
  - Repository implementations
  - Models and mappers

This ensures:
- Testability
- Scalability
- Clear separation of responsibilities

---

## 🔄 State Management

- **BLoC (flutter_bloc)** is used for predictable state management
- Explicit states:
  - Loading
  - Success
  - Empty
  - Error
- UI reacts deterministically to state changes

---

## 🧪 Testing

- Unit tests written using the **flutter_test** library
- Focus on:
  - Use cases
  - Repositories
  - Models (JSON Manipulation)
  - DataSources
  - BLoC logic
  - State transitions
- Mocked data sources ensure isolated and deterministic tests

---

## 🌐 Platform Support

- ✅ Web (Android/IOS)
- ✅ Mobile (responsive layout)
- Adaptive UI based on screen size
