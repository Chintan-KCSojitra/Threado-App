import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thredo/model/color_list_response.dart';
import 'package:thredo/model/company_list_response.dart';
import 'package:thredo/model/materials_list_response.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/widget/app_cached_image.dart';
import 'package:thredo/widget/app_loader.dart';
import 'package:thredo/widget/common_button.dart';
import 'package:thredo/widget/common_widgets.dart';
import 'package:thredo/widget/text_widget.dart';

Color productFilterHexToColor(String? hex) {
  if (hex == null || hex.isEmpty) return colorD9D9D9;
  var value = hex.replaceAll('#', '').trim();
  if (value.length == 6) value = 'FF$value';
  if (value.length != 8) return colorD9D9D9;
  return Color(int.parse(value, radix: 16));
}

class ProductFilterSheetState {
  const ProductFilterSheetState({
    this.companies = const [],
    this.colors = const [],
    this.materials = const [],
    this.selectedCompanyId,
    this.selectedColorId,
    this.selectedMaterialId,
    this.isFiltersLoading = false,
    this.filtersLoaded = false,
    this.filtersLoadError,
  });

  final List<CompanyListData> companies;
  final List<ColorListData> colors;
  final List<MaterialsData> materials;
  final String? selectedCompanyId;
  final String? selectedColorId;
  final String? selectedMaterialId;
  final bool isFiltersLoading;
  final bool filtersLoaded;
  final String? filtersLoadError;

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
}

void showProductFilterBottomSheet(
  BuildContext context, {
  required ProductFilterSheetState filterState,
  required VoidCallback onRetry,
  required VoidCallback onReset,
  required VoidCallback onApply,
  required ValueChanged<String?> onToggleCompany,
  required ValueChanged<String?> onToggleColor,
  required ValueChanged<String?> onToggleMaterial,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    enableDrag: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    backgroundColor: colorWhite,
    barrierColor: colorBlack.withValues(alpha: 0.45),
    builder: (_) => ProductFilterBottomSheet(
      filterState: filterState,
      onRetry: onRetry,
      onReset: onReset,
      onApply: onApply,
      onToggleCompany: onToggleCompany,
      onToggleColor: onToggleColor,
      onToggleMaterial: onToggleMaterial,
    ),
  );
}

class ProductFilterBottomSheet extends StatefulWidget {
  const ProductFilterBottomSheet({
    super.key,
    required this.filterState,
    required this.onRetry,
    required this.onReset,
    required this.onApply,
    required this.onToggleCompany,
    required this.onToggleColor,
    required this.onToggleMaterial,
  });

  final ProductFilterSheetState filterState;
  final VoidCallback onRetry;
  final VoidCallback onReset;
  final VoidCallback onApply;
  final ValueChanged<String?> onToggleCompany;
  final ValueChanged<String?> onToggleColor;
  final ValueChanged<String?> onToggleMaterial;

  @override
  State<ProductFilterBottomSheet> createState() =>
      _ProductFilterBottomSheetState();
}

class _ProductFilterBottomSheetState extends State<ProductFilterBottomSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.filterState;
    final sheetHeight = MediaQuery.sizeOf(context).height * 0.72;

    if (state.isFiltersLoading && !state.filtersLoaded) {
      return SizedBox(
        height: sheetHeight,
        child: const Center(
          child: AppLoader(size: 28, accentColor: colorCEAB8D),
        ),
      );
    }

    if (state.filtersLoadError != null && !state.filtersLoaded) {
      return SizedBox(
        height: sheetHeight,
        child: _FilterErrorView(
          message: state.filtersLoadError!,
          onRetry: widget.onRetry,
        ),
      );
    }

    return RepaintBoundary(
      child: SizedBox(
        height: sheetHeight,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: state.hasActiveFilters
                        ? () {
                            Navigator.pop(context);
                            widget.onReset();
                          }
                        : null,
                    child: TextWidget(
                      text: 'Reset',
                      textStyle: BaseTextStyle.text600.copyWith(
                        fontSize: 14.sp,
                        color: state.hasActiveFilters
                            ? colorCEAB8D
                            : colorD9D9D9,
                      ),
                    ),
                  ),
                  TextWidget(
                    text: state.hasActiveFilters
                        ? 'Filter (${state.activeFilterCount})'
                        : 'Filter',
                    textStyle: BaseTextStyle.text700.copyWith(
                      fontSize: 18.sp,
                      color: color09064A,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 32.sp,
                      width: 32.sp,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.sp),
                        border: Border.all(color: color09064A, width: 1.sp),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20.sp,
                        color: color09064A,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: colorE6E6E6, height: 1.sp),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: color09064A,
              unselectedLabelColor: color79747E,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.sp, color: colorE7E3DA),
              ),
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Company'),
                Tab(text: 'Colors'),
                Tab(text: 'Material'),
              ],
            ),
            heightBox(8.h),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const ClampingScrollPhysics(),
                children: [
                  _CompanyFilterTab(
                    companies: state.companies,
                    selectedCompanyId: state.selectedCompanyId,
                    onToggle: widget.onToggleCompany,
                  ),
                  _ColorsFilterTab(
                    colors: state.colors,
                    selectedColorId: state.selectedColorId,
                    onToggle: widget.onToggleColor,
                  ),
                  _MaterialFilterTab(
                    materials: state.materials,
                    selectedMaterialId: state.selectedMaterialId,
                    onToggle: widget.onToggleMaterial,
                  ),
                ],
              ),
            ),
            heightBox(6.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CommonButton(
                text: 'Apply Now',
                onTap: () {
                  Navigator.pop(context);
                  widget.onApply();
                },
              ),
            ),
            heightBox(12.h),
          ],
        ),
      ),
    );
  }
}

