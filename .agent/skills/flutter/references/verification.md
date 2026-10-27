# Verification

- Remove stale TODOs, dead commented code and abandoned branches in active production flows before sign-off. Use working behavior or an explicit safe fallback.
- Format changed Dart files with the page width configured in analysis_options.yaml. Analyze coherent changes together and fix errors to zero.
- Run relevant tests/builds using BRAIN's task/risk-sized workflow. Retain needed validation for bug fixes, security-sensitive/destructive work and user-requested proof.

## Performance
- Before implementation, trace large-data lifetime across async/isolate boundaries. Avoid repeated materialization/copies; keep CPU-heavy work off the UI isolate.
- Profile the real flow on a representative device before release.

## Exact-path delivery
- Verify changed runtime flows through the exact release artifact and requested path. Do not require release installation for non-runtime changes.
- Exercise every user-named action through its destination screen and required API response.
- A launch or nearby-screen smoke test is not a substitute.
