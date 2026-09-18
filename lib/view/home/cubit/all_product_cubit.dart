import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thredo/api/dio_helper.dart';
import 'package:thredo/app_config.dart';
import 'package:thredo/model/color_list_response.dart';
import 'package:thredo/model/company_list_response.dart';
import 'package:thredo/model/materials_list_response.dart';
import 'package:thredo/model/product_list_response.dart';
import 'package:thredo/view/home/cubit/all_product_state.dart';

class AllProductCubit extends Cubit<AllProductState> {
  AllProductCubit() : super(const AllProductInitialState());

  static const int _pageSize = 15;
  static const int _filterCompaniesPageSize = 100;

  Future<void>? _inflightFetch;
  int _page = 1;
  int _productsRequestId = 0;

  AllProductStateData get _dataState => state as AllProductStateData;

  Future<void> init() async {
    if (_dataState.products.isNotEmpty || _inflightFetch != null) return;
    await refreshProducts();
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

  Future<void> refreshProducts() async {
    if (_inflightFetch != null) return;

    _page = 1;
    emit(
      _dataState.copyWith(
        products: const [],
        isInitialLoading: true,
        isLoadingMore: false,
        hasMore: true,
        clearErrorMessage: true,
      ),
    );

    _inflightFetch = Future.wait([
      _fetchProducts(isLoadMore: false, forceRefresh: true),
      fetchFilters(force: true),
    ]).whenComplete(() => _inflightFetch = null);

    await _inflightFetch;
  }

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

      if (responses[0].statusCode == 200) {
        companies = CompanyListResponse.fromJson(responses[0].data).data ?? [];
      }
      if (responses[1].statusCode == 200) {
        colors = ColorListResponse.fromJson(responses[1].data).data ?? [];
      }
      if (responses[2].statusCode == 200) {
        materials = MaterialsListResponse.fromJson(responses[2].data).data ?? [];
      }

      emit(
        _dataState.copyWith(
          companies: companies,
          colors: colors,
          materials: materials,
          isFiltersLoading: false,
          filtersLoaded: true,
          clearFiltersLoadError: true,
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(_dataState.copyWith(isFiltersLoading: false, filtersLoadError: 'Unable to load filters'));
    }
  }

  void toggleCompanyFilter(String? companyId) {
    emit(_dataState.copyWith(selectedCompanyId: _dataState.selectedCompanyId == companyId ? null : companyId));
  }

  void toggleColorFilter(String? colorId) {
    emit(_dataState.copyWith(selectedColorId: _dataState.selectedColorId == colorId ? null : colorId));
  }

  void toggleMaterialFilter(String? materialId) {
    emit(_dataState.copyWith(selectedMaterialId: _dataState.selectedMaterialId == materialId ? null : materialId));
  }

  Future<void> applyFilters() async {
    _productsRequestId++;
    _page = 1;
    emit(
      _dataState.copyWith(
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

  Future<void> resetFilterSelections() async {
    emit(_dataState.copyWith(clearFilterSelections: true));
    await applyFilters();
  }

  Map<String, dynamic> _productQueryParams() {
    final params = <String, dynamic>{'page': _page, 'per_page': _pageSize};
    if (_dataState.searchQuery.isNotEmpty) params['q'] = _dataState.searchQuery;
    if (_dataState.selectedCompanyId != null) params['company_id'] = _dataState.selectedCompanyId;
    if (_dataState.selectedColorId != null) params['color_id'] = _dataState.selectedColorId;
    if (_dataState.selectedMaterialId != null) params['material_id'] = _dataState.selectedMaterialId;
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

      if (isClosed || requestId != _productsRequestId) return;

      if (result.statusCode == 200) {
        final response = ProductListResponse.fromJson(result.data);
        final incoming = response.data ?? const <ProductListData>[];
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
        emit(
          _dataState.copyWith(isInitialLoading: false, isLoadingMore: false, errorMessage: 'Failed to fetch products'),
        );
      }
    } catch (_) {
      if (isClosed || _productsRequestId != requestId) return;
      emit(
        _dataState.copyWith(
          isInitialLoading: false,
          isLoadingMore: false,
          errorMessage: 'Something went wrong while loading products',
        ),
      );
    }
  }
}
