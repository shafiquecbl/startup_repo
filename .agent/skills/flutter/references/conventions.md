# Conventions

## Imports
- Shared core exports → package:<pubspec_name>/imports.dart; no individual core-file imports.
- Feature-local models/repositories/widgets use relative imports. Cross-feature imports use absolute package paths to the owning feature.
- Read the actual package name from pubspec.yaml; never assume startup_repo.

## Style and resources
- App configuration uses direct code constants/getters; do not read it through dotenv.
- User-facing strings use .tr; no raw visible English in widgets.
- Use const wherever possible: constructors, widgets, lists and values.
- Put each private backing field immediately above its public getter:
  FeatureData? _data;
  FeatureData? get data => _data;
- Dispose owned controllers, focus nodes, notifiers, streams/subscriptions and timers.

Navigation, constructor route data and explicit types → [AGENTS.md](../../../../AGENTS.md).
Dependency registration → [Architecture](architecture.md).
