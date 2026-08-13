class FundraiserModel {
  final String? id;
  final String title;
  final String description;
  final String? creatorId;
  final String category;
  final double goalAmount;
  final double currentAmount;
  final String paymentInstructions;
  final String? imageUrl;
  final String status;
  final DateTime createdAt;

  const FundraiserModel({
    this.id,
    required this.title,
    required this.description,
    this.creatorId,
    required this.category,
    required this.goalAmount,
    this.currentAmount = 0.0,
    required this.paymentInstructions,
    this.imageUrl,
    this.status = 'pending',
    required this.createdAt,
  });

  /// Percentage raised (0.0 - 1.0)
  double get progress {
    if (goalAmount <= 0) return 0;
    return (currentAmount / goalAmount).clamp(0.0, 1.0);
  }

  /// Amount remaining
  double get remainingAmount {
    return (goalAmount - currentAmount).clamp(0.0, goalAmount);
  }

  /// Convert to Appwrite document
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'creatorId': creatorId,
      'category': category,
      'goalAmount': goalAmount,
      'currentAmount': currentAmount,
      'paymentInstructions': paymentInstructions,
      'imageUrl': imageUrl,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create model from Appwrite document
  factory FundraiserModel.fromMap(Map<String, dynamic> map) {
    return FundraiserModel(
      id: map['\$id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      creatorId: map['creatorId'] ?? '',
      category: map['category'] ?? '',
      goalAmount: (map['goalAmount'] ?? 0).toDouble(),
      currentAmount: (map['currentAmount'] ?? 0).toDouble(),
      paymentInstructions: map['paymentInstructions'] ?? '',
      imageUrl: map['imageUrl'],
      status: map['status'] ?? 'pending',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  FundraiserModel copyWith({
    String? id,
    String? title,
    String? description,
    String? creatorId,
    String? category,
    double? goalAmount,
    double? currentAmount,
    String? paymentInstructions,
    String? imageUrl,
    String? status,
    DateTime? createdAt,
  }) {
    return FundraiserModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      category: category ?? this.category,
      goalAmount: goalAmount ?? this.goalAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      paymentInstructions:
          paymentInstructions ?? this.paymentInstructions,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}