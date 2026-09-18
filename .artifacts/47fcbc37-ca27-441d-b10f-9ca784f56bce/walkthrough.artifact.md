# Category Loading Fix Walkthrough

I have fixed the issue where the category section on the home page would only show a shimmer and never load the actual data.

## Changes Made

### Home State Management
- **HomeCubit**: Updated to explicitly track `isCategoriesLoading`.
    - `loadInitialProducts` and `refreshProducts` now set `isCategoriesLoading` to `true`.
    - `_fetchCategories` now sets `isCategoriesLoading` to `false` when the API call completes (success or failure).

### UI Rebuilding
- **HomeScreen**: Fixed the `buildWhen` logic in `BlocBuilder` for both Category and Product sections.
    - The Category section now rebuilds when `isCategoriesLoading` changes.
    - The Product section now correctly rebuilds when `isInitialLoading` changes.
- **Skeleton logic**: Improved the skeleton logic to use the specific `isCategoriesLoading` flag, ensuring shimmers disappear correctly when data is available.

## Verification Results

### Functionality
- [x] Categories now load and display correctly on home screen cold start.
- [x] Categories correctly show shimmer and refresh upon pull-to-refresh.
- [x] Product section shimmers and loads independently of categories.
