enum CompanyApprovalStatus { pending, accepted, rejected }

class CompanyApprovalRequest {
  CompanyApprovalRequest({
    required this.id,
    required this.companyName,
    required this.companyLogoUrl,
    required this.requestedAt,
    this.subtitle,
    this.status = CompanyApprovalStatus.pending,
  });

  final String id;
  final String companyName;
  final String companyLogoUrl;
  final String? subtitle;
  final DateTime requestedAt;
  CompanyApprovalStatus status;

  CompanyApprovalRequest copyWith({CompanyApprovalStatus? status}) {
    return CompanyApprovalRequest(
      id: id,
      companyName: companyName,
      companyLogoUrl: companyLogoUrl,
      requestedAt: requestedAt,
      subtitle: subtitle,
      status: status ?? this.status,
    );
  }
}
