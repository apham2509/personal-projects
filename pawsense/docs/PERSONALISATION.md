# PawSense Personalisation — pawsense-personalisation-v1

The complete specification of how PawSense adapts to a cat. Everything here
is implemented in pure Dart under `lib/features/personalisation/domain/` and
`lib/features/calibration/domain/`, and verified by the unit + simulation
suites in `test/unit/personalisation/`.

Design stance: a transparent, interpretable, factor-level scoring system
with an upper-confidence exploration bonus — not a neural network, not deep
reinforcement learning, and never marketed as either. Every number below is
a named constant in code.

## Versioning

Current version: `pawsense-personalisation-v1`
(`lib/features/personalisation/domain/algorithm_version.dart`).

Every session, trial, and preference row stores this string. Any change to a
formula, weight, threshold, prior, or decay in this document requires:
1. bumping the version,
2. documenting the change here,
3. noting that `PreferenceStats` rows are version-scoped (the unique key
   includes the version), so a new version starts learning fresh while old
   rows remain for audit.

## A. Initial priors from the questionnaire

Owner answers create *weak* starting points (`seedsFromAnswers`):

| Answer | Prior |
|--------|-------|
| Favourite prey mouse or ball | targetType=mouse seeded 4 impressions / 3 successes |
| Favourite prey moth-bug or feather | targetType=moth seeded 4/3 |
| Favourite prey fish | targetType=fish seeded 4/3 |
| Favourite prey other/unknown | no seed |
| Energy high | speedLevel=medium seeded 4/3 |
| Energy low | speedLevel=slow seeded 4/3 |
| Enjoys sound | soundMode=sound seeded 4/3 |

Also derived at profile creation (`initialDifficultyFor`): starting
difficulty from screen experience (none 1, some 2, frequent 3), capped at 2
for kittens, seniors, or any mobility consideration.

Hard safety constraints (not priors — never violated,
`SafetyConstraints.fromAnswers`):

- easily startled -> sound never enabled by default (all trials silent)
- reduced vision -> minimum size large + high-contrast palette
- limited movement -> maximum speed slow + centre-only spawn zones
- senior-friendly -> maximum speed medium

