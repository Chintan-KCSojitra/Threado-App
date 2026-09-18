import 'package:thredo/widget/app_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/view/wishlist/cubit/wish_list_cubit.dart';
import 'package:thredo/view/wishlist/cubit/wish_list_state.dart';
import 'package:thredo/widget/app_loader.dart';
import 'package:thredo/widget/common_appbar.dart';
import 'package:thredo/widget/text_widget.dart';

class WishListScreen extends StatelessWidget{
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WishListCubit()..getWishList(),
      child: const _WishListScreenView(),
    );
  }
}

class _WishListScreenView extends StatefulWidget {
  const _WishListScreenView();

  @override
  State<_WishListScreenView> createState() => _WishListScreenState();
}

class _WishListScreenState extends BaseStatefulWidgetState<_WishListScreenView> {

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const CommonAppBar(title: 'Wishlist');
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocBuilder<WishListCubit, WishListState>(
      builder: (context, state) {
        final cubit = context.read<WishListCubit>();

        if (state is WishListLoadingState && cubit.wishListData.isEmpty) {
          return AppLoader.centered(accentColor: colorCEAB8D);
        }

        if (cubit.wishListData.isEmpty) {
          return Center(
            child: TextWidget(
              text: 'No items in your wishlist yet',
              textStyle: BaseTextStyle.text500.copyWith(
                fontSize: 16.sp,
                color: color79747E,
              ),
            ),
          );
        }

        return Container(
          width: screenSize.width,
          height: screenSize.height,
          color: backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.72,
            ),
            itemCount: cubit.wishListData.length,
            itemBuilder: (context, index) {
              final item = cubit.wishListData[index];
              final product = item.product;
              if (product == null) return const SizedBox();

              String imageUrl = '';
              if (product.media != null && product.media!.isNotEmpty) {
                try {
                  imageUrl = product.media!.firstWhere(
                    (m) => m.mediaType?.toLowerCase() == 'image' && (m.url?.isNotEmpty ?? false),
                  ).url ?? '';
                } catch (_) {
                  imageUrl = product.media!.first.url ?? '';
                }
              }

              return Container(
                decoration: BoxDecoration(
                  color: colorWhite,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: colorE6E6E6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                            child: imageUrl.isEmpty
                                ? Image.asset(PNGImages.imgCompany2, fit: BoxFit.cover, width: double.infinity)
                                : AppCachedImage(
                                    memCacheWidth: 400,
                                    memCacheHeight: 400,
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    showShimmer: false,
                                    errorAssetPath: PNGImages.imgCompany2,
                                  ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: product.name ?? 'Product',
                                textStyle: BaseTextStyle.text600.copyWith(
                                  fontSize: 14.sp,
                                  color: color09064A,
                                ),
                              ),
                              /*heightBox(4.h),
                              TextWidget(
                                text: '₹${product.price ?? 0}',
                                textStyle: BaseTextStyle.text700.copyWith(
                                  fontSize: 14.sp,
                                  color: colorPrimary,
                                ),
                              ),*/
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: GestureDetector(
                        onTap: () {
                          if (item.productId != null) {
                            cubit.removeFromWishlist(item.productId!);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: colorWhite.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ]
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: const Color(0xFFE56A6A),
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate(delay: (index * 40).ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
            },
          ),
        );
      },
    );
  }
}
