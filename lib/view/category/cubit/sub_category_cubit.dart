import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thredo/api/dio_helper.dart';
import 'package:thredo/app_config.dart';
import 'package:thredo/model/product_list_response.dart';
import 'package:thredo/model/company_list_response.dart';
import 'package:thredo/model/color_list_response.dart';
import 'package:thredo/model/materials_list_response.dart';
import 'package:thredo/view/category/cubit/sub_category_state.dart';

class SubCategoryCubit extends Cubit<SubCategoryState> {
  SubCategoryCubit(this.categoryId) : super(const SubCategoryInitialState());

  final String categoryId;

  static const int _pageSize = 10;
  static const int _filterCompaniesPageSize = 100;

  bool _isRequestInProgress = false;
  int _page = 1;
  int _productsRequestId = 0;

  SubCategoryStateData get _dataState => state as SubCategoryStateData;

  Future<void> init() async {
    await Future.wait([
      fetchFilters(),
      loadInitialProducts(),
    ]);
  }

  Future<void> fetchFilters({bool force = false}) async {
    if (isClosed) return;
    if (_dataState.filtersLoaded && !force) return;

    emit(
      _dataState.copyWith(
        isFiltersLoading: true,
        clearFiltersLoadError: true,
      ),
    );

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

      final allFailed = companies.isEmpty &&
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
          filtersLoadError: allFailed
              ? 'Unable to load filters. Pull to refresh and try again.'
              : null,
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

  void setSearchQuery(String query) {
    emit(_dataState.copyWith(searchQuery: query));
  }

  Future<void> executeSearch() async {
    await loadInitialProducts();
  }

  void toggleCompanyFilter(String? companyId) {
    final id = companyId?.trim();
    if (id == null || id.isEmpty) return;
    emit(
      _dataState.copyWith(
        selectedCompanyId:
            _dataState.selectedCompanyId == id ? null : id,
      ),
    );
  }

  void toggleColorFilter(String? colorId) {
    final id = colorId?.trim();
    if (id == null || id.isEmpty) return;
    emit(
      _dataState.copyWith(
        selectedColorId: _dataState.selectedColorId == id ? null : id,
      ),
    );
  }

  void toggleMaterialFilter(String? materialId) {
    final id = materialId?.trim();
    if (id == null || id.isEmpty) return;
    emit(
      _dataState.copyWith(
        selectedMaterialId:
            _dataState.selectedMaterialId == id ? null : id,
      ),
    );
  }

  Future<void> applyFilters() async {
    await loadInitialProducts();
  }

  Future<void> resetFilterSelections() async {
    emit(_dataState.copyWith(clearFilterSelections: true));
    await loadInitialProducts();
  }

  Future<void> loadInitialProducts() async {
    if (_isRequestInProgress) return;

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
    await _fetchProducts(isLoadMore: false);
  }

  Future<void> refreshProducts() async {
    if (_isRequestInProgress) return;
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
    await Future.wait([
      fetchFilters(force: true),
      _fetchProducts(isLoadMore: false),
    ]);
  }

  Future<void> loadMoreProducts() async {
    if (_isRequestInProgress) return;
    final currentState = _dataState;
    if (!currentState.hasMore ||
        currentState.isInitialLoading ||
        currentState.isLoadingMore) {
      return;
    }
    emit(currentState.copyWith(isLoadingMore: true, clearErrorMessage: true));
    await _fetchProducts(isLoadMore: true);
  }

  Map<String, dynamic> _productQueryParams() {
    final params = <String, dynamic>{
      'page': _page,
      'per_page': _pageSize,
      'category_id': categoryId,
    };

    final companyId = _dataState.selectedCompanyId?.trim();
    final colorId = _dataState.selectedColorId?.trim();
    final materialId = _dataState.selectedMaterialId?.trim();
    final q = _dataState.searchQuery.trim();

    if (companyId != null && companyId.isNotEmpty) {
      params['company_id'] = companyId;
    }
    if (colorId != null && colorId.isNotEmpty) {
      params['color_id'] = colorId;
    }
    if (materialId != null && materialId.isNotEmpty) {
      params['material_id'] = materialId;
    }
    if (q.isNotEmpty) {
      params['q'] = q;
    }

    return params;
  }

  Future<void> _fetchProducts({required bool isLoadMore}) async {
    final requestId = _productsRequestId;
    _isRequestInProgress = true;
    try {
      final result = await DioHelper.getData(
        url: ApiConfig.productListEP,
        query: _productQueryParams(),
        isHeader: true,
      );

      if (isClosed || requestId != _productsRequestId) return;

      if (result.statusCode == 200) {
        final response = ProductListResponse.fromJson(result.data);
        final incoming = response.data ?? const <ProductListData>[];
        final merged = isLoadMore
            ? [..._dataState.products, ...incoming]
            : incoming;
        final hasNext =
            response.pagination?.hasNext ?? (incoming.length == _pageSize);

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
          _dataState.copyWith(
            isInitialLoading: false,
            isLoadingMore: false,
            errorMessage: 'Failed to fetch products',
          ),
        );
      }
    } catch (_) {
      if (isClosed || requestId != _productsRequestId) return;
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
}
