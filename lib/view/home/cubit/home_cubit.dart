import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thredo/api/dio_helper.dart';
import 'package:thredo/app_config.dart';
import 'package:thredo/model/banner_response.dart';
import 'package:thredo/model/category_list_response.dart';
import 'package:thredo/model/color_list_response.dart';
import 'package:thredo/model/company_list_response.dart';
import 'package:thredo/model/materials_list_response.dart';
import 'package:thredo/model/product_list_response.dart';
import 'package:thredo/model/wish_list_response.dart';
import 'package:thredo/utils/helper.dart';
import 'package:thredo/view/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitialState());

  static const int _pageSize = 30;
  static const int _filterCompaniesPageSize = 100;

  Future<void>? _inflightFetch;
  int _page = 1;
  int _totalProductPages = 1;
  int _productsRequestId = 0;

  HomeStateData get _dataState => state is HomeStateData ? (state as HomeStateData) : const HomeStateData();

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

    _inflightFetch = Future.wait([
      _fetchBanners(),
      _fetchCategories(),
      _fetchProducts(isLoadMore: false),
      _fetchWishlist(),
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

  /// Pull-to-refresh — keeps current search query and re-syncs wishlist.
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
      _fetchWishlist(forceRefresh: true),
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

  /// Toggle wishlist state for a product directly on the Home Screen.
  Future<void> toggleWishlist(String productId) async {
    final trimmedId = productId.trim();
    if (trimmedId.isEmpty) return;

    final currentSet = Set<String>.from(_dataState.wishlistedProductIds);
    final isCurrentlyLiked = currentSet.contains(trimmedId);

    // Optimistic state update
    if (isCurrentlyLiked) {
      currentSet.remove(trimmedId);
    } else {
      currentSet.add(trimmedId);
    }
    emit(_dataState.copyWith(wishlistedProductIds: currentSet));

    try {
      if (isCurrentlyLiked) {
        final response = await DioHelper.deleteData(url: 'user/wishlist/$trimmedId', isHeader: true);
        if (response.statusCode != 200 && response.statusCode != 204) {
          final serverMsg = response.data is Map<String, dynamic>
              ? (response.data['detail']?.toString() ?? response.data['message']?.toString())
              : null;
          throw Exception(serverMsg ?? 'Could not remove from wishlist');
        }
      } else {
        final response = await DioHelper.postData(
          url: ApiConfig.addToWishListEP,
          data: {'product_id': trimmedId},
          isHeader: true,
        );
        if (response.statusCode != 200 && response.statusCode != 201) {
          final serverMsg = response.data is Map<String, dynamic>
              ? (response.data['detail']?.toString() ?? response.data['message']?.toString())
              : null;
          throw Exception(serverMsg ?? 'Could not add to wishlist');
        }
      }
    } catch (error) {
      // Revert optimistic state on failure
      final revertedSet = Set<String>.from(_dataState.wishlistedProductIds);
      if (isCurrentlyLiked) {
        revertedSet.add(trimmedId);
      } else {
        revertedSet.remove(trimmedId);
      }
      emit(_dataState.copyWith(wishlistedProductIds: revertedSet));

      final displayMsg =
          getErrorMessage(error) ?? (isCurrentlyLiked ? 'Could not remove from wishlist' : 'Could not add to wishlist');
      showMessage(message: displayMsg);
    }
  }

  Future<void> _fetchWishlist({bool forceRefresh = false}) async {
    try {
      final response = await DioHelper.getData(
        url: ApiConfig.getWishListEP,
        isHeader: true,
        forceRefresh: forceRefresh,
      );
      if (isClosed) return;
      if (response.statusCode == 200) {
        final data = WishListResponse.fromJson(response.data);
        final ids = <String>{};
        if (data.data != null) {
          for (final item in data.data!) {
            if (item.productId != null && item.productId!.trim().isNotEmpty) {
              ids.add(item.productId!.trim());
            } else if (item.product?.id != null && item.product!.id!.trim().isNotEmpty) {
              ids.add(item.product!.id!.trim());
            }
          }
        }
        emit(_dataState.copyWith(wishlistedProductIds: ids));
      }
    } catch (_) {
      // Keep existing set on error
    }
  }

  Map<String, dynamic> _productQueryParams() {
    int pageToFetch = _page;
    if (_page == 1 && !_dataState.isSearching && !_dataState.hasActiveFilters && _totalProductPages > 1) {
      pageToFetch = Random().nextInt(_totalProductPages) + 1;
    }

    final params = <String, dynamic>{'page': pageToFetch, 'per_page': _pageSize};
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

      if (isClosed) return;

      if (result.statusCode == 200) {
        if (isClosed || requestId != _productsRequestId) return;

        final response = ProductListResponse.fromJson(result.data);
        if (response.pagination?.totalPages != null && response.pagination!.totalPages! > 0) {
          _totalProductPages = response.pagination!.totalPages!.toInt();
        }

        final incoming = List<ProductListData>.from(response.data ?? const <ProductListData>[]);
        if (!isLoadMore) {
          incoming.shuffle();
        }

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
    } catch (_) {
      // Keep current banners on failure
    }
  }

  Future<void> _fetchCategories({bool forceRefresh = false}) async {
    try {
      final result = await DioHelper.getData(
        url: ApiConfig.categoryListEP,
        query: {'page': 1, 'per_page': 6},
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
