/// Identifier stored with every session, trial, and preference row.
///
/// Bump whenever any personalisation formula, threshold, weight, or prior
/// changes, and document the change in docs/PERSONALISATION.md. Rows written
/// under different versions are never merged (the PreferenceStats unique key
/// includes the version).
const String algorithmVersion = 'pawsense-personalisation-v1';
