import 'package:thredo/res/image.dart';
import 'package:thredo/view/company/models/company_approval_request.dart';

/// Static incoming approval requests from other companies — replace with API later.
class CompanyApprovalStaticData {
  CompanyApprovalStaticData._();

  static List<CompanyApprovalRequest> initialRequests() => [
        CompanyApprovalRequest(
          id: 'req_1',
          companyName: 'Rainbow Threads Co.',
          companyLogoUrl: PNGImages.imgCompany2,
          subtitle: 'Partnership & catalog access',
          requestedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        CompanyApprovalRequest(
          id: 'req_2',
          companyName: 'Silk & Zari House',
          companyLogoUrl: PNGImages.imgCompany3,
          subtitle: 'Cross-listing request',
          requestedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        CompanyApprovalRequest(
          id: 'req_3',
          companyName: 'Metro Fabrics',
          companyLogoUrl: PNGImages.imgCompany1,
          subtitle: 'Supplier network invite',
          requestedAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
        ),
        CompanyApprovalRequest(
          id: 'req_4',
          companyName: 'Golden Stitch Mills',
          companyLogoUrl: PNGImages.imgCompany2,
          subtitle: 'Bulk order collaboration',
          requestedAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
      ];
}
