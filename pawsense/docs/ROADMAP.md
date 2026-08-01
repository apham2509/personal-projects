# PawSense Roadmap

No dates are promised for V2/V3. Items listed there are candidates, not
commitments.

## V1 (this release)

- Local cat profiles with archive/restore/reorder and Mixed Session
- Onboarding questionnaire seeding weak priors
- Balanced seeded 12-trial calibration
- Adaptive Free Play: 3 procedural prey, 3 movement styles, adaptive
  speed/size/sound/spawn under hard safety constraints
- Touch Training with owner-recorded cues and optional balanced cued/silent
  comparison
- Transparent personalisation (factor utilities + UCB, difficulty 0-10,
  frustration/disengagement adaptation), fully documented and simulated
- Insights with confidence tiers, sample sizes, heatmap, trends
- JSON/CSV export, granular deletion, local-first privacy
- Developer simulation screen (debug only)

## V2 (candidates)

- Optional end-to-end-encrypted cloud backup / restore (opt-in, off by
  default; privacy docs updated before any network code lands)
- Family sharing of profiles across household devices
- Richer target packs (additional procedural prey and movement patterns)
- Remote owner control (second device as session remote)
- Improved informal experiments (better balanced cued/silent designs,
  within-cat comparisons)
- Media-inclusive export ("include media" toggle from D-007)
- Finnish and Vietnamese localisations

## V3 (candidates)

- Optional on-device cat presence detection (camera, fully local)
- Collar-colour recognition to suggest which cat is playing in Mixed Session
- Contextual bandit improvements (context features such as time-of-day;
  still interpretable, still versioned)
- Optional smart treat dispenser integrations
- Tablet kiosk mode integrations built on platform screen-pinning APIs

## Explicit non-goals carried forward

Advertising, third-party analytics, social feeds, competitive leaderboards,
veterinary diagnosis, engagement-time optimisation. These stay out.
