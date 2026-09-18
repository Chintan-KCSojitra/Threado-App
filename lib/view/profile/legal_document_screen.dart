import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thredo/app_config.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/legal/legal_document_type.dart';
import 'package:thredo/legal/thredo_legal_content.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/widget/common_appbar.dart';
import 'package:thredo/widget/common_widgets.dart';
import 'package:thredo/widget/text_widget.dart';

class LegalDocumentScreen extends StatefulWidget {
  const LegalDocumentScreen({
    super.key,
    required this.title,
    required this.documentType,
  });

  final String title;
  final LegalDocumentType documentType;

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState
    extends BaseStatefulWidgetState<LegalDocumentScreen> {
  late final List<LegalSection> _sections;

  @override
  void initState() {
    super.initState();
    _sections = ThredoLegalContent.sectionsFor(widget.documentType);
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CommonAppBar(
      title: widget.title,
      leadingIc: SVGImages.icArrowBack,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final lastUpdated = widget.documentType.lastUpdated;

    return ColoredBox(
      color: colorF9FDFF,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: colorE7E3DA.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: AppConfig.appName,
                  textStyle: BaseTextStyle.text700.copyWith(
                    fontSize: 18.sp,
                    color: color09064A,
                  ),
                ),
                heightBox(6.h),
                TextWidget(
                  text: 'Last updated: $lastUpdated',
                  textStyle: BaseTextStyle.text400.copyWith(
                    fontSize: 13.sp,
                    color: color79747E,
                  ),
                ),
                heightBox(8.h),
                TextWidget(
                  text:
                      'Please read this document carefully. It applies to your use of the ${AppConfig.appName} app for thread and textile discovery.',
                  textHeight: 1.45,
                  textStyle: BaseTextStyle.text400.copyWith(
                    fontSize: 13.sp,
                    color: color79747E,
                  ),
                ),
              ],
            ),
          ),
          heightBox(20.h),
          ..._sections.map(_buildSection),
        ],
      ),
    );
  }

  Widget _buildSection(LegalSection section) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: section.title,
            textStyle: BaseTextStyle.text700.copyWith(
              fontSize: 16.sp,
              color: color09064A,
            ),
          ),
          heightBox(10.h),
          ...section.paragraphs.map(
            (paragraph) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: TextWidget(
                text: paragraph,
                textHeight: 1.5,
                textStyle: BaseTextStyle.text400.copyWith(
                  fontSize: 14.sp,
                  color: color79747E,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
