class ContributionModel {
  final String? id;
  final String projectId;
  final String? supporterId;

  final String supporterName;
  final String supporterPhone;
  final String? supporterEmail;

  final double amount;
  final String transactionCode;
  final String paymentMethod;
  final String? message;
  final String status;
  final DateTime createdAt;
  final String? verifiedBy;
  final DateTime? verifiedAt;

  const ContributionModel({
    this.id,
    required this.projectId,
    this.supporterId,

    required this.supporterName,
    required this.supporterPhone,
    this.supporterEmail,

    required this.amount,
    required this.transactionCode,
    required this.paymentMethod,
    this.message,
    this.status = 'pending',
    required this.createdAt,
    this.verifiedBy,
    this.verifiedAt,
  });

  /// Convert to Appwrite document
  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'supporterId': supporterId,

      'supporterName': supporterName,
      'supporterPhone': supporterPhone,
      'supporterEmail': supporterEmail,

      'amount': amount,
      'transactionCode': transactionCode,
      'paymentMethod': paymentMethod,
      'message': message,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'verifiedBy': verifiedBy,
      'verifiedAt': verifiedAt?.toIso8601String(),
    };
  }

  /// Create model from Appwrite document
  factory ContributionModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return ContributionModel(
      id: map['\$id'],

      projectId: map['projectId'] ?? '',
      supporterId: map['supporterId'],

      supporterName:
          map['supporterName'] ?? '',
      supporterPhone:
          map['supporterPhone'] ?? '',
      supporterEmail:
          map['supporterEmail'],

      amount: (map['amount'] ?? 0)
          .toDouble(),

      transactionCode:
          map['transactionCode'] ?? '',

      paymentMethod:
          map['paymentMethod'] ?? '',

      message: map['message'],

      status:
          map['status'] ?? 'pending',

      createdAt: DateTime.parse(
        map['createdAt'],
      ),

      verifiedBy: map['verifiedBy'],

      verifiedAt:
          map['verifiedAt'] != null
              ? DateTime.parse(
                  map['verifiedAt'],
                )
              : null,
    );
  }

  ContributionModel copyWith({
    String? id,
    String? projectId,
    String? supporterId,

    String? supporterName,
    String? supporterPhone,
    String? supporterEmail,

    double? amount,
    String? transactionCode,
    String? paymentMethod,
    String? message,
    String? status,
    DateTime? createdAt,
    String? verifiedBy,
    DateTime? verifiedAt,
  }) {
    return ContributionModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      supporterId:
          supporterId ?? this.supporterId,

      supporterName:
          supporterName ??
              this.supporterName,

      supporterPhone:
          supporterPhone ??
              this.supporterPhone,

      supporterEmail:
          supporterEmail ??
              this.supporterEmail,

      amount: amount ?? this.amount,

      transactionCode:
          transactionCode ??
              this.transactionCode,

      paymentMethod:
          paymentMethod ??
              this.paymentMethod,

      message: message ?? this.message,

      status: status ?? this.status,

      createdAt:
          createdAt ?? this.createdAt,

      verifiedBy:
          verifiedBy ?? this.verifiedBy,

      verifiedAt:
          verifiedAt ?? this.verifiedAt,
    );
  }

  bool get isPending =>
      status == 'pending';

  bool get isVerified =>
      status == 'verified';

  bool get isRejected =>
      status == 'rejected';
}