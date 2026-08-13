class UserProfileModel {

  final List<dynamic> skills;
  final List<dynamic> talents;
  final List<dynamic> hobbies;
  final List<dynamic> abilities;

  UserProfileModel({
    required this.skills,
    required this.talents,
    required this.hobbies,
    required this.abilities,
  });

  Map<String, dynamic> toMap() {

    return {
      'skills': skills,
      'talents': talents,
      'hobbies': hobbies,
      'abilities': abilities,
    };
  }
}