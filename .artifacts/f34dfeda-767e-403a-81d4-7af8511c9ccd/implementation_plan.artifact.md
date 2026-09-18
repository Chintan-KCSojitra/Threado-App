# Implementation Plan - Static Image Background for AR Match

This plan outlines the steps to add a "Static Image Background" feature to the `ARMatchScreen`, allowing users to match colors using an uploaded or captured photo instead of a live camera feed.

## Proposed Changes

### [ARMatchScreen](file:///C:/Users/chint/Downloads/Thredo/Thredo/Thredo/lib/view/productDetail/ar_match_screen.dart)

#### 1. State and Initialization
- [MODIFY] Add `String? _pickedImagePath` to `_ARMatchScreenState` to store the path of the selected image.
- [NEW] Add `final ImagePicker _picker = ImagePicker();` instance.

#### 2. Media Picking Logic
- [NEW] Implement `_onMediaAction()` to show a bottom sheet with the following options:
    - **Take Photo**: Launches the camera via `ImagePicker`.
    - **Gallery**: Launches the gallery via `ImagePicker`.
    - **Reset to Live Camera**: Clears `_pickedImagePath` and returns to the live feed (only shown when an image is selected).

#### 3. Conditional Rendering
- [MODIFY] Update `_buildCamera()` (Product Mode) and `_buildCameraPanel()` (Company Mode) to:
    - If `_pickedImagePath != null`: Display `Image.file(File(_pickedImagePath!))` with `BoxFit.cover`.
    - Else: Display the existing `CameraPreview` or loader.

#### 4. UI Updates
- [MODIFY] Update `_buildTopBar` and `_buildCompanyTopBar` to include a new action button (e.g., `Icons.add_photo_alternate_outlined`) that triggers `_onMediaAction()`.
- [MODIFY] Update the "Torch" button logic to be disabled or hidden when `_pickedImagePath != null`, as it only applies to the live camera.

## Verification Plan

### Manual Verification
1.  **Product Mode**:
    - Open `ARMatchScreen` from a product detail page.
    - Verify live camera works.
    - Tap the "Add Photo" button and select an image from the gallery.
    - Verify the thread zoom overlay appears correctly over the static image.
    - Tap the "Add Photo" button and select "Reset to Live Camera". Verify camera resumes.
2.  **Company Mode**:
    - Open `ARMatchScreen` from a shade card gallery.
    - Verify split screen with camera.
    - Pick a photo. Verify the right panel switches to the image.
    - Verify the shade card on the left is still scrollable and interactive.
3.  **Flash/Torch**:
    - Verify the torch button works in camera mode.
    - Verify the torch is unavailable/inactive in image mode.
