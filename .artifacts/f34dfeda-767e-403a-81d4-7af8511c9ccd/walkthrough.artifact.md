# Walkthrough - Static Image Background for AR Match

I have added the ability for users to use a static image instead of a live camera feed in the `ARMatchScreen`. This makes it easier to compare threads or shade cards with fabric photos previously taken or stored in the gallery.

## Changes

### [ARMatchScreen](file:///C:/Users/chint/Downloads/Thredo/Thredo/Thredo/lib/view/productDetail/ar_match_screen.dart)

- **Media Switching**: Added a new "Add Photo" button to the top navigation bar.
- **Image Picking**: Integrated `ImagePicker` to allow users to take a new photo or select one from their gallery.
- **Conditional Background**: The background (full-screen in product mode, split-screen in company mode) now dynamically switches between the live camera feed and the selected static image.
- **Mode Toggle**: When an image is active, the user can tap the button again to "Switch to Live Camera".
- **Intelligent UI**:
    - The torch (flashlight) button is automatically hidden when a static image is being used.
    - The bottom hint text updates to inform the user they are comparing with a selected photo.
    - Haptic feedback added to the media action button for a better tactile experience.

## Verification Results

### Automated Tests
- Ran `analyze_file` on `ar_match_screen.dart`, confirming no syntax errors were introduced.

### Manual Verification (To be done by user)
1.  Navigate to a **Product Detail** screen and open the **AR Match** (AR icon).
2.  Tap the **Add Photo** icon (camera with plus) in the top bar.
3.  Select an image from your gallery.
4.  Confirm that the thread zoom window appears over your selected image.
5.  Go back to a **Company Profile**, select a **Shade Card**, and repeat the process in split-screen mode.
