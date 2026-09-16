# Changelog

All notable changes to PawSense. Dates are UTC.

## 0.2.0 beta - 2026-09-16

- Reworked mouse, moth and fish anatomy and motion with deterministic Canvas
  animation, no flashing, and visible bodies contained within the catch area.
- Count moving paws and clustered pad catches without premature miss penalties;
  preserve one catch per target and prevent held paws catching later targets.
- Wait for recorded greetings and praise, enforce silent mode, and cap voice
  recordings at five seconds with background/navigation cleanup.
- Keep active tablet play awake, pause behind the owner gate, block accidental
  system Back, and save interrupted sessions on background, exit or resize.
- Explain the recorded cue → hunt → catch → praise loop before training.
- Improve owner-screen contrast, responsive actions and reduced-motion support.
- Start version-scoped v1.1 evidence, make session finalisation idempotent and
  require eight valid calibration trials before marking calibration complete.
- Add native Android hunt/voice/persistence integration checks, downloadable
  Android beta artifacts, and an unsigned native iOS build in CI.

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
