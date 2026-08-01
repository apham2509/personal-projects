import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/app_config.dart';
import '../../../core/utils/enum_labels.dart';
import '../../../core/utils/l10n_ext.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/providers/core_providers.dart';
import '../../../shared/widgets/cat_avatar.dart';
import '../domain/cat_profile_draft.dart';

/// Multi-step questionnaire. With [catId] == null it creates a profile (and
/// completes first-launch onboarding); otherwise it edits an existing one.
class ProfileWizardScreen extends ConsumerStatefulWidget {
  const ProfileWizardScreen({super.key, required this.catId});

  final String? catId;

  @override
  ConsumerState<ProfileWizardScreen> createState() => _WizardState();
}

class _WizardState extends ConsumerState<ProfileWizardScreen> {
  static const _stepCount = 7;

  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  CatProfileDraft _draft = const CatProfileDraft();
  int _step = 0;
  bool _nameTouched = false;
  bool _saving = false;
  bool _loadedExisting = false;

  /// Newly picked photo waiting to be copied into the profile directory.
  File? _pickedPhoto;
  bool _removeExistingPhoto = false;

  bool get _isEdit => widget.catId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _loadExisting();
  }

  Future<void> _loadExisting() async {
    final cat = await ref
        .read(catProfileRepositoryProvider)
        .getById(widget.catId!);
    if (cat == null || !mounted) return;
    setState(() {
      _draft = CatProfileDraft(
        name: cat.name,
        photoPath: cat.photoPath,
        ageGroup: cat.ageGroup,
        bodySize: cat.bodySize,
        energyLevel: cat.energyLevel,
        screenExperience: cat.screenExperience,
        favouritePrey: cat.favouritePrey ?? FavouritePrey.unknown,
        soundSensitivity: cat.soundSensitivity,
        treatMotivation: cat.treatMotivation,
        mobilityConsideration: cat.mobilityConsideration,
        visionConsideration: cat.visionConsideration,
        hearingConsideration: cat.hearingConsideration,
        primaryGoal: cat.primaryGoal,
        notes: cat.notes ?? '',
      );
      _nameController.text = cat.name;
      _notesController.text = cat.notes ?? '';
      _loadedExisting = true;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _update(CatProfileDraft next) => setState(() => _draft = next);

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _pickedPhoto = File(picked.path);
      _removeExistingPhoto = false;
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final repo = ref.read(catProfileRepositoryProvider);
    final files = ref.read(fileServiceProvider);
    final clock = ref.read(clockProvider);
    try {
      final String catId;
      if (_isEdit) {
        catId = widget.catId!;
        var draft = _draft;
        if (_removeExistingPhoto && _draft.photoPath != null) {
          await files.deleteRelative(_draft.photoPath!);
          draft = draft.copyWith(photoPath: () => null);
        }
        await repo.update(catId, draft);
      } else {
        final created = await repo.create(
          _draft.copyWith(photoPath: () => null),
        );
        catId = created.id;
      }
      if (_pickedPhoto != null) {
        final rel = await files.savePhoto(
          catId,
          _pickedPhoto!,
          clock.nowUtc().millisecondsSinceEpoch,
        );
        await repo.setPhotoPath(catId, rel);
      }
      if (!_isEdit) {
        await ref
            .read(settingsRepositoryProvider)
            .completeOnboarding(privacyPolicyVersion);
      }
      if (!mounted) return;
      if (_isEdit) {
        context.pop();
      } else {
        context.go('/cats/$catId');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Duration get _pageTurn {
    final reduceMotion =
        ref.read(settingsProvider).value?.reduceMotion ?? false;
    return reduceMotion
        ? const Duration(milliseconds: 1)
        : const Duration(milliseconds: 250);
  }

  void _next() {
    if (_step == 0 && !_draft.isValid) {
      setState(() => _nameTouched = true);
      return;
    }
    if (_step == _stepCount - 1) {
      _save();
      return;
    }
    _pageController.nextPage(duration: _pageTurn, curve: Curves.easeOutCubic);
  }

  void _back() {
    if (_step == 0) {
      context.pop();
      return;
    }
    _pageController.previousPage(
      duration: _pageTurn,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (_isEdit && !_loadedExisting) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final isLast = _step == _stepCount - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l10n.wizardTitleEdit : l10n.wizardTitleNew),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _back,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: (_step + 1) / _stepCount,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.wizardStepIndicator(_step + 1, _stepCount),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) => setState(() => _step = page),
                    children: [
                      _stepNamePhoto(l10n),
                      _stepAbout(l10n),
                      _stepExperience(l10n),
                      _stepSenses(l10n),
                      _stepBodyTreats(l10n),
                      _stepGoalNotes(l10n),
                      _stepReview(l10n),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _saving ? null : _next,
                      child: _saving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              isLast
                                  ? (_isEdit
                                        ? l10n.wizardSaveAction
                                        : l10n.wizardCreateAction)
                                  : l10n.actionNext,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _page(String title, List<Widget> children) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _stepNamePhoto(AppLocalizations l10n) {
    final photoPreview = _pickedPhoto != null
        ? CircleAvatar(radius: 56, backgroundImage: FileImage(_pickedPhoto!))
        : CatAvatar(
            name: _draft.name,
            photoPath: _removeExistingPhoto ? null : _draft.photoPath,
            radius: 56,
          );
    final hasAnyPhoto =
        _pickedPhoto != null ||
        (_draft.photoPath != null && !_removeExistingPhoto);

    return _page(l10n.wizardStepNamePhoto, [
      Center(child: photoPreview),
      const SizedBox(height: 12),
      Center(
        child: Wrap(
          spacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: _pickPhoto,
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(
                hasAnyPhoto ? l10n.wizardPhotoChange : l10n.wizardPhotoAdd,
              ),
            ),
            if (hasAnyPhoto)
              TextButton(
                onPressed: () => setState(() {
                  _pickedPhoto = null;
                  _removeExistingPhoto = true;
                }),
                child: Text(l10n.wizardPhotoRemove),
              ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      TextField(
        controller: _nameController,
        maxLength: 40,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: l10n.wizardNameLabel,
          hintText: l10n.wizardNameHint,
          border: const OutlineInputBorder(),
          errorText: _nameTouched && !_draft.isValid
              ? l10n.wizardNameError
              : null,
        ),
        onChanged: (value) {
          _nameTouched = true;
          _update(_draft.copyWith(name: value));
        },
      ),
      const SizedBox(height: 16),
      Text(l10n.wizardPriorNote, style: Theme.of(context).textTheme.bodySmall),
    ]);
  }

  Widget _stepAbout(AppLocalizations l10n) {
    return _page(l10n.wizardStepAbout, [
      _choiceGroup<AgeGroup>(
        label: l10n.wizardAgeLabel,
        values: AgeGroup.values,
        selected: _draft.ageGroup,
        labelOf: (v) => v.label(l10n),
        onSelected: (v) => _update(_draft.copyWith(ageGroup: v)),
      ),
      _choiceGroup<BodySize>(
        label: l10n.wizardBodySizeLabel,
        values: BodySize.values,
        selected: _draft.bodySize,
        labelOf: (v) => v.label(l10n),
        onSelected: (v) => _update(_draft.copyWith(bodySize: v)),
      ),
      _choiceGroup<EnergyLevel>(
        label: l10n.wizardEnergyLabel,
        values: EnergyLevel.values,
        selected: _draft.energyLevel,
        labelOf: (v) => v.label(l10n),
        onSelected: (v) => _update(_draft.copyWith(energyLevel: v)),
      ),
    ]);
  }

  Widget _stepExperience(AppLocalizations l10n) {
    return _page(l10n.wizardStepExperience, [
      _choiceGroup<ScreenExperience>(
        label: l10n.wizardExperienceLabel,
        values: ScreenExperience.values,
        selected: _draft.screenExperience,
        labelOf: (v) => v.label(l10n),
        onSelected: (v) => _update(_draft.copyWith(screenExperience: v)),
      ),
      _choiceGroup<FavouritePrey>(
        label: l10n.wizardFavouritePreyLabel,
        values: FavouritePrey.values,
        selected: _draft.favouritePrey,
        labelOf: (v) => v.label(l10n),
        onSelected: (v) => _update(_draft.copyWith(favouritePrey: v)),
      ),
    ]);
  }

  Widget _stepSenses(AppLocalizations l10n) {
    return _page(l10n.wizardStepSenses, [
      _choiceGroup<SoundSensitivity>(
        label: l10n.wizardSoundLabel,
        values: SoundSensitivity.values,
        selected: _draft.soundSensitivity,
        labelOf: (v) => v.label(l10n),
        onSelected: (v) => _update(_draft.copyWith(soundSensitivity: v)),
      ),
      _choiceGroup<VisionConsideration>(
        label: l10n.wizardVisionLabel,
        values: VisionConsideration.values,
        selected: _draft.visionConsideration,
        labelOf: (v) => v.label(l10n),
        onSelected: (v) => _update(_draft.copyWith(visionConsideration: v)),
      ),
      _choiceGroup<HearingConsideration>(
        label: l10n.wizardHearingLabel,
        values: HearingConsideration.values,
        selected: _draft.hearingConsideration,
        labelOf: (v) => v.label(l10n),
        onSelected: (v) => _update(_draft.copyWith(hearingConsideration: v)),
      ),
    ]);
  }

  Widget _stepBodyTreats(AppLocalizations l10n) {
    return _page(l10n.wizardStepBodyTreats, [
      _choiceGroup<TreatMotivation>(
        label: l10n.wizardTreatLabel,
        values: TreatMotivation.values,
        selected: _draft.treatMotivation,
        labelOf: (v) => v.label(l10n),
        onSelected: (v) => _update(_draft.copyWith(treatMotivation: v)),
      ),
      _choiceGroup<MobilityConsideration>(
        label: l10n.wizardMobilityLabel,
        values: MobilityConsideration.values,
        selected: _draft.mobilityConsideration,
        labelOf: (v) => v.label(l10n),
        onSelected: (v) => _update(_draft.copyWith(mobilityConsideration: v)),
      ),
    ]);
  }

  Widget _stepGoalNotes(AppLocalizations l10n) {
    return _page(l10n.wizardStepGoalNotes, [
      _choiceGroup<PrimaryGoal>(
        label: l10n.wizardGoalLabel,
        values: PrimaryGoal.values,
        selected: _draft.primaryGoal,
        labelOf: (v) => v.label(l10n),
        onSelected: (v) => _update(_draft.copyWith(primaryGoal: v)),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: _notesController,
        maxLines: 4,
        maxLength: 500,
        decoration: InputDecoration(
          labelText: l10n.wizardNotesLabel,
          hintText: l10n.wizardNotesHint,
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) => _update(_draft.copyWith(notes: value)),
      ),
    ]);
  }

  Widget _stepReview(AppLocalizations l10n) {
    final rows = <(String, String)>[
      (l10n.wizardAgeLabel, _draft.ageGroup.label(l10n)),
      (l10n.wizardBodySizeLabel, _draft.bodySize.label(l10n)),
      (l10n.wizardEnergyLabel, _draft.energyLevel.label(l10n)),
      (l10n.wizardExperienceLabel, _draft.screenExperience.label(l10n)),
      (l10n.wizardFavouritePreyLabel, _draft.favouritePrey.label(l10n)),
      (l10n.wizardSoundLabel, _draft.soundSensitivity.label(l10n)),
      (l10n.wizardVisionLabel, _draft.visionConsideration.label(l10n)),
      (l10n.wizardHearingLabel, _draft.hearingConsideration.label(l10n)),
      (l10n.wizardTreatLabel, _draft.treatMotivation.label(l10n)),
      (l10n.wizardMobilityLabel, _draft.mobilityConsideration.label(l10n)),
      (l10n.wizardGoalLabel, _draft.primaryGoal.label(l10n)),
    ];
    return _page(l10n.wizardStepReview, [
      Text(l10n.wizardReviewIntro(_draft.name.trim())),
      const SizedBox(height: 16),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              for (final (label, value) in rows)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        value,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _choiceGroup<T>({
    required String label,
    required List<T> values,
    required T selected,
    required String Function(T) labelOf,
    required ValueChanged<T> onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final value in values)
                ChoiceChip(
                  label: Text(labelOf(value)),
                  selected: value == selected,
                  onSelected: (_) => onSelected(value),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
