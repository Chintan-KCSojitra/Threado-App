import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thredo/api/dio_helper.dart';
import 'package:thredo/app_config.dart';
import 'package:thredo/model/company_list_response.dart';
import 'package:thredo/model/company_reviews_response.dart';
import 'package:thredo/model/product_list_response.dart';
import 'package:thredo/view/company/cubit/company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  CompanyCubit() : super(CompanyInitialState());

  static const int pageSize = 10;
  static const int reviewsPageSize = 10;

  CompanyStateData get dataState => state as CompanyStateData;

  Future<List<CompanyListData>> fetchCompaniesPage({
    required int pageKey,
  }) async {
    final query = <String, dynamic>{'page': pageKey, 'per_page': pageSize};
    final search = dataState.searchText.trim();
    if (search.isNotEmpty) {
      query['q'] = search;
    }

    final result = await DioHelper.getData(
      url: ApiConfig.companyListEP,
      query: query,
      isHeader: true,
      enableCache: false,
      forceRefresh: true,
    );

    if (result.statusCode == 200) {
      final response = CompanyListResponse.fromJson(result.data);
      return response.data ?? <CompanyListData>[];
    }
    throw Exception('Failed to fetch companies');
  }

  Future<List<ProductListData>> fetchCompanyProductsPage({
    required String companyId,
    required int page,
  }) async {
    final trimmedId = companyId.trim();
    if (trimmedId.isEmpty) return <ProductListData>[];

    final result = await DioHelper.getData(
      url: ApiConfig.productListEP,
      query: {
        'page': page,
        'per_page': pageSize,
        'company_id': trimmedId,
      },
      isHeader: true,
      enableCache: false,
      forceRefresh: true,
    );

    if (result.statusCode == 200) {
      final response = ProductListResponse.fromJson(result.data);
      return response.data ?? <ProductListData>[];
    }
    throw Exception('Failed to fetch company products');
  }

  void updateSearchText(String value) {
    emit(dataState.copyWith(searchText: value));
  }

  Future<List<CompanyReview>> fetchCompanyReviewsPage({
    required String companyId,
    required int page,
  }) async {
    final trimmedId = companyId.trim();
    if (trimmedId.isEmpty) return <CompanyReview>[];

    final result = await DioHelper.getData(
      url: ApiConfig.companyReviewsEP(trimmedId),
      query: {
        'page': page,
        'per_page': reviewsPageSize,
      },
      isHeader: true,
      enableCache: false,
      forceRefresh: true,
    );

    if (result.statusCode == 200) {
      final response = CompanyReviewsResponse.fromJson(result.data);
      return response.data ?? <CompanyReview>[];
    }
    throw Exception('Failed to fetch company reviews');
  }

  Future<bool> addCompanyReview({
    required String companyId,
    required int rating,
    required String reviewText,
  }) async {
    final result = await DioHelper.postData(
      url: ApiConfig.companyReviewsEP(companyId),
      data: {
        'rating': rating,
        'review_text': reviewText,
      },
      isHeader: true,
    );

    if (result.statusCode == 200 || result.statusCode == 201) {
      return true;
    }
    return false;
  }
}
