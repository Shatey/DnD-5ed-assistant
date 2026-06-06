# DnD 5e Assistant

A Flutter companion app for Dungeon Masters who want a faster way to run Dungeons & Dragons 5e combat scenes.

The app currently focuses on initiative tracking: adding players and monsters, sorting turns, tracking rounds, hit points, armor class, and temporary statuses. Data is stored locally with SQLite so the combat scene can survive app restarts.

## Features

- Combat initiative tracker for players and monsters.
- Automatic turn ordering by initiative and action state.
- Round progression when every participant has acted.
- Temporary status duration handling.
- Local SQLite persistence through `sqflite`.
- Riverpod-based state management.
- Material 3 light and dark themes.
- Additional foundations for bestiary, spells, and status reference screens.

## Tech stack

- Flutter / Dart
- Riverpod
- sqflite
- Material 3
- flutter_lints
- flutter_test

## Project structure

```text
lib/
  models/       Data models for initiative, bestiary, and spells.
  screens/      Top-level application screens.
  services/     Persistence and combat-domain services.
  utils/        Small validation and formatting helpers.
  widgets/      Reusable UI components.
test/           Unit and widget tests.
assets/         App icons and visual assets.
```

## Getting started

Install Flutter, then run:

```bash
flutter pub get
flutter run
```

Run static analysis and tests:

```bash
flutter analyze
flutter test
```

## Current focus

This repository is a work-in-progress pet project. The current refactor focuses on making the app easier to maintain and more useful as a portfolio project:

- clearer README and metadata;
- better separation between UI, turn logic, and persistence;
- more DartDoc comments around important classes and methods;
- tests for initiative ordering and round progression;
- cleaner, more consistent UI.

## Roadmap

- Add edit flows for all initiative fields.
- Improve bestiary and spells browsing.
- Add import/export for encounters.
- Add encounter templates.
- Add more unit and widget tests.
- Prepare Android and iOS release builds.

## License and content note

This project is intended as a personal assistant for DnD 5e sessions. Before publishing any bundled game data, verify that all included content is compatible with the relevant Wizards of the Coast / SRD licensing terms.
