# Learning Log

> Project-specific corrections and lessons.
> Add only lessons from this project.
> For a reusable personal working rule, propose the smallest shared-skill change and obtain explicit user approval before editing startup_repo `.agent/skills/`.

| Date | Area | Lesson |
|------|------|--------|
| 2026-10-21 | Numeric typography | Keep complete typography in `ThemeData.textTheme`. AppText is only a short access layer: each numeric alias returns the matching configured slot unchanged, and same-size role collisions use readable suffixes. Never derive every alias from one base style. |
| 2026-10-24 | Flutter skill wording | Aligned six approved wording fixes and their examples in the canonical Flutter skill, including the affected spacing eval. Existing coding preferences were preserved. |

| 2026-10-26 | Starter workflow cleanup | User removed the automatic checker and its linked hooks/review-record machinery. Direct task-sized verification and ordinary review remain; shared skills unchanged. |

| 2026-10-27 | Approved input/widget ownership wording | User approved UI ownership of all user-input validation before controller calls, including user-selected file limits; feature widgets own controller reads, UI handlers/navigation and local UI state. Applied approved route-model, primitive/extraction, shimmer exception, reference-routing, verification and approval wording; other preferences preserved. |

| 2026-10-27 | AGENTS core summaries | User requires the existing feature-widget ownership, architecture responsibilities and design-system preferences directly in AGENTS.md as mandatory core summaries; detailed references and their exceptions remain authoritative and unchanged. |
