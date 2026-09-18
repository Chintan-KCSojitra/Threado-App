# Redesign Home Page Tasks

- `[x]` Update `lib/res/image.dart` with `companyBanner` path.
- `[x]` Update `lib/view/home/cubit/home_state.dart` to include categories and loading state.
- `[x]` Update `lib/view/home/cubit/home_cubit.dart` to fetch initial categories.
- `[x]` Create `AllProductCubit` and `AllProductState` for the dedicated product list.
- `[x]` Create `AllProductScreen` for the full paginated product list.
- `[x]` Redesign `HomeScreen` UI:
    - `[x]` Refactor into a `ListView` or `CustomScrollView` with static sections.
    - `[x]` Implement 2x3 Category Grid (first 6 categories).
    - `[x]` Add "View All" categories navigation.
    - `[x]` Implement Company Banner with navigation.
    - `[x]` Implement 3x3 Product Grid (first 9 products).
    - `[x]` Add "View All Product" navigation.
- `[x]` Verify all sections and navigation paths.
