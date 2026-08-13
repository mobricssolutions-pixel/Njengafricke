class ApprovalModel {
  final String? id;
  final String itemType;
  final String itemId;
  final String submittedBy;
  final String status;
  final String? adminId;
  final String? reviewNotes;
  final DateTime submittedAt;
  final DateTime? reviewedAt;

  const ApprovalModel({
    this.id,
    required this.itemType,
    required this.itemId,
    required this.submittedBy,
    required this.status,
    this.adminId,
    this.reviewNotes,
    required this.submittedAt,
    this.reviewedAt,
  });

  factory ApprovalModel.fromMap(Map<String, dynamic> map) {
    return ApprovalModel(
      id: map['\$id'],
      itemType: map['itemType'] ?? '',
      itemId: map['itemId'] ?? '',
      submittedBy: map['submittedBy'] ?? '',
      status: map['status'] ?? 'pending',
      adminId: map['adminId'],
      reviewNotes: map['reviewNotes'],
      submittedAt: DateTime.parse(map['submittedAt']),
      reviewedAt: map['reviewedAt'] != null
          ? DateTime.parse(map['reviewedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemType': itemType,
      'itemId': itemId,
      'submittedBy': submittedBy,
      'status': status,
      'adminId': adminId,
      'reviewNotes': reviewNotes,
      'submittedAt': submittedAt.toIso8601String(),
      'reviewedAt': reviewedAt?.toIso8601String(),
    };
  }
}