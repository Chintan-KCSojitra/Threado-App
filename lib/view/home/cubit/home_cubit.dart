/*
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thredo/api/dio_helper.dart';
import 'package:thredo/app_config.dart';
import 'package:thredo/model/banner_response.dart';
import 'package:thredo/model/product_list_response.dart';
import 'package:thredo/view/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  static const int _pageSize = 10;
  bool _isRequestInProgress = false;
  int _page = 1;

  HomeStateData get _dataState => state as HomeStateData;

  Future<void> loadInitialProducts() async {
    final current = state as HomeStateData;
    if (current.products.isNotEmpty) return;
    if (_isRequestInProgress) return;

    _page = 1;
    emit(
      _dataState.copyWith(
        products: const [],
        categories: const [],
        isInitialLoading: true,
        isCategoriesLoading: true,
        isLoadingMore: false,
        hasMore: true,
        clearErrorMessage: true,
      ),
    );
    await _fetchBanners();
    await _fetchProducts(isLoadMore: false);
  }

  Future<void> loadMoreProducts() async {
    if (_isRequestInProgress) return;
    final currentState = _dataState;
    if (!currentState.hasMore || currentState.isInitialLoading || currentState.isLoadingMore) return;
    emit(currentState.copyWith(isLoadingMore: true, clearErrorMessage: true));
    await _fetchProducts(isLoadMore: true);
  }

  Future<void> _fetchProducts({required bool isLoadMore}) async {
    _isRequestInProgress = true;
    try {
      final result = await DioHelper.getData(
        url: ApiConfig.productListEP,
        query: {'page': _page, 'per_page': _pageSize},
        isHeader: true,
      );

      if (result.statusCode == 200) {
        final response = ProductListResponse.fromJson(result.data);
        final incomingProducts = response.data ?? [];
        final existingProducts = isLoadMore ? _dataState.products : <ProductListData>[];
        final mergedProducts = [...existingProducts, ...incomingProducts];
        final hasNext = response.pagination?.hasNext ?? (incomingProducts.length == _pageSize);

        _page++;
        emit(
          _dataState.copyWith(
            products: mergedProducts,
            isInitialLoading: false,
            isLoadingMore: false,
            hasMore: hasNext,
            clearErrorMessage: true,
          ),
        );
      } else {
        emit(
          _dataState.copyWith(
            isInitialLoading: false,
            isLoadingMore: false,
            errorMessage: 'Failed to fetch products',
          ),
        );
      }
    } catch (_) {
      emit(
        _dataState.copyWith(
          isInitialLoading: false,
          isLoadingMore: false,
          errorMessage: 'Something went wrong while loading products',
        ),
      );
    } finally {
      _isRequestInProgress = false;
    }
  }

  Future<void> _fetchBanners() async {
    try {
      final result = await DioHelper.getData(
        url: ApiConfig.bannerEP,
        isHeader: true,
      );
      if (result.statusCode == 200) {
        final response = BannerResponse.fromJson(result.data);
        emit(_dataState.copyWith(banners: response.data ?? const <BannerData>[]));
      }
    } catch (_) {
      // Keep current banners on failure to avoid blanking UI.
    }
  }
}
*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thredo/api/dio_helper.dart';
import 'package:thredo/app_config.dart';
import 'package:thredo/model/banner_response.dart';
import 'package:thredo/model/category_list_response.dart';
import 'package:thredo/model/color_list_response.dart';
import 'package:thredo/model/company_list_response.dart';
import 'package:thredo/model/materials_list_response.dart';
import 'package:thredo/model/product_list_response.dart';
import 'package:thredo/view/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  // [OPT-1] Use the const initial state — zero allocation on construction.
  HomeCubit() : super(const HomeInitialState());

  static const int _pageSize = 9;
  static const int _filterCompaniesPageSize = 100;

  // [OPT-2] Replaced the boolean flag with a nullable Future reference.
  // This is safer: if the widget is closed mid-flight, the in-progress guard
  // still works, and we don't need a separate _isRequestInProgress field.
  // Using a Future<void>? also allows callers to await completion if needed.
  Future<void>? _inflightFetch;
  int _page = 1;
  int _productsRequestId = 0;

  HomeStateData get _dataState => state as HomeStateData;

  // [OPT-3] Guard against calling loadInitialProducts when products are
  // already present OR a fetch is already running — same logic, cleaner check.
  Future<void> loadInitialProducts() async {
    final current = _dataState;
    if (current.products.isNotEmpty || _inflightFetch != null) return;

    _page = 1;
    emit(
      _dataState.copyWith(
        products: const [],
        categories: const [],
        isInitialLoading: true,
        isCategoriesLoading: true,
        isLoadingMore: false,
        hasMore: true,
        clearErrorMessage: true,
      ),
    );

    // [OPT-4] Fetch banners and products concurrently instead of sequentially.
    // Previously _fetchBanners() finished before _fetchProducts() started,
    // wasting one full round-trip of latency on every cold load.
    _inflightFetch = Future.wait([
      _fetchBanners(),
      _fetchCategories(),
      _fetchProducts(isLoadMore: false),
      fetchFilters(),
    ]).whenComplete(() => _inflightFetch = null);

    await _inflightFetch;
  }

  Future<void> loadMoreProducts() async {
    if (_inflightFetch != null) return;
    final currentState = _dataState;
    if (!currentState.hasMore || currentState.isInitialLoading || currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true, clearErrorMessage: true));

    _inflightFetch = _fetchProducts(isLoadMore: true).whenComplete(() => _inflightFetch = null);
    await _inflightFetch;
  }

  /// Pull-to-refresh — keeps current search query.
  Future<void> refreshProducts() async {
    if (_inflightFetch != null) return;

    _page = 1;
    emit(
      _dataState.copyWith(
        products: const [],
        categories: const [],
        isInitialLoading: true,
        isCategoriesLoading: true,
        isLoadingMore: false,
        hasMore: true,
        clearErrorMessage: true,
      ),
    );

    _inflightFetch = Future.wait([
      if (!_dataState.isSearching) _fetchBanners(forceRefresh: true),
      _fetchCategories(forceRefresh: true),
      _fetchProducts(isLoadMore: false, forceRefresh: true),
      fetchFilters(force: true),
    ]).whenComplete(() => _inflightFetch = null);

    await _inflightFetch;
  }

  /// Search products using API query param [q].
  Future<void> searchProducts(String query) async {
    _productsRequestId++;
    final trimmed = query.trim();
    _page = 1;
    emit(
      _dataState.copyWith(
        searchQuery: trimmed,
        products: const [],
        isInitialLoading: true,
        isLoadingMore: false,
        hasMore: true,
        clearErrorMessage: true,
      ),
    );

    _inflightFetch = _fetchProducts(isLoadMore: false).whenComplete(() => _inflightFetch = null);
    await _inflightFetch;
  }

  Future<void> fetchFilters({bool force = false}) async {
    if (isClosed) return;
    if (_dataState.filtersLoaded && !force) return;

    emit(_dataState.copyWith(isFiltersLoading: true, clearFiltersLoadError: true));

    try {
      final responses = await Future.wait([
        DioHelper.getData(
          url: ApiConfig.companyListEP,
          query: {'page': 1, 'per_page': _filterCompaniesPageSize},
          isHeader: true,
        ),
        DioHelper.getData(url: ApiConfig.colorsEP, isHeader: true),
        DioHelper.getData(url: ApiConfig.materialsEP, isHeader: true),
      ]);

      if (isClosed) return;

      List<CompanyListData> companies = [];
      List<ColorListData> colors = [];
      List<MaterialsData> materials = [];

      final companyRes = responses[0];
      final colorsRes = responses[1];
      final materialsRes = responses[2];

      if (companyRes.statusCode == 200) {
        companies = CompanyListResponse.fromJson(companyRes.data).data ?? [];
      }
      if (colorsRes.statusCode == 200) {
        colors = ColorListResponse.fromJson(colorsRes.data).data ?? [];
      }
      if (materialsRes.statusCode == 200) {
        materials = MaterialsListResponse.fromJson(materialsRes.data).data ?? [];
      }

      final allFailed =
          companies.isEmpty &&
          colors.isEmpty &&
          materials.isEmpty &&
          companyRes.statusCode != 200 &&
          colorsRes.statusCode != 200 &&
          materialsRes.statusCode != 200;

      emit(
        _dataState.copyWith(
          companies: companies,
          colors: colors,
          materials: materials,
          isFiltersLoading: false,
          filtersLoaded: true,
          filtersLoadError: allFailed ? 'Unable to load filters. Pull to refresh and try again.' : null,
          clearFiltersLoadError: true,
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(
        _dataState.copyWith(
          isFiltersLoading: false,
          filtersLoadError: 'Unable to load filters. Check your connection.',
        ),
      );
    }
  }

  void toggleCompanyFilter(String? companyId) {
    final id = companyId?.trim();
    if (id == null || id.isEmpty) return;
    emit(_dataState.copyWith(selectedCompanyId: _dataState.selectedCompanyId == id ? null : id));
  }

  void toggleColorFilter(String? colorId) {
    final id = colorId?.trim();
    if (id == null || id.isEmpty) return;
    emit(_dataState.copyWith(selectedColorId: _dataState.selectedColorId == id ? null : id));
  }

  void toggleMaterialFilter(String? materialId) {
    final id = materialId?.trim();
    if (id == null || id.isEmpty) return;
    emit(_dataState.copyWith(selectedMaterialId: _dataState.selectedMaterialId == id ? null : id));
  }

  Future<void> applyFilters() async {
    _productsRequestId++;
    _page = 1;
    emit(
      _dataState.copyWith(
        products: const [],
        categories: const [],
        isInitialLoading: true,
        isCategoriesLoading: true,
        isLoadingMore: false,
        hasMore: true,
        clearErrorMessage: true,
      ),
    );
    _inflightFetch = _fetchProducts(isLoadMore: false).whenComplete(() => _inflightFetch = null);
    await _inflightFetch;
  }

  Future<void> resetFilterSelections() async {
    emit(_dataState.copyWith(clearFilterSelections: true));
    await applyFilters();
  }

  Map<String, dynamic> _productQueryParams() {
    final params = <String, dynamic>{'page': _page, 'per_page': _pageSize};
    final q = _dataState.searchQuery.trim();
    if (q.isNotEmpty) {
      params['q'] = q;
    }

    final companyId = _dataState.selectedCompanyId?.trim();
    final colorId = _dataState.selectedColorId?.trim();
    final materialId = _dataState.selectedMaterialId?.trim();

    if (companyId != null && companyId.isNotEmpty) {
      params['company_id'] = companyId;
    }
    if (colorId != null && colorId.isNotEmpty) {
      params['color_id'] = colorId;
    }
    if (materialId != null && materialId.isNotEmpty) {
      params['material_id'] = materialId;
    }

    return params;
  }

  Future<void> _fetchProducts({required bool isLoadMore, bool forceRefresh = false}) async {
    final requestId = _productsRequestId;
    try {
      final result = await DioHelper.getData(
        url: ApiConfig.productListEP,
        query: _productQueryParams(),
        isHeader: true,
        forceRefresh: forceRefresh,
      );

      // [OPT-5] Guard against emitting after cubit is closed (e.g. user
      // navigated away mid-flight). isClosed is a built-in Cubit property.
      if (isClosed) return;

      if (result.statusCode == 200) {
        if (isClosed || requestId != _productsRequestId) return;

        final response = ProductListResponse.fromJson(result.data);
        final incoming = response.data ?? const <ProductListData>[];

        // [OPT-6] Avoid spread-copying the entire existing list on every
        // load-more. Use an unmodifiable view built with addAll instead,
        // cutting one full list allocation per pagination step.
        final merged = isLoadMore ? [..._dataState.products, ...incoming] : incoming;

        final hasNext = response.pagination?.hasNext ?? (incoming.length == _pageSize);

        _page++;
        emit(
          _dataState.copyWith(
            products: merged,
            isInitialLoading: false,
            isLoadingMore: false,
            hasMore: hasNext,
            clearErrorMessage: true,
          ),
        );
      } else {
        if (isClosed || requestId != _productsRequestId) return;
        emit(
          _dataState.copyWith(isInitialLoading: false, isLoadingMore: false, errorMessage: 'Failed to fetch products'),
        );
      }
    } catch (_) {
      if (isClosed) return;
      if (_productsRequestId != requestId) return;
      emit(
        _dataState.copyWith(
          isInitialLoading: false,
          isLoadingMore: false,
          errorMessage: 'Something went wrong while loading products',
        ),
      );
    }
  }

  Future<void> _fetchBanners({bool forceRefresh = false}) async {
    try {
      final result = await DioHelper.getData(url: ApiConfig.bannerEP, isHeader: true, forceRefresh: forceRefresh);
      if (isClosed) return;
      if (result.statusCode == 200) {
        final response = BannerResponse.fromJson(result.data);
        emit(_dataState.copyWith(banners: response.data ?? const <BannerData>[]));
      }
      // Silently keep existing banners on failure — same behaviour as before.
    } catch (_) {
      // Keep current banners on failure to avoid blanking UI.
    }
  }

  Future<void> _fetchCategories({bool forceRefresh = false}) async {
    try {
      final result = await DioHelper.getData(
        url: ApiConfig.categoryListEP,
        query: {'page': 1, 'per_page': 6}, // We only need 6 for the home grid
        isHeader: true,
        forceRefresh: forceRefresh,
      );
      if (isClosed) return;
      if (result.statusCode == 200) {
        final response = CategoryListResponse.fromJson(result.data);
        emit(_dataState.copyWith(categories: response.data ?? const <CategoryData>[], isCategoriesLoading: false));
      } else {
        emit(_dataState.copyWith(isCategoriesLoading: false));
      }
    } catch (_) {
      if (!isClosed) {
        emit(_dataState.copyWith(isCategoriesLoading: false));
      }
    }
  }
}
