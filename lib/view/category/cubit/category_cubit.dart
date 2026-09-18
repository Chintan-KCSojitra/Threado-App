import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thredo/api/dio_helper.dart';
import 'package:thredo/app_config.dart';
import 'package:thredo/model/category_list_response.dart';
import 'package:thredo/view/category/cubit/category_state.dart';

class CategoryCubit extends Cubit<CategoryState>{
  CategoryCubit() : super(CategoryInitialState());

  static const int _pageSize = 10;
  bool _isRequestInProgress = false;
  int _page = 1;

  CategoryStateData get _dataState => state as CategoryStateData;

  Future<void> loadInitialCategories() async {
    if (_isRequestInProgress) return;
    // Skip if already loaded — prevents reload on tab switch
    if (_dataState.categories.isNotEmpty) return;
    await _load();
  }

  /// Force reload — used by pull-to-refresh
  Future<void> refresh() async {
    if (_isRequestInProgress) return;
    await _load();
  }

  Future<void> _load() async {
    _page = 1;
    emit(
      _dataState.copyWith(
        categories: [],
        isInitialLoading: true,
        isLoadingMore: false,
        hasMore: true,
        clearErrorMessage: true,
      ),
    );
    await _fetchCategories(isLoadMore: false);
  }

  Future<void> loadMoreCategories() async {
    if (_isRequestInProgress) return;
    final currentState = _dataState;
    if (!currentState.hasMore || currentState.isInitialLoading || currentState.isLoadingMore) return;
    emit(currentState.copyWith(isLoadingMore: true, clearErrorMessage: true));
    await _fetchCategories(isLoadMore: true);
  }

  Future<void> _fetchCategories({required bool isLoadMore}) async {
    _isRequestInProgress = true;
    try {
      final result = await DioHelper.getData(
        url: ApiConfig.categoryListEP,
        query: {'page': _page, 'per_page': _pageSize},
        isHeader: true,
      );

      if (result.statusCode == 200) {
        final response = CategoryListResponse.fromJson(result.data);
        final incomingCategories = response.data ?? [];
        final existingCategories = isLoadMore ? _dataState.categories : <CategoryData>[];
        final mergedCategories = [...existingCategories, ...incomingCategories];
        final hasNext = response.pagination?.hasNext ?? (incomingCategories.length == _pageSize);

        _page++;
        emit(
          _dataState.copyWith(
            categories: mergedCategories,
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
            errorMessage: 'Failed to fetch categories',
          ),
        );
      }
    } catch (_) {
      emit(
        _dataState.copyWith(
          isInitialLoading: false,
          isLoadingMore: false,
          errorMessage: 'Something went wrong while loading categories',
        ),
      );
    } finally {
      _isRequestInProgress = false;
    }
  }

}