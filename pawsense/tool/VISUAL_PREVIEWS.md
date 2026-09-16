# Visual previews and native artwork

Run from the `pawsense` directory with the Flutter SDK on your path:

```sh
flutter test tool/capture_visual_previews_test.dart \
  --dart-define=PAWSENSE_PREVIEW_DIR=/tmp/pawsense-preview
```

This opt-in capture renders the production prey components and real owner
screens with Flutter's bundled Roboto font. It writes no files during an
ordinary `flutter test` run.

The output includes:

- `prey-regular.png` and `prey-high-contrast.png`: successive movement phases
  and two capture-response phases of every prey.
- `tablet-hunt-{mouse,moth,fish}.png`: 1024 × 768 hunting surface at the actual
  medium target size. No decorative controls or text are added to the board.
- `animation.html` plus its `animation/` folder: a local, offline 20 fps review
  of the actual Canvas frames. Its playback controls are review tools, not game
  UI. The short loop resets position between repetitions.
- `owner-intro-phone.png`, `owner-picker-phone.png`, `owner-home-phone.png`,
  and `owner-home-tablet.png`: actual app routes with a local sample cat.
- `pawsense-icon.png`: the original procedural cat-face launcher mark.

To regenerate the checked-in iOS/Android icons and splash image assets, add:

```sh
flutter test tool/capture_visual_previews_test.dart \
  --dart-define=PAWSENSE_PREVIEW_DIR=/tmp/pawsense-preview \
  --dart-define=PAWSENSE_GENERATE_ICONS=true
```

The generator reads the iOS asset catalogue's existing filenames/sizes and
renders every Android density directly from vector paths. App icons are encoded
as opaque RGB PNGs with no alpha channel, including the iOS marketing icon.
The artwork belongs to this project and uses no downloaded assets or fonts.

These captures review rendering and layout. They do not replace on-device
checks for paw input, microphone permissions, playback volume, screen wake,
orientation, or cat comfort.
