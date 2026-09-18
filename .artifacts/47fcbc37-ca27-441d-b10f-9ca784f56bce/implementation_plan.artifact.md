# Fix Home Page Category Loading Plan

The category section on the home page currently shows a shimmer (skeleton) and does not transition to the actual data even after the API call finishes. This is likely due to a restrictive `buildWhen` in the `BlocBuilder` and missing state management for category loading.

## User Review Required

> [!NOTE]
> I will switch the category section to use `isCategoriesLoading` instead of the global `isInitialLoading`. This allows the categories to appear as soon as they are fetched, without waiting for the products to finish loading.

## Proposed Changes

### [Home Component]

#### [MODIFY] [home_cubit.dart](file:///C:/Users/chint/Downloads/Thredo/Thredo/Thredo/lib/view/home/cubit/home_cubit.dart)
- Update `loadInitialProducts` to set `isCategoriesLoading: true`.
- Update `refreshProducts` to set `isCategoriesLoading: true`.
- Update `_fetchCategories` to manage `isCategoriesLoading` state (set to `true` at start, `false` at end).

#### [MODIFY] [home_screen.dart](file:///C:/Users/chint/Downloads/Thredo/Thredo/Thredo/lib/view/home/home_screen.dart)
- Update `_buildCategorySection`'s `BlocBuilder`:
    - Fix `buildWhen` to include `isCategoriesLoading` and `isInitialLoading`.
    - Change the skeleton condition to use `state.isCategoriesLoading` or `state.isInitialLoading`.
- Update `_buildProductSection`'s `BlocBuilder`:
    - Fix `buildWhen` to include `isInitialLoading`.

## Verification Plan

### Manual Verification
- Open the Home page and ensure categories transition from shimmer to actual data.
- Verify categories appear even if products are still loading (and vice versa).
- Verify pull-to-refresh correctly shows shimmers for both sections and updates the data.
