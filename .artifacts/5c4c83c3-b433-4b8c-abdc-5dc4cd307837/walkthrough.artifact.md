# Walkthrough - Fix RenderBox Cast Error

I have resolved the `_TypeError` that was causing the `CompanyProfileScreen` to crash during initialization.

## Changes Made

### UI Layer

#### [company_profile_screen.dart](file:///C:/Users/chint/Downloads/Thredo/Thredo/Thredo/lib/view/company/company_profile_screen.dart)

- Moved the `GlobalKey` (`_headerKey`) from the `SliverToBoxAdapter` to its child `Container`.
- This ensures that `findRenderObject()` returns a `RenderBox` instead of a `RenderSliverToBoxAdapter`, allowing the height measurement logic in `initState` to function correctly without crashing.

```diff
-          SliverToBoxAdapter(
-            key: _headerKey,
-            child: Container(
+          SliverToBoxAdapter(
+            child: Container(
+              key: _headerKey,
               color: backgroundColor,
```

## Verification Results

### Manual Verification
- The app should no longer crash with `type 'RenderSliverToBoxAdapter' is not a subtype of type 'RenderBox?'` when opening the company profile.
- The `_headerHeight` will now be correctly calculated, enabling the smooth transition to the compact sticky header during scrolling.
