# PawSense Event Schema

Exact definitions of every behavioural event, raw versus derived fields, and
the data-quality caveats owners and future analyses must respect. Table
layouts live in [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md).

## Timeline anchors

In-session times run on a monotonic session clock (ms since session start),
accumulated from frame deltas — immune to wall-clock jumps. At persistence
they are anchored to the session's `startedAtUtc` instant, giving UTC
timestamps with millisecond precision.

## Raw events

### Target impression (trial start)

A prey target becomes visible (`spawnedAtUtc`) and then touchable
(`becameTouchableAtUtc` = spawn + 250 ms, the spawn-in animation end). One
`TargetTrials` row per impression, carrying the full six-factor
configuration, the spawn point (normalised), and `targetPathSeed` — the
exact movement path can be replayed from the seed.

### Touch (pointer-down)

Only pointer-down derived events are stored — never pointer moves (V1 spec).
Each raw pointer-down becomes one `TouchEvents` row with:

- `pointerId` — platform pointer id
- `logicalInteractionId` — cluster id: contacts within 180 ms AND within
  0.04 x shortest-dimension of the cluster anchor share one id (a paw
  landing is several contacts but one interaction)
- `deduplicated` — true for every contact after the first in its cluster
- normalised x/y (fractions of screen width/height)
- `distanceFromTarget` — from the active target centre, in
  shortest-dimension units; null with no target
- `classification`, first match wins:

| Classification | Definition |
|----------------|------------|
| hit | new logical interaction inside the active target's inflated hitbox, at or after becameTouchable |
| ignoredDuplicate | merged into a recent logical interaction |
| ownerGesture | inside a top-corner exit zone (18% x 18% of each dimension); excluded from every cat metric |
| postCapture | between a capture and the next spawn |
| edge | within the outer 8% margin of the screen |
| miss | anything else |

`hit` outranks `ownerGesture` so prey roaming near a corner still counts.

## Derived per-trial fields

- **Catch** (`success`) — the first valid hit on the trial's target; the
  target deactivates synchronously, so one paw interaction can never yield
  two catches.
- **Reaction time** (`reactionTimeMs`) — first catch minus
  `becameTouchableAtUtc`. Null for uncaught trials.
- **Miss count** (`missCount`) — deduplicated misses while the trial ran.
- **Timeout** (`timeout`) — no catch within 12 s of becoming touchable.
- **Frustration** (`frustrationSeverity` 0-3 + `frustrationFlags`) — the
  detector's per-trial collection (see PERSONALISATION.md section G). A
  heuristic for making play easier; never a welfare diagnosis.
- **Cue fields** — `cueType` (the cue that preceded the spawn, touch
  training only), `praiseCueType` (which praise recording played on catch).
- **trialReward** — the documented transparent reward.
- **Learning-valid** (derived, not stored): `success OR timeout`. Trials
  cut short (session ended, disengagement retirement) stay in raw history
  but never update preference stats, difficulty, or cue progress.

## Session-level derived fields

Written transactionally at finalisation: `catches`, `misses` (sum of trial
missCounts), `timeouts`, `medianReactionMs` (median over successful
learning-valid trials — median, not mean, by design), `frustrationCount`
(learning-valid trials with severity >= 1), `actualDurationMs`, terminal
`status`:

| Status | Meaning |
|--------|---------|
| completed | planned duration reached (or schedule exhausted) |
| ownerStopped | exit gesture + owner gate |
| disengaged | 30 s without meaningful interaction |
| frustrated | two consecutive high-frustration trials |
| backgrounded | app left the foreground |
| interrupted | crash-recovered on a later launch |

`ownerSubjectiveFeedback` (engaged/neutral/frustrated) is the owner's
impression, stored on the session but deliberately separate from observed
data — insights must never blend the two.

## Other behavioural definitions

- **Disengagement** — no meaningful interaction (hit/miss/edge/postCapture)
  for 12 s -> attention nudge; 20 s -> easy relief target; 30 s -> session
  ends as disengaged.
- **Cue success** — a catch within the cued trial's window; the basis of
  `CueProgress.successfulResponses`.

## Persistence timing

Touches and the current trial buffer in memory (bounded at 512 events) and
flush at trial boundaries on a chained write queue — never inside the frame
loop. Finalisation is one transaction: session aggregates + preference
stats + cue progress + profile difficulty.

## Crash recovery

Sessions are inserted as `inProgress` before play. On every app launch,
stale `inProgress` rows are finalised as `interrupted`: aggregates are
recomputed from whatever trials were persisted, `endedAtUtc` is the last
persisted trial end. Preference models are NOT updated from recovered
sessions (the in-session learning state died with the process; raw history
remains for future analyses).

## Data-quality caveats

1. Touch data cannot distinguish which cat touched — hence Mixed Session
   (catId null) exists and never trains any individual model.
2. `ownerGesture` classification is positional; an owner touching mid-screen
   during play counts as cat interaction. Supervised short sessions keep
   this rare.
3. Reaction times include the cat's decision to engage at all; they are
   engagement latencies, not neurological reaction times.
4. Trials during the disengagement ladder are biased easy by design;
   per-configuration comparisons should prefer learning-valid trials at
   comparable difficulty.
5. Recovered (`interrupted`) sessions may undercount touches from their
   final in-flight trial (only persisted batches survive a crash).
