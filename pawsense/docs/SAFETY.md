# PawSense Safety

The safety copy in the app (intro flow + Settings > Safety guidance) mirrors
this document. British English, no diagnosis language, no fear-mongering.

## Cat safety

- Supervise the cat during play; PawSense is designed for shared sessions,
  not unattended screen time.
- Sessions are short: options 1/2/3/5 minutes, hard cap 5 minutes,
  automatic gentle ends on disengagement (30 s idle) and repeated
  frustration (two consecutive high-frustration trials).
- Stop if the cat appears uncomfortable, overly aroused, or frustrated.
- Finish with a physical toy the cat can actually catch and hold — it
  completes the predatory sequence that a glass screen cannot.
- Treat rewards are optional and should fit within the cat's normal daily
  diet. PawSense never recommends food amounts or types.
- Cats that react aggressively to screens should not use the app
  unsupervised.
- PawSense is enrichment, not veterinary or medical advice; frustration
  signals are play-tuning heuristics, never welfare diagnoses, and the copy
  never says "your cat is distressed".

## Device safety

- Use a stable tablet stand or lay the device flat on a non-slip surface.
- Consider a tempered-glass screen protector.
- The owner-exit design (two-corner 2 s hold + owner gate with
  press-and-hold or PIN) prevents casual paw exits, but only OS features
  can truly pin the app:
  - **iPad/iPhone Guided Access**: Settings > Accessibility > Guided
    Access; triple-click to start/stop with a passcode.
  - **Android screen pinning**: Settings > Security > App pinning; pin from
    the recents view.
  PawSense documents both and never claims to lock the operating system
  itself.

## Sensory design rules (enforced in code review)

- No flashing or strobing effects; prey animation is continuous and smooth.
- No sudden loud audio: every built-in sound is synthesised quiet with soft
  attack (`tool/generate_placeholder_audio.dart`); sound never plays for
  cats marked easily startled unless the owner changes the profile.
- Dark, calm play background; high-contrast prey (extra-contrast palettes
  for reduced-vision cats).
- No endless autoplay: every session has a planned end and an "All done"
  ritual.
- No streaks, no guilt copy, no engagement-time optimisation anywhere in
  the product. The optimisation target is successful, calm, short
  engagement.

## Session recommendations (owner-facing)

Once or twice a day at most, ideally before a meal (hunt-then-eat), ending
with a physical toy. If a session ends with the "made the session easier"
note repeatedly, try shorter sessions, slower speeds via manual mode, or
more real-world play instead.