Priors are weak by construction: 4 pseudo-impressions against decayed real
counts. The simulation suite proves ~150 contradicting trials decisively
flip a prior (test: "owner priors are overpowered by contradicting
evidence").

## B. Factor-level learning

Learning full configurations would be hopelessly sparse
(3 x 3 x 3 x 3 x 2 x 5 = 810 cells). PawSense instead tracks statistics per
factor *value* across six independent dimensions: targetType,
movementStyle, speedLevel, sizeLevel, soundMode, spawnZone.

Per factor value (`FactorStats`): impressions, successes, timeouts,
totalMisses, frustrationCount (all real-valued, see decay), reaction-time
EWMA over successful trials, cumulative reward.

Scores (`PreferenceScorer`), computed on the working stats:

```
smoothedCatchRate = (successes + 2) / (impressions + 4)        # Beta(2,2), prior mean 0.5
reactionScore     = 0.5                       if successes < 3
                  = clamp01(1 - (ewmaMs - 500) / (8000 - 500)) otherwise
calmScore         = clamp01(1 - (frustrationCount + 1) / (impressions + 4))
timeoutScore      = clamp01(1 - (timeouts + 1) / (impressions + 4))

utility = 0.50*smoothedCatchRate + 0.25*reactionScore
        + 0.15*calmScore        + 0.10*timeoutScore

confidence = min(impressions / 20, 1.0)
```

## C. Trial reward

Transparent per-trial reward (`TrialRewardCalculator`), stored on every
trial row and accumulated per factor:

```
catchComponent     = 1.0 if caught else 0
reactionBonus      = caught ? 0.25 * (1 - clamp01((rt - 500)/(8000 - 500))) : 0
missPenalty        = -0.12 * min(missCount, 3)
frustrationPenalty = -0.20 * severity          # severity 0-3
timeoutPenalty     = -0.25 if timed out

trialReward = clamp(sum, -1.0, +1.25)
```

## D. Configuration score and exploration

Factor weights (`factorWeights`, sum 1.0): targetType 0.30, movementStyle
0.25, speedLevel 0.20, sizeLevel 0.15, soundMode 0.10. Spawn zone is not
scored; it is varied via candidate enumeration and safety/adaptation rules.

Per candidate configuration:

```
explorationBonus(value) = 0.15 * sqrt( ln(totalFactorTrials + 1)
                                     / (valueImpressions + 1) )
configurationScore = sum over factors of
    weight_f * ( utility(value_f) + explorationBonus(value_f) )
```

`totalFactorTrials` is the impression total across that factor's values.
The coefficient 0.15 is `SelectionConfig.explorationCoefficient`.

## E. Selection policy

`ConfigurationSelector.select`, seeded RNG throughout:

1. Enumerate candidates: difficulty band (section F) intersected with hard
   safety constraints (safety wins if the intersection would be empty),
   sound values gated by session setting AND safety, zones restricted to
   centre for mobility-limited cats.
2. Remove the exact previous configuration; remove any prey that has
   already appeared 3 times consecutively.
3. With probability 0.8 (**exploit**): score all candidates and pick
   uniformly among those within 0.03 of the best score.
   With probability 0.2 (**explore**): pick uniformly among the candidates
   with the lowest summed factor impressions.

Additional live adaptations owned by the session controller:
- active edge-burst frustration pulls the next spawn zone to centre;
- disengagement stage 2 and any trial with severity >= 2 force the next
  trial to the "easy relief" configuration (largest safe size, slow,
  smooth, centre, silent, currently-best prey).

## F. Difficulty controller

Range 0-10, per cat, persisted on the profile and updated at session end.

Bands (`DifficultyBands`) — intersected with safety, which always wins:

| Difficulty | Sizes | Speeds | Movements |
|-----------:|-------|--------|-----------|
| 0-2 | large | slow | smooth |
| 3-4 | large, medium | slow, medium | smooth, stop-and-go |
| 5-6 | medium, large | medium, slow | all |
| 7-8 | medium, small | medium, fast | all |
| 9-10 | small, medium | fast, medium | all |

Decisions use a rolling window of the last 5 learning-valid trials:

- **+1** only when: >= 4 catches in the window AND median reaction
  <= 2000 ms AND no severity-3 trial AND severity sum <= 1 AND >= 3 trials
  since the last change (cooldown; window also clears on change).
- **-1** when: <= 2 catches, OR >= 2 timeouts, OR severity sum >= 3.
- **Immediate safety reduction** (bypasses cooldown): any severity-3 trial
  -> -1; a second consecutive high-frustration trial -> -2.
- Clamped to [0, 10]; only trials that ended by catch or full timeout count
  ("learning-valid" — trials cut short by session end are raw history
  only).

## G. Frustration and disengagement

`FrustrationDetector` (sliding windows, ms):

| Flag | Trigger | Weight |
|------|---------|-------:|
| missBurst | 3+ misses in 2 s | 1 |
| edgeBurst | 4+ edge touches in 3 s | 1 |
| postCaptureBurst | 4+ touches in 1.5 s after a capture | 1 |
| rapidTapBurst | 10+ logical touches in 5 s with <= 1 catch | 2 |
| longHold | a pointer held >= 2 s | 1 |
| consecutiveTimeouts | 3 timed-out trials in a row | 2 |
| repeatedImpossibleReach | 4+ misses within 0.06 units of the hitbox edge in 10 s | 2 |

Trial severity = min(3, sum of active flag weights), collected at trial end
(bursts that fired mid-trial count even if their window has passed).

Owner-facing copy never diagnoses ("PawSense detected repeated unsuccessful
interactions and made the session easier." — never "your cat is
distressed").

Disengagement ladder (`DisengagementTracker`, since last meaningful
interaction): 12 s subtle attention nudge -> 20 s easy relief target ->
30 s end session as `disengaged`. Any hit, miss, edge, or post-capture
touch resets it.

## H. Recency and decay

Working counters decay by 0.995 before each increment
(`statsDecayPerUpdate`), giving an effective memory of a few hundred trials
so preferences can drift with the cat. Reaction times use an EWMA with
alpha 0.3. Raw trials/events are never modified; owner-facing sample sizes
come from raw trial counts, not the decayed counters (DECISIONS.md D-005).

## I. Confidence tiers and insight gating

Insight claims are gated by *raw* comparable sample size
(`confidenceTierFor`):

| Samples | Tier |
|--------:|------|
| < 8 | no conclusion shown |
| 8-19 | Early observation |
| 20-49 | Developing pattern |
| >= 50 | Strong pattern |

A "favourite" additionally requires the top value's utility to exceed the
runner-up by >= 0.08 (`favouriteUtilityGap`). Every insight displays its
sample size, tier, and a plain-language sentence.

## J. Calibration

`CalibrationScheduler.generate(seed, constraints)` produces 12 trials with:
prey 4/4/4, movement 4/4/4, slow/medium 6/6, large/medium 6/6, sound/silent
6/6 (when allowed), zones centre-weighted; no exact consecutive repeats; no
prey three-in-a-row; deterministic per (seed, constraints). Safety may
collapse a pool (all-silent, all-large, all-slow/centre) — the waived
balances are recorded and shown to the owner in the calibration summary.

Generation is shuffle-and-check with a forked RNG per attempt;
property-tested across 2000 seeds (constraints have always held within a
handful of attempts).

## K. Cue training semantics

"Cue success" = a catch within the trial window after the cue played.
Dashboard wording sticks to observables: "Reaction time after the Touch
cue", "Catch rate in cued trials". A cued-versus-silent comparison is only
ever descriptive and labelled informal (single household, no controls).
PawSense never claims a cat understands words.

## L. Pseudocode of one adaptive trial

```
config  = selector.select(snapshot, constraints, difficulty, rng, history)
spawn target; becameTouchable = spawn + 250 ms
outcome = catch (first valid paw hit) | timeout (12 s)
severity, flags = frustration.collectTrialFlags()
reward  = trialReward(outcome, reaction, misses, severity)
if learning-valid (catch or full timeout):
    difficulty.onTrialCompleted(outcome)
    for each of the 6 factors:
        stats[value] = decay(stats[value]) + evidence(outcome)
persist trial + touches (batch, off the frame loop)
```

## M. Known limitations (v1)

- Factor independence is an approximation: interaction effects (e.g. "loves
  fast moths but only slow mice") surface only indirectly through rewards.
  A contextual-bandit upgrade is a documented V3 candidate.
- Spawn-zone learning is exploration-count based, not utility based.
- The decayed counters make "confidence" slightly conservative for very
  long histories (by design).
- Cued/silent comparisons are informal; no blinding, one household.
- Simulated convergence (test suite) uses a stationary synthetic cat; real
  cats drift, which is what the decay is for.
