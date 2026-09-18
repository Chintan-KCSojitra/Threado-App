# Implementation Plan - Fix Shade Card Positioning and Scrolling

Fix the "infinity scroll" and centering issues for shade cards in the AR Match screen, and ensure full original quality in the gallery.

## User Review Required

> [!IMPORTANT]
> The shade card in the AR Match screen will now correctly start at the top of the panel and its scrolling will be restricted to the image edges, preventing it from floating away "infinitely".

## Proposed Changes

### [Component Name] AR Match Screen

#### [MODIFY] [ar_match_screen.dart](file:///C:/Users/chint/Downloads/Thredo/Thredo/Thredo/lib/view/productDetail/ar_match_screen.dart)
- Update `_buildSelectedShadeCardPanel` layout:
    - Use `LayoutBuilder` to get the panel's constraints.
    - Set `boundaryMargin: EdgeInsets.zero` in `InteractiveViewer` to stop infinite scrolling.
    - Wrap the child image in a `ConstrainedBox` and `Align(alignment: Alignment.topCenter)` to ensure it starts at the top and doesn't float in the center if it's smaller than the panel.
- Remove the unused `_shadeCardScrollController`.

### [Component Name] Shade Cards Gallery

#### [MODIFY] [shade_cards_gallery_screen.dart](file:///C:/Users/chint/Downloads/Thredo/Thredo/Thredo/lib/view/company/shade_cards_gallery_screen.dart)
- Finalize "Full Original Quality":
    - Uncomment `useMemCache: false`.
    - Remove the `placeholder` and `placeholderColor` to satisfy the "no loading box" request.
    - Delete the `_buildShadeCardPlaceholder` method.

## Verification Plan

### Manual Verification
- Open AR Match with a shade card.
- Verify the card starts at the top of the left panel.
- Verify that scrolling (panning) is locked to the image edges (no more infinity scroll).
- Open Shade Cards Gallery and verify images load directly with no grey placeholders and in full resolution.
