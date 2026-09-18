import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/model/company_list_response.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/view/company/cubit/company_cubit.dart';
import 'package:thredo/view/company/widgets/company_review_tile.dart';
import 'package:thredo/widget/app_loader.dart';
import 'package:thredo/widget/common_appbar.dart';
import 'package:thredo/widget/text_widget.dart';

class CompanyReviewsScreen extends StatelessWidget {
  const CompanyReviewsScreen({
    super.key,
    required this.companyId,
    required this.companyName,
  });

  final String companyId;
  final String companyName;

  @override
  Widget build(BuildContext context) {
    return _CompanyReviewsView(
      companyId: companyId,
      companyName: companyName,
    );
  }
}

class _CompanyReviewsView extends StatefulWidget {
  const _CompanyReviewsView({
    required this.companyId,
    required this.companyName,
  });

  final String companyId;
  final String companyName;

  @override
  State<_CompanyReviewsView> createState() => _CompanyReviewsViewState();
}

class _CompanyReviewsViewState
    extends BaseStatefulWidgetState<_CompanyReviewsView> {
  late final CompanyCubit _companyCubit;
  late final PagingController<int, CompanyReview> _pagingController;

  @override
  void initState() {
    super.initState();
    _companyCubit = CompanyCubit();
    _pagingController = PagingController<int, CompanyReview>(
      getNextPageKey: (state) {
        final pages = state.pages;
        if (pages == null || pages.isEmpty) return 1;
        final lastPage = pages.last;
        if (lastPage.length < CompanyCubit.reviewsPageSize) return null;
        final lastKey = state.keys?.last ?? 1;
        return lastKey <= 0 ? 2 : lastKey + 1;
      },
      fetchPage: (page) => _companyCubit.fetchCompanyReviewsPage(
        companyId: widget.companyId,
        page: page <= 0 ? 1 : page,
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _companyCubit.close();
    super.dispose();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CommonAppBar(
      title: l10n.allReviews,
      titleWidget: Padding(
        padding: const EdgeInsets.only(top: 11),
        child: TextWidget(
          text: l10n.allReviews,
          color: colorBlack,
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return RefreshIndicator(
      color: colorPrimary,
      onRefresh: () async {
        _pagingController.refresh();
        await Future<void>.delayed(const Duration(milliseconds: 400));
      },
      child: PagingListener<int, CompanyReview>(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) {
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
                  child: TextWidget(
                    text: widget.companyName,
                    textStyle: BaseTextStyle.text600.copyWith(
                      fontSize: 15.sp,
                      color: color09064A,
                    ),
                  ),
                ),
              ),
              PagedSliverList<int, CompanyReview>(
                state: state,
                fetchNextPage: fetchNextPage,
                builderDelegate: PagedChildBuilderDelegate<CompanyReview>(
                  itemBuilder: (context, review, index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
                      child: CompanyReviewTile(review: review),
                    );
                  },
                  firstPageProgressIndicatorBuilder: (_) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.h),
                    child: AppLoader.centered(accentColor: colorCEAB8D),
                  ),
                  newPageProgressIndicatorBuilder: (_) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: AppLoader.centered(accentColor: colorCEAB8D),
                  ),
                  noItemsFoundIndicatorBuilder: (_) => Padding(
                    padding: EdgeInsets.all(24.w),
                    child: TextWidget(
                      text: l10n.noReviewsYet,
                      textAlign: TextAlign.center,
                      textStyle: BaseTextStyle.text500.copyWith(
                        fontSize: 14.sp,
                        color: color79747E,
                      ),
                    ),
                  ),
                  firstPageErrorIndicatorBuilder: (_) => Padding(
                    padding: EdgeInsets.all(24.w),
                    child: TextWidget(
                      text: 'Failed to load reviews',
                      textAlign: TextAlign.center,
                      textStyle: BaseTextStyle.text500.copyWith(
                        fontSize: 14.sp,
                        color: color79747E,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 24.h)),
            ],
          );
        },
      ),
    );
  }
}
