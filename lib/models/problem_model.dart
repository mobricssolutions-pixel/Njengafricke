class ProblemModel {

  final String title;
  final String description;
  final String category;
  final String location;
  final String createdBy;
  final String createdAt;

  ProblemModel({
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {

    return {
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }
}