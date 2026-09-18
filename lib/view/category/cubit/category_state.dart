import 'package:thredo/model/category_list_response.dart';

abstract class CategoryState {}

class CategoryStateData extends CategoryState {
  CategoryStateData({
    this.categories = const [],
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.errorMessage,
  });

  final List<CategoryData> categories;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  CategoryStateData copyWith({
    List<CategoryData>? categories,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CategoryStateData(
      categories: categories ?? this.categories,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class CategoryInitialState extends CategoryStateData {}
