import 'package:thredo/model/company_list_response.dart';

class CompanyReviewsResponse {
  CompanyReviewsResponse({this.success, this.message, this.data, this.pagination});

  CompanyReviewsResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CompanyReview.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  bool? success;
  String? message;
  List<CompanyReview>? data;
  Pagination? pagination;
}
