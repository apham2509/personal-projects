# Changelog

All notable changes to PawSense. Dates are UTC.

## 0.1.0 (unreleased) - 2026-08-01

First complete V1 build, developed on `feature/pawsense-v1`.

### Added
- Local cat profiles: Netflix-style picker, 7-step onboarding
  questionnaire, archive/restore/reorder, cascading permanent deletion,
  photo via the system picker, Mixed Session mode that never trains
  individual models.
- Cat-safe play engine: three procedural prey (mouse, moth, fish), three
  bounded non-teleporting movement styles, paw-cluster touch pipeline with
  one-catch-per-target guarantee, two-corner owner exit with gate (hold or
  PIN), calm 3-second start, immersive mode with system UI restore.
- Behavioural pipeline: batched trial/touch persistence anchored to the
  session start, transactional finalisation, crash recovery to
  `interrupted`, typed session ends.
- Transparent personalisation (`pawsense-personalisation-v1`): factor
  utilities with documented weights, UCB exploration, 80/20 policy,
  difficulty 0-10 with evidence gates and immediate safety reductions,
  frustration detector (7 flags) and disengagement ladder, weak
  questionnaire priors overpowered by evidence, gentle decay for drift.
- Balanced seeded 12-trial calibration with safety waivers.
- Touch Training with owner-recorded cues (name, Touch, Good, Good job,
  All done), praise variation, jittered cue-to-spawn delay, cue progress
  tracking, optional treat reminders with per-session caps.
- Insights: honest favourites (sample-size + confidence tier + 0.08
  utility-gap gates), catch/reaction/difficulty trends, 12x8 paw heatmap,
  cue stats, completion reasons, day-part pattern (10+ sessions), playful
  personality card.
- Data management: versioned JSON and per-table CSV exports via the share
  sheet (media excluded by design), deletion of any scope with
  what-will-be-removed confirmations.
- Local-first hardening: no-network dependency test + debug HTTP
  tripwire; salted-hash owner PIN; synthesised original audio only.
- Developer screen (debug builds): deterministic demo cats, model reset,
  stats inspection, configuration replay.
- Full ARB localisation (English), reduce-motion and high-contrast
  settings, tablet-first responsive owner UI.
- Documentation: PRD, ARCHITECTURE, DATABASE_SCHEMA, EVENT_SCHEMA,
  PERSONALISATION, SAFETY, PRIVACY, QA_PLAN, RELEASE_GUIDE, STORE_LISTING,
  ROADMAP, legal drafts; CI workflow.
