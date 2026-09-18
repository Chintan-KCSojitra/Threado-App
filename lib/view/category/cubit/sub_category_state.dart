import 'package:thredo/model/product_list_response.dart';
import 'package:thredo/model/company_list_response.dart';
import 'package:thredo/model/color_list_response.dart';
import 'package:thredo/model/materials_list_response.dart';

abstract class SubCategoryState {
  const SubCategoryState();
}

class SubCategoryStateData extends SubCategoryState {
  const SubCategoryStateData({
    this.products = const [],
    this.companies = const [],
    this.colors = const [],
    this.materials = const [],
    this.selectedCompanyId,
    this.selectedColorId,
    this.selectedMaterialId,
    this.searchQuery = '',
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.isFiltersLoading = false,
    this.filtersLoaded = false,
    this.filtersLoadError,
    this.hasMore = true,
    this.errorMessage,
  });

  final List<ProductListData> products;
  final List<CompanyListData> companies;
  final List<ColorListData> colors;
  final List<MaterialsData> materials;

  final String? selectedCompanyId;
  final String? selectedColorId;
  final String? selectedMaterialId;
  final String searchQuery;

  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool isFiltersLoading;
  final bool filtersLoaded;
  final String? filtersLoadError;
  final bool hasMore;
  final String? errorMessage;

  bool get hasActiveFilters =>
      (selectedCompanyId != null && selectedCompanyId!.isNotEmpty) ||
      (selectedColorId != null && selectedColorId!.isNotEmpty) ||
      (selectedMaterialId != null && selectedMaterialId!.isNotEmpty);

  int get activeFilterCount {
    var count = 0;
    if (selectedCompanyId != null && selectedCompanyId!.isNotEmpty) count++;
    if (selectedColorId != null && selectedColorId!.isNotEmpty) count++;
    if (selectedMaterialId != null && selectedMaterialId!.isNotEmpty) count++;
    return count;
  }

  bool get isSearching => searchQuery.trim().isNotEmpty;

  SubCategoryStateData copyWith({
    List<ProductListData>? products,
    List<CompanyListData>? companies,
    List<ColorListData>? colors,
    List<MaterialsData>? materials,
    String? selectedCompanyId,
    String? selectedColorId,
    String? selectedMaterialId,
    String? searchQuery,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? isFiltersLoading,
    bool? filtersLoaded,
    String? filtersLoadError,
    bool clearFiltersLoadError = false,
    bool? hasMore,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool clearFilterSelections = false,
    bool clearSearchQuery = false,
  }) {
    return SubCategoryStateData(
      products: products ?? this.products,
      companies: companies ?? this.companies,
      colors: colors ?? this.colors,
      materials: materials ?? this.materials,
      selectedCompanyId: clearFilterSelections
          ? null
          : (selectedCompanyId ?? this.selectedCompanyId),
      selectedColorId: clearFilterSelections
          ? null
          : (selectedColorId ?? this.selectedColorId),
      selectedMaterialId: clearFilterSelections
          ? null
          : (selectedMaterialId ?? this.selectedMaterialId),
      searchQuery: clearSearchQuery ? '' : (searchQuery ?? this.searchQuery),
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isFiltersLoading: isFiltersLoading ?? this.isFiltersLoading,
      filtersLoaded: filtersLoaded ?? this.filtersLoaded,
      filtersLoadError: clearFiltersLoadError
          ? null
          : (filtersLoadError ?? this.filtersLoadError),
      hasMore: hasMore ?? this.hasMore,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class SubCategoryInitialState extends SubCategoryStateData {
  const SubCategoryInitialState();
}
