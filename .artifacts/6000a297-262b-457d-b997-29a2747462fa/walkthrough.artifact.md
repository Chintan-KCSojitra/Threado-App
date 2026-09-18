# Walkthrough - Fixed Blurry Shade Cards during Scroll

I have optimized the image rendering in the Shade Cards Gallery to prevent blurriness and "flashing" effects during scrolling.

## Changes Made

### UI Optimization

#### [shade_cards_gallery_screen.dart](file:///C:/Users/chint/Downloads/Thredo/Thredo/Thredo/lib/view/company/shade_cards_gallery_screen.dart)
- **Memory-Efficient Decoding**: Added explicit `width` calculation for grid items. This allows `AppCachedImage` to decode images at a sensible resolution (capped at 3x display width) rather than full source resolution, significantly reducing memory pressure.
- **Enabled Memory Cache**: Ensured `useMemCache: true` is active to prevent the `ImageCache` from evicting images prematurely, which was the primary cause of images "blurring" or disappearing during scroll.
- **Improved Filter Quality Balance**: Switched to `FilterQuality.medium`. This provides a better balance between visual sharpness and scrolling performance compared to `FilterQuality.high`.
- **Retained High-Res Cache**: Kept `useResize: false` so the app still downloads the full-resolution image once and stores it in the persistent cache, ensuring the best quality is available when the user opens the detail/AR view.

## Verification Results

### Manual Verification Required
- [ ] Open the **Shade cards** screen for any company.
- [ ] Scroll through the list of shade cards.
- [ ] Confirm that images remain sharp and do not repeatedly show placeholders or appear blurry while scrolling.
- [ ] Tap a card and verify it still displays in high resolution in the AR Match screen.
