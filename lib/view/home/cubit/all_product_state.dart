import 'package:flutter/foundation.dart';
import 'package:thredo/model/color_list_response.dart';
import 'package:thredo/model/company_list_response.dart';
import 'package:thredo/model/materials_list_response.dart';
import 'package:thredo/model/product_list_response.dart';
import 'package:thredo/widget/product_filter_bottom_sheet.dart';

abstract class AllProductState {
  const AllProductState();
}

class AllProductStateData extends AllProductState {
  const AllProductStateData({
    this.products = const [],
    this.companies = const [],
    this.colors = const [],
    this.materials = const [],
    this.selectedCompanyId,
    this.selectedColorId,
    this.selectedMaterialId,
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.isFiltersLoading = false,
    this.filtersLoaded = false,
    this.filtersLoadError,
    this.hasMore = true,
    this.errorMessage,
    this.searchQuery = '',
  });

  final List<ProductListData> products;
  final List<CompanyListData> companies;
  final List<ColorListData> colors;
  final List<MaterialsData> materials;

  final String? selectedCompanyId;
  final String? selectedColorId;
  final String? selectedMaterialId;

  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool isFiltersLoading;
  final bool filtersLoaded;
  final String? filtersLoadError;
  final bool hasMore;
  final String? errorMessage;
  final String searchQuery;

  bool get isSearching => searchQuery.trim().isNotEmpty;

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

  ProductFilterSheetState get filterSheetState => ProductFilterSheetState(
    companies: companies,
    colors: colors,
    materials: materials,
    selectedCompanyId: selectedCompanyId,
    selectedColorId: selectedColorId,
    selectedMaterialId: selectedMaterialId,
    isFiltersLoading: isFiltersLoading,
    filtersLoaded: filtersLoaded,
    filtersLoadError: filtersLoadError,
  );

  AllProductStateData copyWith({
    List<ProductListData>? products,
    List<CompanyListData>? companies,
    List<ColorListData>? colors,
    List<MaterialsData>? materials,
    String? selectedCompanyId,
    String? selectedColorId,
    String? selectedMaterialId,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? isFiltersLoading,
    bool? filtersLoaded,
    String? filtersLoadError,
    bool clearFiltersLoadError = false,
    bool? hasMore,
    String? errorMessage,
    String? searchQuery,
    bool clearErrorMessage = false,
    bool clearFilterSelections = false,
  }) {
    return AllProductStateData(
      products: products ?? this.products,
      companies: companies ?? this.companies,
      colors: colors ?? this.colors,
      materials: materials ?? this.materials,
      selectedCompanyId: clearFilterSelections ? null : (selectedCompanyId ?? this.selectedCompanyId),
      selectedColorId: clearFilterSelections ? null : (selectedColorId ?? this.selectedColorId),
      selectedMaterialId: clearFilterSelections ? null : (selectedMaterialId ?? this.selectedMaterialId),
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isFiltersLoading: isFiltersLoading ?? this.isFiltersLoading,
      filtersLoaded: filtersLoaded ?? this.filtersLoaded,
      filtersLoadError: clearFiltersLoadError ? null : (filtersLoadError ?? this.filtersLoadError),
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AllProductStateData &&
        listEquals(other.products, products) &&
        listEquals(other.companies, companies) &&
        listEquals(other.colors, colors) &&
        listEquals(other.materials, materials) &&
        other.selectedCompanyId == selectedCompanyId &&
        other.selectedColorId == selectedColorId &&
        other.selectedMaterialId == selectedMaterialId &&
        other.isInitialLoading == isInitialLoading &&
        other.isLoadingMore == isLoadingMore &&
        other.isFiltersLoading == isFiltersLoading &&
        other.filtersLoaded == filtersLoaded &&
        other.filtersLoadError == filtersLoadError &&
        other.hasMore == hasMore &&
        other.errorMessage == errorMessage &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(products),
    Object.hashAll(companies),
    Object.hashAll(colors),
    Object.hashAll(materials),
    selectedCompanyId,
    selectedColorId,
    selectedMaterialId,
    isInitialLoading,
    isLoadingMore,
    isFiltersLoading,
    filtersLoaded,
    filtersLoadError,
    hasMore,
    errorMessage,
    searchQuery,
  );
}

class AllProductInitialState extends AllProductStateData {
  const AllProductInitialState();
}
