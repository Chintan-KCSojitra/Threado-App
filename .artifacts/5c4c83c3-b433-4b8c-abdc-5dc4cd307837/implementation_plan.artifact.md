# Fix TypeError: RenderSliverToBoxAdapter is not a subtype of RenderBox

The `CompanyProfileScreen` is experiencing a crash due to an invalid type cast in `initState`. A `GlobalKey` (`_headerKey`) is attached to a `SliverToBoxAdapter` widget, and the code attempts to cast its `RenderObject` to a `RenderBox`. Since `SliverToBoxAdapter` produces a `RenderSliverToBoxAdapter` (which is a `RenderSliver`, not a `RenderBox`), the cast fails.

## Proposed Changes

### [UI Layer]

#### [MODIFY] [company_profile_screen.dart](file:///C:/Users/chint/Downloads/Thredo/Thredo/Thredo/lib/view/company/company_profile_screen.dart)

Move the `_headerKey` from `SliverToBoxAdapter` to its child `Container`. This ensures that `_headerKey.currentContext?.findRenderObject()` returns a `RenderBox`, allowing the code to correctly measure the header height.

```diff
-          SliverToBoxAdapter(
-            key: _headerKey,
-            child: Container(
+          SliverToBoxAdapter(
+            child: Container(
+              key: _headerKey,
               color: backgroundColor,
```

## Verification Plan

### Manual Verification
- Launch the app and navigate to the Company Profile screen.
- Verify that the screen no longer crashes on initialization.
- Verify that the sticky header transition still works correctly as you scroll (which depends on the `_headerHeight` being measured correctly).
