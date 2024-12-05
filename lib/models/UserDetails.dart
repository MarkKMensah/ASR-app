class UserDetailsModel {
  final String institutionOccupation;
  final String nativeLanguage;
  final double? proficiency;
  final String gender;
  final DateTime dateOfBirth;

  UserDetailsModel({
    required this.institutionOccupation,
    required this.nativeLanguage,
    this.proficiency,
    required this.gender,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toJson() => {
    'institution_occupation': institutionOccupation,
    'native_language': nativeLanguage,
    'proficiency': proficiency,
    'gender': gender,
    'date_of_birth': dateOfBirth.toIso8601String(),
  };
}