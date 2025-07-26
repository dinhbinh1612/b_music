class UserRegisterModel {
  final String email;
  final String password;
  final String username;
  final String gender;
  final String birthdate;

  UserRegisterModel({
    required this.email,
    required this.password,
    required this.username,
    required this.gender,
    required this.birthdate,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "username": username,
      "gender": gender,
      "birthdate": birthdate,
    };
  }
}
