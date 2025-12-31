# Flutter Clean Architecture Marketplace Boilerplate

A production-ready Flutter marketplace application boilerplate following Clean Architecture principles with BLoC state management.

## Architecture

Presentation Layer (UI) -> Domain Layer (Business Logic) -> Data Layer (Data Sources)

text

### Key Features
- Clean Architecture with clear separation of concerns
- BLoC state management with Cubit for simpler states
- Dependency Injection using GetIt & Injectable
- Secure API communication with Dio
- Multi-language support ready
- RTL support included
- Reusable widgets and components

## Getting Started

1. Clone this repository
2. Run `flutter pub get`
3. Run `flutter packages pub run build_runner build`
4. Run `flutter run`

## Project Structure

- `lib/core/` - Shared utilities, constants, errors, and widgets
- `lib/features/` - Feature-based modules (auth, products, settings)
- `lib/injection_container.dart` - Dependency injection setup