class _FilterErrorView extends StatelessWidget {
  const _FilterErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40.sp, color: color79747E),
            heightBox(12.h),
            TextWidget(
              text: message,
              textAlign: TextAlign.center,
              textStyle: BaseTextStyle.text400.copyWith(
                fontSize: 14.sp,
                color: color79747E,
              ),
            ),
            heightBox(16.h),
            CommonButton(text: 'Retry', onTap: onRetry),
          ],
        ),
      ),
    );
  }
}

class _CompanyFilterTab extends StatelessWidget {
  const _CompanyFilterTab({
    required this.companies,
    required this.selectedCompanyId,
    required this.onToggle,
  });

  final List<CompanyListData> companies;
  final String? selectedCompanyId;
  final ValueChanged<String?> onToggle;

  @override
  Widget build(BuildContext context) {
    if (companies.isEmpty) {
      return const Center(child: Text('No companies available'));
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: companies.length,
      separatorBuilder: (_, __) => SizedBox(height: 4.h),
      itemBuilder: (context, index) {
        final company = companies[index];
        final companyId = company.id?.toString();
        final isSelected =
            companyId != null && companyId == selectedCompanyId;

        return GestureDetector(
          onTap: () => onToggle(companyId),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorE7E3DA.withValues(alpha: 0.35)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
              border: isSelected
                  ? Border.all(color: colorE7E3DA, width: 1.5)
                  : null,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(42.sp),
                  child: (company.logoUrl != null &&
                          company.logoUrl.toString().isNotEmpty)
                      ? AppCachedImage(
                          memCacheWidth: 150,
                          memCacheHeight: 150,
                          imageUrl: company.logoUrl.toString(),
                          width: 42.w,
                          height: 42.h,
                          fit: BoxFit.cover,
                          errorAssetPath: PNGImages.imgThread1,
                        )
                      : Image.asset(
                          PNGImages.imgThread1,
                          width: 42.w,
                          height: 42.h,
                          fit: BoxFit.cover,
                        ),
                ),
                widthBox(14.w),
                Expanded(
                  child: TextWidget(
                    text: company.name ?? '',
                    fontSize: 16.sp,
                    color: isSelected ? color09064A : color79747E,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: colorCEAB8D, size: 20.sp),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ColorsFilterTab extends StatelessWidget {
  const _ColorsFilterTab({
    required this.colors,
    required this.selectedColorId,
    required this.onToggle,
  });

  final List<ColorListData> colors;
  final String? selectedColorId;
  final ValueChanged<String?> onToggle;

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) {
      return const Center(child: Text('No colors available'));
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 10.sp,
        mainAxisSpacing: 10.sp,
        mainAxisExtent: 56.sp,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final colorData = colors[index];
        final colorId = colorData.id?.toString();
        final isSelected = colorId != null && colorId == selectedColorId;
        final parsedColor = productFilterHexToColor(colorData.hexCode?.toString());

        return GestureDetector(
          onTap: () => onToggle(colorId),
          child: Container(
            decoration: BoxDecoration(
              color: parsedColor,
              borderRadius: BorderRadius.circular(12.sp),
              border: isSelected
                  ? Border.all(color: colorCEAB8D, width: 3.w)
                  : Border.all(color: colorE6E6E6, width: 1),
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: parsedColor.computeLuminance() > 0.5
                        ? colorBlack
                        : colorWhite,
                  )
                : null,
          ),
        );
      },
    );
  }
}

class _MaterialFilterTab extends StatelessWidget {
  const _MaterialFilterTab({
    required this.materials,
    required this.selectedMaterialId,
    required this.onToggle,
  });

  final List<MaterialsData> materials;
  final String? selectedMaterialId;
  final ValueChanged<String?> onToggle;

  @override
  Widget build(BuildContext context) {
    if (materials.isEmpty) {
      return const Center(child: Text('No materials available'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: materials.map((material) {
          final materialId = material.id?.toString();
          final isSelected =
              materialId != null && materialId == selectedMaterialId;

          return FilterChip(
            label: TextWidget(
              text: material.name ?? '',
              fontSize: 14.sp,
              color: isSelected ? colorWhite : color09064A,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            side: BorderSide(
              color: isSelected ? colorCEAB8D : color79747E,
              width: 1.w,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.r),
            ),
            selectedColor: colorCEAB8D,
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) => onToggle(materialId),
          );
        }).toList(),
      ),
    );
  }
}
